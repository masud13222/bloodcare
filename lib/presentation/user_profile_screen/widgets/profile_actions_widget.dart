import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileActionsWidget extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onPrivacySettings;
  final VoidCallback onHelp;
  final VoidCallback onLogout;

  const ProfileActionsWidget({
    Key? key,
    required this.onEditProfile,
    required this.onPrivacySettings,
    required this.onHelp,
    required this.onLogout,
  }) : super(key: key);

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
            'অ্যাকাউন্ট সেটিংস',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          _buildActionItem(
            icon: 'edit',
            title: 'প্রোফাইল সম্পাদনা',
            subtitle: 'আপনার ব্যক্তিগত তথ্য আপডেট করুন',
            onTap: onEditProfile,
            color: AppTheme.lightTheme.primaryColor,
          ),
          SizedBox(height: 2.h),
          _buildActionItem(
            icon: 'privacy_tip',
            title: 'গোপনীয়তা সেটিংস',
            subtitle: 'আপনার গোপনীয়তা পছন্দ পরিচালনা করুন',
            onTap: onPrivacySettings,
            color: Color(0xFF3182CE),
          ),
          SizedBox(height: 2.h),
          _buildActionItem(
            icon: 'help',
            title: 'সাহায্য',
            subtitle: 'সাহায্য এবং সহায়তা পান',
            onTap: onHelp,
            color: Color(0xFF38A169),
          ),
          SizedBox(height: 2.h),
          _buildActionItem(
            icon: 'logout',
            title: 'লগ আউট',
            subtitle: 'আপনার অ্যাকাউন্ট থেকে লগ আউট করুন',
            onTap: onLogout,
            color: AppTheme.lightTheme.colorScheme.error,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: color,
                size: 20,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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
      ),
    );
  }
}
