import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileStatsWidget extends StatefulWidget {
  final int donationCount;
  final int livesSaved;
  final String lastDonation;

  const ProfileStatsWidget({
    Key? key,
    required this.donationCount,
    required this.livesSaved,
    required this.lastDonation,
  }) : super(key: key);

  @override
  State<ProfileStatsWidget> createState() => _ProfileStatsWidgetState();
}

class _ProfileStatsWidgetState extends State<ProfileStatsWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<int> _donationAnimation;
  late Animation<int> _livesAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _donationAnimation = IntTween(
      begin: 0,
      end: widget.donationCount,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _livesAnimation = IntTween(
      begin: 0,
      end: widget.livesSaved,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
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
            'পরিসংখ্যান',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: 'water_drop',
                  value: _donationAnimation,
                  label: 'দান সংখ্যা',
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildStatCard(
                  icon: 'favorite',
                  value: _livesAnimation,
                  label: 'জীবন রক্ষা',
                  color: AppTheme.getSuccessColor(true),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildLastDonationCard(),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String icon,
    required Animation<int> value,
    required String label,
    required Color color,
  }) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: icon,
                  color: color,
                  size: 24,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                '${value.value}',
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLastDonationCard() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'calendar_today',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'সর্বশেষ দান',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  widget.lastDonation,
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          CustomIconWidget(
            iconName: 'chevron_right',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ],
      ),
    );
  }
}
