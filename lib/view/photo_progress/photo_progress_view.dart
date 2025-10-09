import 'package:aigymbuddy/common/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/color_extension.dart';
import '../../common/date_time_utils.dart';
import '../../common_widget/round_button.dart';

class PhotoProgressView extends StatefulWidget {
  const PhotoProgressView({super.key});

  @override
  State<PhotoProgressView> createState() => _PhotoProgressViewState();
}

class _PhotoProgressViewState extends State<PhotoProgressView> {
  final List<_PhotoProgressGroup> _photoGroups = [
    _PhotoProgressGroup(
      date: DateTime(2023, 6, 2),
      photos: [
        'assets/img/pp_1.png',
        'assets/img/pp_2.png',
        'assets/img/pp_3.png',
        'assets/img/pp_4.png',
      ],
    ),
    _PhotoProgressGroup(
      date: DateTime(2023, 5, 5),
      photos: [
        'assets/img/pp_5.png',
        'assets/img/pp_6.png',
        'assets/img/pp_7.png',
        'assets/img/pp_8.png',
      ],
    ),
  ];

  bool _isReminderVisible = true;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leadingWidth: 0,
        leading: const SizedBox.shrink(),
        title: Text(
          'Progress Photo',
          style: TextStyle(
            color: TColor.black,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showMoreOptions,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            icon: Container(
              decoration: BoxDecoration(
                color: TColor.lightGray,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                'assets/img/more_btn.png',
                width: 16,
                height: 16,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isReminderVisible) _buildReminderCard(),
            _buildEducationCard(media),
            _buildCompareCard(),
            _buildGalleryHeader(),
            ..._photoGroups.map(_buildPhotoGroup),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onCapturePhoto,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: TColor.secondaryG),
            borderRadius: BorderRadius.circular(100),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.photo_camera, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildReminderCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xffFFE5E5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: TColor.white,
                borderRadius: BorderRadius.circular(30),
              ),
              width: 50,
              height: 50,
              alignment: Alignment.center,
              child: Image.asset(
                'assets/img/date_notifi.png',
                width: 30,
                height: 30,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reminder!',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Next photos fall on July 08',
                    style: TextStyle(
                      color: TColor.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => setState(() => _isReminderVisible = false),
              icon: Icon(Icons.close, color: TColor.gray, size: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationCard(Size media) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        height: media.width * 0.4,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              TColor.primaryColor2.withValues(alpha: 0.4),
              TColor.primaryColor1.withValues(alpha: 0.4),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  'Track your progress each\nmonth with photos',
                  style: TextStyle(color: TColor.black, fontSize: 12),
                ),
                const Spacer(),
                SizedBox(
                  width: 120,
                  height: 36,
                  child: RoundButton(
                    title: 'Learn More',
                    fontSize: 12,
                    onPressed: () => _showSnackBar('Tutorial coming soon.'),
                  ),
                ),
              ],
            ),
            Image.asset(
              'assets/img/progress_each_photo.png',
              width: media.width * 0.35,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompareCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: TColor.primaryColor2.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Compare my photo',
            style: TextStyle(
              color: TColor.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            width: 110,
            height: 32,
            child: RoundButton(
              title: 'Compare',
              type: RoundButtonType.bgGradient,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              onPressed: () => context.pushNamed(AppRoute.photoComparisonName),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Gallery',
            style: TextStyle(
              color: TColor.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextButton(
            onPressed: () => _showSnackBar('Opening full gallery soon.'),
            child: Text('See more', style: TextStyle(color: TColor.gray)),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGroup(_PhotoProgressGroup group) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8, top: 8),
            child: Text(
              DateTimeUtils.formatDate(group.date, pattern: 'd MMMM'),
              style: TextStyle(color: TColor.gray, fontSize: 12),
            ),
          ),
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: group.photos.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final photo = group.photos[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    photo,
                    width: 110,
                    height: 110,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Manage reminders'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showSnackBar('Reminder settings coming soon.');
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Clear gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showSnackBar('Gallery cleared (demo).');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onCapturePhoto() {
    _showSnackBar('Launching camera...');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _PhotoProgressGroup {
  const _PhotoProgressGroup({required this.date, required this.photos});

  final DateTime date;
  final List<String> photos;
}
