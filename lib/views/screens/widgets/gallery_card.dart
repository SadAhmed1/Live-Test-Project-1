import 'package:flutter/material.dart';
import '../../../models/photo_model.dart';
import '../../../utils/app_colors.dart';

class GalleryCard extends StatelessWidget {
  final PhotoModel photo;
  final Color cardColor;

  const GalleryCard({
    super.key,
    required this.photo,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        children: [
          // Top Image Thumbnail Area
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: cardColor.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  Center(
                    child: photo.imageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              photo.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (ctx, err, stack) => const Icon(
                                Icons.image_outlined,
                                size: 44,
                                color: AppColors.white,
                              ),
                            ),
                          )
                        : const Icon(
                            Icons.image_outlined,
                            size: 44,
                            color: AppColors.white,
                          ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        photo.isFavorite ? Icons.favorite : Icons.favorite_border,
                        size: 14,
                        color: photo.isFavorite ? Colors.red : AppColors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Details Area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  photo.size,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  photo.date,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
