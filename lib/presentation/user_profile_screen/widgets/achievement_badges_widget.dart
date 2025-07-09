import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementBadgesWidget extends StatefulWidget {
  final List<Map<String, dynamic>> achievements;

  const AchievementBadgesWidget({
    Key? key,
    required this.achievements,
  }) : super(key: key);

  @override
  State<AchievementBadgesWidget> createState() =>
      _AchievementBadgesWidgetState();
}

class _AchievementBadgesWidgetState extends State<AchievementBadgesWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationControllers = List.generate(
      widget.achievements.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 800),
        vsync: this,
      ),
    );

    _scaleAnimations = _animationControllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ));
    }).toList();

    // Start animations with delays
    for (int i = 0; i < _animationControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) {
          _animationControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'অর্জন ব্যাজ',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 3.w,
              mainAxisSpacing: 2.h,
              childAspectRatio: 0.8,
            ),
            itemCount: widget.achievements.length,
            itemBuilder: (context, index) {
              final achievement = widget.achievements[index];
              return AnimatedBuilder(
                animation: _scaleAnimations[index],
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimations[index].value,
                    child: _buildAchievementBadge(achievement),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementBadge(Map<String, dynamic> achievement) {
    final isUnlocked = achievement['isUnlocked'] as bool;
    final color = Color(achievement['color'] as int);

    return GestureDetector(
      onTap: () => _showAchievementDetails(achievement),
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: isUnlocked
              ? color.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUnlocked
                ? color.withValues(alpha: 0.3)
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: isUnlocked
                    ? color.withValues(alpha: 0.2)
                    : AppTheme.lightTheme.colorScheme.surface,
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: achievement['icon'] as String,
                color: isUnlocked
                    ? color
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.5),
                size: 24,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              achievement['title'] as String,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: isUnlocked
                    ? color
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                        .withValues(alpha: 0.5),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showAchievementDetails(Map<String, dynamic> achievement) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.bottomSheetTheme.backgroundColor,
      shape: AppTheme.lightTheme.bottomSheetTheme.shape,
      builder: (context) {
        final isUnlocked = achievement['isUnlocked'] as bool;
        final color = Color(achievement['color'] as int);

        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 3.h),
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: isUnlocked
                      ? color.withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.surface,
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: achievement['icon'] as String,
                  color: isUnlocked
                      ? color
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.5),
                  size: 48,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                achievement['title'] as String,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isUnlocked
                      ? color
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                achievement['description'] as String,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 2.h),
              if (!isUnlocked)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'আরও দান করুন এই ব্যাজ আনলক করতে',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }
}
