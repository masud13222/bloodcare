import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DonorCardWidget extends StatelessWidget {
  final Map<String, dynamic> donor;
  final VoidCallback onCall;
  final VoidCallback onMessage;
  final VoidCallback onFavorite;

  const DonorCardWidget({
    Key? key,
    required this.donor,
    required this.onCall,
    required this.onMessage,
    required this.onFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isAvailable = donor["isAvailable"] as bool;
    final bool isFavorite = donor["isFavorite"] as bool;

    return Dismissible(
      key: Key(donor["id"].toString()),
      direction: DismissDirection.startToEnd,
      background: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 6.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildActionButton(
              icon: 'phone',
              label: 'কল',
              onTap: onCall,
            ),
            SizedBox(width: 4.w),
            _buildActionButton(
              icon: 'message',
              label: 'বার্তা',
              onTap: onMessage,
            ),
            SizedBox(width: 4.w),
            _buildActionButton(
              icon: isFavorite ? 'favorite' : 'favorite_border',
              label: 'প্রিয়',
              onTap: onFavorite,
            ),
          ],
        ),
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: EdgeInsets.all(4.w),
          child: Row(
            children: [
              // Profile Image
              Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CustomImageWidget(
                    imageUrl: donor["profileImage"] as String,
                    width: 15.w,
                    height: 15.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(width: 4.w),

              // Donor Information
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            donor["name"] as String,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            donor["bloodType"] as String,
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 1.h),

                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'location_on',
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                          size: 14,
                        ),
                        SizedBox(width: 1.w),
                        Expanded(
                          child: Text(
                            donor["location"] as String,
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '${(donor["distance"] as double).toStringAsFixed(1)} কিমি',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 1.h),

                    Row(
                      children: [
                        // Availability Status
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isAvailable
                                ? AppTheme.getSuccessColor(true)
                                : AppTheme.lightTheme.colorScheme.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          isAvailable ? 'উপলব্ধ' : 'অনুপলব্ধ',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: isAvailable
                                ? AppTheme.getSuccessColor(true)
                                : AppTheme.lightTheme.colorScheme.error,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const Spacer(),

                        // Last Active
                        Text(
                          donor["lastActive"] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 1.h),

                    // Donation Count
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'bloodtype',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 14,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          '${donor["donationCount"]} বার দান',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),

                        const Spacer(),

                        // Favorite Button
                        GestureDetector(
                          onTap: onFavorite,
                          child: CustomIconWidget(
                            iconName:
                                isFavorite ? 'favorite' : 'favorite_border',
                            color: isFavorite
                                ? AppTheme.lightTheme.colorScheme.error
                                : AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 18,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                fontSize: 8.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
