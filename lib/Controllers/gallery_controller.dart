import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/photo_model.dart';
import '../services/api_endpoints.dart';
import '../services/api_service.dart';
import '../utils/app_colors.dart';

class GalleryController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isUploading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<PhotoModel> photos = <PhotoModel>[].obs;
  final RxInt totalPhotosCount = 0.obs;
  final RxString totalStorageUsed = '16.4 MB'.obs;

  Future<void> fetchMyPhotos({String? token}) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await ApiService.get(
        ApiEndpoints.myPhotos,
        token: token,
      );

      final List dataList = response is List
          ? response
          : (response['data'] ?? response['photos'] ?? response['results'] ?? []);

      photos.value = dataList.map((e) => PhotoModel.fromJson(e)).toList();
      totalPhotosCount.value = response['totalPhotos'] ?? response['total'] ?? photos.length;
      if (response['storageUsed'] != null) {
        totalStorageUsed.value = response['storageUsed'].toString();
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addPhoto({
    required String title,
    required String imageUrl,
    String? size,
    String? token,
  }) async {
    isUploading.value = true;
    try {
      final response = await ApiService.post(
        ApiEndpoints.uploadPhoto,
        {
          'title': title,
          'titleText': title,
          'imageUrl': imageUrl,
          'url': imageUrl,
          'size': size ?? '3.2 MB',
          'date': 'Today',
        },
        token: token,
      );

      // Add to local list or refetch
      if (response != null && response is Map && response.containsKey('data')) {
        photos.insert(0, PhotoModel.fromJson(response['data']));
      } else {
        photos.insert(
          0,
          PhotoModel(
            id: DateTime.now().millisecondsSinceEpoch,
            title: title,
            imageUrl: imageUrl,
            size: size ?? '3.2 MB',
            date: 'Today',
          ),
        );
      }

      Get.back(); // Close modal

      Get.snackbar(
        'Success',
        'Photo added successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: AppColors.white,
      );

      fetchMyPhotos(token: token);
    } catch (e) {
      Get.snackbar(
        'Upload Failed',
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: AppColors.white,
      );
    } finally {
      isUploading.value = false;
    }
  }
}
