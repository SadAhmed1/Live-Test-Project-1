import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/gallery_controller.dart';
import '../../models/photo_model.dart';
import '../../utils/app_colors.dart';
import 'widgets/add_photo_dialog.dart';
import 'widgets/gallery_card.dart';
import 'widgets/stats_row.dart';

class HomeScreen extends StatefulWidget {
  final String? token;
  final String? userName;

  const HomeScreen({super.key, this.token, this.userName});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late final GalleryController _galleryController;

  final List<Color> _cardColors = [
    AppColors.cardPurple,
    AppColors.cardBlue,
    AppColors.cardOrange,
    AppColors.cardGreen,
  ];

  final List<PhotoModel> _fallbackPhotos = [
    PhotoModel(id: 1, title: 'Photo 1', imageUrl: '', size: '3.87 MB', date: '22 Aug 2026', isFavorite: false),
    PhotoModel(id: 2, title: 'Photo 2', imageUrl: '', size: '3.08 MB', date: '23 Aug 2026', isFavorite: false),
    PhotoModel(id: 3, title: 'Photo 3', imageUrl: '', size: '2.05 MB', date: '17 Aug 2026', isFavorite: true),
    PhotoModel(id: 4, title: 'Photo 4', imageUrl: '', size: '1.05 MB', date: '10 Aug 2026', isFavorite: false),
  ];

  @override
  void initState() {
    super.initState();
    _galleryController = Get.put(GalleryController());
    _galleryController.fetchMyPhotos(token: widget.token);
  }

  void _showAddPhotoBottomSheet() {
    Get.bottomSheet(
      AddPhotoDialog(token: widget.token),
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              Obx(() => StatsRow(
                    totalPhotos: _galleryController.photos.isNotEmpty
                        ? _galleryController.photos.length
                        : 9,
                    storageUsed: _galleryController.totalStorageUsed.value,
                  )),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Uploads',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _galleryController.fetchMyPhotos(token: widget.token),
                    child: const Text(
                      'See all',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (_galleryController.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  );
                }

                final displayPhotos = _galleryController.photos.isNotEmpty
                    ? _galleryController.photos
                    : _fallbackPhotos;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayPhotos.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    return GalleryCard(
                      photo: displayPhotos[index],
                      cardColor: _cardColors[index % _cardColors.length],
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),

      // Custom Pixel-Perfect Bottom Navigation Bar matching Figma
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(icon: Icons.home_rounded, label: 'Home', index: 0),
              _buildNavItem(icon: Icons.photo_library_outlined, label: 'Gallery', index: 1),
              
              // Center Plus Button
              GestureDetector(
                onTap: _showAddPhotoBottomSheet,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, color: AppColors.white, size: 26),
                ),
              ),

              _buildNavItem(icon: Icons.favorite_border_rounded, label: 'Favorites', index: 2),
              _buildNavItem(icon: Icons.person_outline_rounded, label: 'Profile', index: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.userName != null ? 'Welcome back, ${widget.userName}' : 'Welcome back',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'My Gallery',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.lightGrey),
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: AppColors.black,
            size: 22,
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 22,
            color: isSelected ? AppColors.primary : AppColors.grey,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? AppColors.primary : AppColors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
