import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/gallery_controller.dart';
import '../../../utils/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class AddPhotoDialog extends StatefulWidget {
  final String? token;

  const AddPhotoDialog({super.key, this.token});

  @override
  State<AddPhotoDialog> createState() => _AddPhotoDialogState();
}

class _AddPhotoDialogState extends State<AddPhotoDialog> {
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();
  final _sizeController = TextEditingController(text: '3.5 MB');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GalleryController galleryController = Get.find<GalleryController>();

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add New Photo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.grey),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _titleController,
              labelText: 'Photo Title',
              hintText: 'Enter photo title',
              prefixIcon: Icons.title_rounded,
              validator: (val) =>
                  val == null || val.isEmpty ? 'Enter photo title' : null,
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: _urlController,
              labelText: 'Image URL',
              hintText: 'https://example.com/photo.jpg',
              prefixIcon: Icons.link_rounded,
              validator: (val) =>
                  val == null || val.isEmpty ? 'Enter image URL' : null,
            ),
            const SizedBox(height: 14),
            CustomTextField(
              controller: _sizeController,
              labelText: 'Size (Optional)',
              hintText: 'e.g. 2.4 MB',
              prefixIcon: Icons.sd_card_outlined,
            ),
            const SizedBox(height: 24),
            Obx(() {
              return CustomButton(
                text: 'UPLOAD PHOTO',
                isLoading: galleryController.isUploading.value,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    galleryController.addPhoto(
                      title: _titleController.text.trim(),
                      imageUrl: _urlController.text.trim(),
                      size: _sizeController.text.trim(),
                      token: widget.token,
                    );
                  }
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
