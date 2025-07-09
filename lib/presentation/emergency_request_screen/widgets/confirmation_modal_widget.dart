import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ConfirmationModalWidget extends StatelessWidget {
  final int estimatedDonors;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmationModalWidget({
    Key? key,
    required this.estimatedDonors,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3.w),
      ),
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.dialogBackgroundColor,
          borderRadius: BorderRadius.circular(3.w),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 15.w,
              height: 15.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'notifications_active',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 8.w,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'অনুরোধ নিশ্চিত করুন',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(2.w),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'people',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: AppTheme.lightTheme.textTheme.bodyMedium,
                        children: [
                          TextSpan(text: 'আনুমানিক '),
                          TextSpan(
                            text: '$estimatedDonors জন',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                          TextSpan(text: ' দাতাকে জানানো হবে'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'আপনার জরুরি রক্তের অনুরোধ নিকটবর্তী দাতাদের কাছে পাঠানো হবে। এই অনুরোধ পাঠাতে চান?',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      side: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.outline,
                        width: 1.0,
                      ),
                    ),
                    child: Text(
                      'বাতিল',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                      foregroundColor:
                          AppTheme.lightTheme.colorScheme.onPrimary,
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                    ),
                    child: Text(
                      'নিশ্চিত করুন',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
