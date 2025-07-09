import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileInfoWidget extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ProfileInfoWidget({
    Key? key,
    required this.userData,
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
            'ব্যক্তিগত তথ্য',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          _buildInfoItem(
            icon: 'phone',
            label: 'ফোন নম্বর',
            value: userData['phone'] as String,
          ),
          SizedBox(height: 2.h),
          _buildInfoItem(
            icon: 'email',
            label: 'ইমেইল',
            value: userData['email'] as String,
          ),
          SizedBox(height: 2.h),
          _buildInfoItem(
            icon: 'location_on',
            label: 'জেলা',
            value: userData['district'] as String,
          ),
          SizedBox(height: 2.h),
          _buildInfoItem(
            icon: 'calendar_today',
            label: 'নিবন্ধনের তারিখ',
            value: userData['registrationDate'] as String,
          ),
          SizedBox(height: 3.h),
          _buildBloodCompatibilitySection(),
          SizedBox(height: 3.h),
          _buildNotificationSettings(),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required String icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 20,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                value,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBloodCompatibilitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'রক্তের সামঞ্জস্য',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: (userData['compatibleBloodTypes'] as List<String>)
              .map((bloodType) => Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color:
                          _getBloodTypeColor(bloodType).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _getBloodTypeColor(bloodType),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      bloodType,
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: _getBloodTypeColor(bloodType),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildNotificationSettings() {
    final notificationSettings =
        userData['notificationSettings'] as Map<String, bool>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'বিজ্ঞপ্তি সেটিংস',
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 1.h),
        _buildNotificationItem(
          'জরুরি অ্যালার্ট',
          notificationSettings['emergencyAlerts'] ?? false,
          'emergency',
        ),
        _buildNotificationItem(
          'দান রিমাইন্ডার',
          notificationSettings['donationReminders'] ?? false,
          'notifications',
        ),
        _buildNotificationItem(
          'সিস্টেম আপডেট',
          notificationSettings['systemUpdates'] ?? false,
          'system_update',
        ),
      ],
    );
  }

  Widget _buildNotificationItem(String title, bool value, String icon) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: icon,
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ),
        Switch(
          value: value,
          onChanged: (newValue) {
            // Handle notification setting change
          },
          activeColor: AppTheme.lightTheme.primaryColor,
        ),
      ],
    );
  }

  Color _getBloodTypeColor(String bloodType) {
    switch (bloodType) {
      case 'A+':
      case 'A-':
        return Color(0xFFE53E3E);
      case 'B+':
      case 'B-':
        return Color(0xFF3182CE);
      case 'AB+':
      case 'AB-':
        return Color(0xFF805AD5);
      case 'O+':
      case 'O-':
        return Color(0xFF38A169);
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }
}
