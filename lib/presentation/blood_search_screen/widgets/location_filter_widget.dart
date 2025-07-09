import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LocationFilterWidget extends StatelessWidget {
  final String selectedLocation;
  final Function(String) onLocationChanged;

  const LocationFilterWidget({
    Key? key,
    required this.selectedLocation,
    required this.onLocationChanged,
  }) : super(key: key);

  final List<String> districts = const [
    'ঢাকা',
    'চট্টগ্রাম',
    'সিলেট',
    'রাজশাহী',
    'খুলনা',
    'বরিশাল',
    'রংপুর',
    'ময়মনসিংহ',
    'কুমিল্লা',
    'নারায়ণগঞ্জ',
    'গাজীপুর',
    'টাঙ্গাইল',
    'নরসিংদী',
    'মানিকগঞ্জ',
    'ফরিদপুর',
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDistrictPicker(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'location_on',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 20,
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'এলাকা',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                    ),
                  ),
                  Text(
                    selectedLocation,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showDistrictPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'জেলা নির্বাচন করুন',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: districts.length,
                itemBuilder: (context, index) {
                  final district = districts[index];
                  final isSelected = selectedLocation == district;

                  return ListTile(
                    leading: CustomIconWidget(
                      iconName: 'location_city',
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                      size: 20,
                    ),
                    title: Text(
                      district,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    trailing: isSelected
                        ? CustomIconWidget(
                            iconName: 'check',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          )
                        : null,
                    onTap: () {
                      onLocationChanged(district);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
