import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:live_test_project/models/photo_model.dart';
import 'package:live_test_project/utils/app_colors.dart';
import 'package:live_test_project/views/screens/login_screen.dart';
import 'package:live_test_project/views/screens/widgets/gallery_card.dart';
import 'package:live_test_project/views/screens/widgets/stats_row.dart';

void main() {
  tearDown(() {
    Get.reset();
  });

  group('PhotoModel.fromJson', () {
    test('parses numeric fileSize, ISO createdAt, and AI badge correctly', () {
      final photo = PhotoModel.fromJson({
        '_id': '6a79dceb8b55dc44becf5e07',
        'image':
            'https://na8ure.sfo3.digitaloceanspaces.com/ai-images/1786371306900357932444.png',
        'fileSize': 1.0479,
        'createdAt': '2026-08-10T14:15:07.222Z',
        'isFavorite': false,
      });

      expect(photo.id, '6a79dceb8b55dc44becf5e07');
      expect(photo.fileSize, closeTo(1.0479, 0.0001));
      expect(photo.formattedSize, '1.05 MB');
      expect(photo.isAi, isTrue);
      expect(photo.date, contains('Aug 2026'));
      expect(photo.isFavorite, isFalse);
    });

    test('parses regular photo without AI badge', () {
      final photo = PhotoModel.fromJson({
        '_id': '6a8aff90c3f347e0ee423a02',
        'image': 'https://na8ure.sfo3.digitaloceanspaces.com/images/220552',
        'fileSize': 3.869,
        'createdAt': '2026-08-23T14:11:28.023Z',
        'isFavorite': true,
      });

      expect(photo.formattedSize, '3.87 MB');
      expect(photo.isAi, isFalse);
      expect(photo.isFavorite, isTrue);
    });
  });

  testWidgets('StatsRow displays total photos and storage used',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StatsRow(totalPhotos: 9, storageUsed: '16.4 MB'),
        ),
      ),
    );

    expect(find.text('Total Photos'), findsOneWidget);
    expect(find.text('9'), findsOneWidget);
    expect(find.text('Storage Used'), findsOneWidget);
    expect(find.text('16.4 MB'), findsOneWidget);
  });

  testWidgets('GalleryCard displays AI badge when photo is AI-generated',
      (WidgetTester tester) async {
    const aiPhoto = PhotoModel(
      id: '1',
      title: 'AI Photo',
      imageUrl: '',
      fileSize: 1.0479,
      date: '10 Aug 2026',
      isFavorite: false,
      isAi: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 180,
            height: 220,
            child: GalleryCard(
              photo: aiPhoto,
              gradientColors: AppColors.cardGradients.last,
            ),
          ),
        ),
      ),
    );

    expect(find.text('AI'), findsOneWidget);
    expect(find.text('1.05 MB'), findsOneWidget);
    expect(find.text('10 Aug 2026'), findsOneWidget);
  });

  testWidgets('LoginScreen renders key Figma UI elements',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: LoginScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Google'), findsOneWidget);
    expect(find.text('Apple'), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);
  });
}
