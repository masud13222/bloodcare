import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class DonationTimelineWidget extends StatelessWidget {
  final List<Map<String, dynamic>> donations;
  final VoidCallback? onExport;

  const DonationTimelineWidget({
    Key? key,
    required this.donations,
    this.onExport,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (donations.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        // Header with export button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'দানের ইতিহাস',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            if (onExport != null)
              TextButton.icon(
                onPressed: onExport,
                icon: Icon(
                  Icons.download,
                  size: 16,
                  color: AppTheme.lightTheme.primaryColor,
                ),
                label: Text(
                  'এক্সপোর্ট',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 2.h),

        // Timeline items
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: donations.length,
          itemBuilder: (context, index) {
            final donation = donations[index];
            final isLast = index == donations.length - 1;

            return _buildTimelineItem(
              donation: donation,
              isLast: isLast,
            );
          },
        ),
      ],
    );
  }

  Widget _buildTimelineItem({
    required Map<String, dynamic> donation,
    required bool isLast,
  }) {
    final status = donation['status'] as String;
    final Color statusColor = _getStatusColor(status);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 3.w,
              height: 3.w,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: statusColor.withAlpha(77),
                  width: 2,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 1,
                height: 15.h,
                color: AppTheme.lightTheme.dividerColor,
              ),
          ],
        ),
        SizedBox(width: 4.w),

        // Donation card
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: 3.h),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: statusColor.withAlpha(77),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 1.h,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withAlpha(26),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getStatusText(status),
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          donation['date'] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),

                    // Hospital and blood type
                    Row(
                      children: [
                        Icon(
                          Icons.local_hospital,
                          size: 16,
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            donation['hospital'] as String,
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 0.5.h,
                          ),
                          decoration: BoxDecoration(
                            color:
                                AppTheme.lightTheme.primaryColor.withAlpha(26),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            donation['bloodType'] as String,
                            style: AppTheme.lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),

                    // Units donated
                    Row(
                      children: [
                        Icon(
                          Icons.water_drop,
                          size: 16,
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '${donation['units']} ইউনিট',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),

                    // Recipient feedback if available
                    if (donation['feedback'] != null) ...[
                      SizedBox(height: 2.h),
                      Container(
                        padding: EdgeInsets.all(3.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'প্রাপকের মতামত:',
                              style: AppTheme.lightTheme.textTheme.labelMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              donation['feedback'] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Certificate download
                    if (status == 'completed') ...[
                      SizedBox(height: 2.h),
                      TextButton.icon(
                        onPressed: () {
                          // Handle certificate download
                        },
                        icon: Icon(
                          Icons.download,
                          size: 16,
                          color: AppTheme.lightTheme.primaryColor,
                        ),
                        label: Text(
                          'সনদ ডাউনলোড করুন',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 2.h),
          Text(
            'কোন দানের ইতিহাস নেই',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'আপনার প্রথম দান করুন এবং\nজীবন বাঁচানোর যাত্রা শুরু করুন।',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return AppTheme.getSuccessColor(true);
      case 'cancelled':
        return AppTheme.lightTheme.colorScheme.error;
      case 'pending':
        return AppTheme.getWarningColor(true);
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'completed':
        return 'সফল';
      case 'cancelled':
        return 'বাতিল';
      case 'pending':
        return 'পেন্ডিং';
      default:
        return 'অজানা';
    }
  }
}
