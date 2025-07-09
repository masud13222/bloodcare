import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DistrictDropdownWidget extends StatelessWidget {
  final String selectedDistrict;
  final Function(String) onChanged;

  const DistrictDropdownWidget({
    Key? key,
    required this.selectedDistrict,
    required this.onChanged,
  }) : super(key: key);

  final List<String> districts = const [
    'ঢাকা',
    'চট্টগ্রাম',
    'সিলেট',
    'রাজশাহী',
    'বরিশাল',
    'রংপুর',
    'খুলনা',
    'ময়মনসিংহ',
    'কুমিল্লা',
    'ফরিদপুর',
    'গাজীপুর',
    'গোপালগঞ্জ',
    'জামালপুর',
    'কিশোরগঞ্জ',
    'মাদারীপুর',
    'মানিকগঞ্জ',
    'মুন্শিগঞ্জ',
    'নারায়ণগঞ্জ',
    'নরসিংদী',
    'রাজবাড়ী',
    'শরীয়তপুর',
    'টাঙ্গাইল',
    'বান্দরবান',
    'ব্রাহ্মণবাড়িয়া',
    'চাঁদপুর',
    'কক্সবাজার',
    'ফেনী',
    'খাগড়াছড়ি',
    'লক্ষ্মীপুর',
    'নোয়াখালী',
    'রাঙ্গামাটি',
    'বাগেরহাট',
    'চুয়াডাঙ্গা',
    'যশোর',
    'ঝিনাইদহ',
    'কুষ্টিয়া',
    'মাগুরা',
    'মেহেরপুর',
    'নড়াইল',
    'সাতক্ষীরা',
    'বগুড়া',
    'জয়পুরহাট',
    'নওগাঁ',
    'নাটোর',
    'চাঁপাইনবাবগঞ্জ',
    'পাবনা',
    'সিরাজগঞ্জ',
    'দিনাজপুর',
    'গাইবান্ধা',
    'কুড়িগ্রাম',
    'লালমনিরহাট',
    'নীলফামারী',
    'পঞ্চগড়',
    'ঠাকুরগাঁও',
    'বরগুনা',
    'ভোলা',
    'ঝালকাঠি',
    'পটুয়াখালী',
    'পিরোজপুর',
    'হবিগঞ্জ',
    'মৌলভীবাজার',
    'সুনামগঞ্জ',
    'নেত্রকোনা',
    'শেরপুর'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'জেলা *',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selectedDistrict.isEmpty
                  ? AppTheme.lightTheme.dividerColor
                  : AppTheme.lightTheme.colorScheme.primary,
              width: selectedDistrict.isEmpty ? 1 : 2,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedDistrict.isEmpty ? null : selectedDistrict,
              hint: Text(
                'জেলা নির্বাচন করুন',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.getTextSecondary(true),
                ),
              ),
              icon: CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
              isExpanded: true,
              items: districts.map((String district) {
                return DropdownMenuItem<String>(
                  value: district,
                  child: Text(
                    district,
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
              dropdownColor: AppTheme.lightTheme.cardColor,
              borderRadius: BorderRadius.circular(8),
              menuMaxHeight: 40.h,
            ),
          ),
        ),
        if (selectedDistrict.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Text(
              'জেলা নির্বাচন করুন',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
          ),
        if (selectedDistrict.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.getSuccessColor(true),
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  'জেলা নির্বাচিত',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.getSuccessColor(true),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
