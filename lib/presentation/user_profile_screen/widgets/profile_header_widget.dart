import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final bool isAvailable;
  final Function(bool) onAvailabilityToggle;

  const ProfileHeaderWidget({
    Key? key,
    required this.userData,
    required this.isAvailable,
    required this.onAvailabilityToggle,
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
        children: [
          // Profile Image
          Stack(
            children: [
              Container(
                width: 25.w,
                height: 25.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.lightTheme.primaryColor,
                    width: 3,
                  ),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: userData['profileImage'] as String,
                    width: 25.w,
                    height: 25.w,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      child: CustomIconWidget(
                        iconName: 'person',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 40,
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      child: CustomIconWidget(
                        iconName: 'person',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(1.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.lightTheme.scaffoldBackgroundColor,
                      width: 2,
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: 'camera_alt',
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          // Name and Blood Type
          Text(
            userData['name'] as String,
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: _getBloodTypeColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _getBloodTypeColor(),
                    width: 2,
                  ),
                ),
                child: Text(
                  userData['bloodType'] as String,
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: _getBloodTypeColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 16,
              ),
              SizedBox(width: 1.w),
              Text(
                userData['location'] as String,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          // Status and Availability
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: _getStatusColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _getStatusColor(),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      _getStatusText(),
                      style:
                          AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        color: _getStatusColor(),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4.w),
              Switch(
                value: isAvailable,
                onChanged: onAvailabilityToggle,
                activeColor: AppTheme.lightTheme.primaryColor,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          // Profile Completion
          Row(
            children: [
              Text(
                'প্রোফাইল সম্পূর্ণতা',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              Spacer(),
              Text(
                '${userData['profileCompletion']}%',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          LinearProgressIndicator(
            value: (userData['profileCompletion'] as int) / 100,
            backgroundColor:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            valueColor:
                AlwaysStoppedAnimation<Color>(AppTheme.lightTheme.primaryColor),
          ),
        ],
      ),
    );
  }

  Color _getBloodTypeColor() {
    final bloodType = userData['bloodType'] as String;
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

  Color _getStatusColor() {
    if (isAvailable) {
      return AppTheme.getSuccessColor(true);
    }
    return AppTheme.lightTheme.colorScheme.error;
  }

  String _getStatusText() {
    final userType = userData['userType'] as String;
    if (userType == 'donor') {
      return isAvailable ? 'সক্রিয় দাতা' : 'অনুপস্থিত';
    }
    return isAvailable ? 'সক্রিয় গ্রহীতা' : 'অনুপস্থিত';
  }
}