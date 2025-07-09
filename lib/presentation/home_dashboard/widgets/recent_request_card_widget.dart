import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentRequestCardWidget extends StatelessWidget {
  final String bloodType;
  final String patientName;
  final String location;
  final String district;
  final String contactNumber;
  final String urgencyLevel;
  final String timeAgo;
  final int unitsNeeded;
  final String donorType;
  final bool isEmergency;
  final VoidCallback onCallPressed;
  final VoidCallback onSharePressed;
  final VoidCallback onReportPressed;

  const RecentRequestCardWidget({
    Key? key,
    required this.bloodType,
    required this.patientName,
    required this.location,
    required this.district,
    required this.contactNumber,
    required this.urgencyLevel,
    required this.timeAgo,
    required this.unitsNeeded,
    required this.donorType,
    required this.isEmergency,
    required this.onCallPressed,
    required this.onSharePressed,
    required this.onReportPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(contactNumber),
      background: _buildSwipeBackground(true),
      secondaryBackground: _buildSwipeBackground(false),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onCallPressed();
        } else {
          onSharePressed();
        }
      },
      child: GestureDetector(
        onLongPress: () {
          _showContextMenu(context);
        },
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: isEmergency
                ? Border.all(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                    width: 2,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow
                    .withValues(alpha: 0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 2.h),
              _buildPatientInfo(),
              SizedBox(height: 2.h),
              _buildLocationInfo(),
              SizedBox(height: 2.h),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: _getBloodTypeColor().withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _getBloodTypeColor(),
              width: 1,
            ),
          ),
          child: Text(
            bloodType,
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              color: _getBloodTypeColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 2.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: _getUrgencyColor().withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            urgencyLevel,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: _getUrgencyColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Spacer(),
        if (isEmergency)
          Container(
            padding: EdgeInsets.all(1.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: CustomIconWidget(
              iconName: 'emergency',
              color: AppTheme.lightTheme.primaryColor,
              size: 16,
            ),
          ),
        SizedBox(width: 2.w),
        Text(
          timeAgo,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildPatientInfo() {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'person',
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                patientName,
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Text(
                '$unitsNeeded ব্যাগ রক্ত প্রয়োজন • $donorType',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationInfo() {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'location_on',
          color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Text(
                district,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onCallPressed,
            icon: CustomIconWidget(
              iconName: 'phone',
              color: Colors.white,
              size: 16,
            ),
            label: Text(
              'কল করুন',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.getSuccessColor(true),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onSharePressed,
            icon: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.lightTheme.primaryColor,
              size: 16,
            ),
            label: Text(
              'শেয়ার করুন',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.lightTheme.primaryColor,
              side: BorderSide(color: AppTheme.lightTheme.primaryColor),
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSwipeBackground(bool isLeft) {
    return Container(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: BoxDecoration(
        color: isLeft
            ? AppTheme.getSuccessColor(true)
            : AppTheme.lightTheme.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: isLeft ? 'phone' : 'share',
            color: Colors.white,
            size: 24,
          ),
          SizedBox(height: 0.5.h),
          Text(
            isLeft ? 'কল' : 'শেয়ার',
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.bottomSheetTheme.backgroundColor,
      shape: AppTheme.lightTheme.bottomSheetTheme.shape,
      builder: (context) {
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
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'report',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 24,
                ),
                title: Text(
                  'রিপোর্ট করুন',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onReportPressed();
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  Color _getBloodTypeColor() {
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

  Color _getUrgencyColor() {
    switch (urgencyLevel) {
      case 'অতি জরুরি':
        return Color(0xFFE53E3E);
      case 'জরুরি':
        return Color(0xFFD69E2E);
      case 'সাধারণ':
        return Color(0xFF38A169);
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }
}
