import 'package:aigymbuddy/common/app_router.dart';
import 'package:aigymbuddy/common/color_extension.dart';
import 'package:aigymbuddy/common/date_time_utils.dart';
import 'package:aigymbuddy/common/localization/app_language_scope.dart';
import 'package:aigymbuddy/common_widget/round_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'photo_progress_models.dart';
import 'photo_progress_sample_data.dart';
import 'photo_progress_strings.dart';

class PhotoProgressView extends StatefulWidget {
  const PhotoProgressView({super.key});

  @override
  State<PhotoProgressView> createState() => _PhotoProgressViewState();
}

class _PhotoProgressViewState extends State<PhotoProgressView> {
  bool _isReminderVisible = true;
  final List<PhotoProgressGroup> _photoGroups = List.of(samplePhotoGroups);

  @override
  Widget build(BuildContext context) {
    final localize = context.localize;
    final media = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: _buildAppBar(localize),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isReminderVisible)
              _ReminderCard(
                onDismissed: () => setState(() => _isReminderVisible = false),
              ),
            _EducationCard(media: media, localize: localize),
            _CompareCard(localize: localize, onPressed: _goToComparison),
            _GalleryHeader(localize: localize, onSeeMore: _showGalleryInfo),
            ..._photoGroups.map((group) => _PhotoGroupTile(group: group)),
          ],
        ),
      ),
      floatingActionButton: _CaptureButton(onPressed: _onCapturePhoto),
    );
  }

  PreferredSizeWidget _buildAppBar(Localizer localize) {
    return AppBar(
      backgroundColor: TColor.white,
      centerTitle: true,
      elevation: 0,
      leadingWidth: 0,
      leading: const SizedBox.shrink(),
      title: Text(
        localize(PhotoProgressTexts.title),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
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
        ),
      ],
    );
  }

  void _goToComparison() {
    context.pushNamed(AppRoute.photoComparisonName);
  }

  void _showGalleryInfo() {
    _showSnackBar(context.localize(PhotoProgressTexts.galleryInfo));
  }

  void _onCapturePhoto() {
    _showSnackBar(context.localize(PhotoProgressTexts.launchingCamera));
  }

  void _showMoreOptions() {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        final localize = sheetContext.localize;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: Text(localize(PhotoProgressTexts.manageReminders)),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _showSnackBar(localize(PhotoProgressTexts.reminderSettings));
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: Text(localize(PhotoProgressTexts.clearGallery)),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _showSnackBar(localize(PhotoProgressTexts.galleryCleared));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ReminderCard extends StatelessWidget {
  const _ReminderCard({required this.onDismissed});

  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    final localize = context.localize;
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
                  Text(
                    localize(PhotoProgressTexts.reminderTitle),
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    localize(PhotoProgressTexts.reminderSubtitle),
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
              onPressed: onDismissed,
              icon: Icon(Icons.close, color: TColor.gray, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _EducationCard extends StatelessWidget {
  const _EducationCard({required this.media, required this.localize});

  final Size media;
  final Localizer localize;

  @override
  Widget build(BuildContext context) {
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
                  localize(PhotoProgressTexts.educationDescription),
                  style: TextStyle(color: TColor.black, fontSize: 12),
                ),
                const Spacer(),
                SizedBox(
                  width: 120,
                  height: 36,
                  child: RoundButton(
                    title: localize(PhotoProgressTexts.learnMoreButton),
                    fontSize: 12,
                    onPressed: () => ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(
                            localize(PhotoProgressTexts.learnMoreInfo),
                          ),
                        ),
                      ),
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
}

class _CompareCard extends StatelessWidget {
  const _CompareCard({
    required this.localize,
    required this.onPressed,
  });

  final Localizer localize;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
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
            localize(PhotoProgressTexts.compareTitle),
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
              title: localize(PhotoProgressTexts.compareButton),
              type: RoundButtonType.bgGradient,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              onPressed: onPressed,
            ),
          ),
        ],
      ),
    );
  }
}

class _GalleryHeader extends StatelessWidget {
  const _GalleryHeader({
    required this.localize,
    required this.onSeeMore,
  });

  final Localizer localize;
  final VoidCallback onSeeMore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            localize(PhotoProgressTexts.galleryTitle),
            style: TextStyle(
              color: TColor.black,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextButton(
            onPressed: onSeeMore,
            child: Text(
              localize(PhotoProgressTexts.seeMoreButton),
              style: TextStyle(color: TColor.gray),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoGroupTile extends StatelessWidget {
  const _PhotoGroupTile({required this.group});

  final PhotoProgressGroup group;

  @override
  Widget build(BuildContext context) {
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
              separatorBuilder: (_, __) => const SizedBox(width: 8),
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
}

class _CaptureButton extends StatelessWidget {
  const _CaptureButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
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
    );
  }
}
