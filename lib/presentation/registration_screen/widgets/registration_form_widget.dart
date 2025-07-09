import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegistrationFormWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final Map<String, bool> fieldValidation;
  final String userType;
  final DateTime? lastDonationDate;
  final bool isAvailable;
  final Function(DateTime?) onLastDonationDateChanged;
  final Function(bool) onAvailabilityChanged;

  const RegistrationFormWidget({
    Key? key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.fieldValidation,
    required this.userType,
    required this.lastDonationDate,
    required this.isAvailable,
    required this.onLastDonationDateChanged,
    required this.onAvailabilityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Personal Information Section
        Text(
          'ব্যক্তিগত তথ্য',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        SizedBox(height: 2.h),

        // Full Name Field
        _buildTextField(
          controller: nameController,
          label: 'পূর্ণ নাম *',
          hint: 'আপনার পূর্ণ নাম লিখুন',
          icon: 'person',
          isValid: fieldValidation['name'] ?? false,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'নাম লিখুন';
            }
            if (value.trim().length < 2) {
              return 'নাম কমপক্ষে ২ অক্ষরের হতে হবে';
            }
            return null;
          },
        ),
        SizedBox(height: 2.h),

        // Email Field
        _buildTextField(
          controller: emailController,
          label: 'ইমেইল *',
          hint: 'example@email.com',
          icon: 'email',
          keyboardType: TextInputType.emailAddress,
          isValid: fieldValidation['email'] ?? false,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'ইমেইল লিখুন';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                .hasMatch(value.trim())) {
              return 'সঠিক ইমেইল ঠিকানা লিখুন';
            }
            return null;
          },
        ),
        SizedBox(height: 2.h),

        // Phone Field
        _buildTextField(
          controller: phoneController,
          label: 'ফোন নম্বর *',
          hint: '01XXXXXXXXX',
          icon: 'phone',
          keyboardType: TextInputType.phone,
          isValid: fieldValidation['phone'] ?? false,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'ফোন নম্বর লিখুন';
            }
            if (!RegExp(r'^(\+88)?01[3-9]\d{8}$').hasMatch(value.trim())) {
              return 'সঠিক বাংলাদেশী ফোন নম্বর লিখুন';
            }
            return null;
          },
        ),
        SizedBox(height: 2.h),

        // Password Field
        _buildTextField(
          controller: passwordController,
          label: 'পাসওয়ার্ড *',
          hint: 'কমপক্ষে ৬ অক্ষর',
          icon: 'lock',
          isPassword: true,
          isValid: fieldValidation['password'] ?? false,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'পাসওয়ার্ড লিখুন';
            }
            if (value.length < 6) {
              return 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে';
            }
            return null;
          },
        ),
        SizedBox(height: 2.h),

        // Confirm Password Field
        _buildTextField(
          controller: confirmPasswordController,
          label: 'পাসওয়ার্ড নিশ্চিত করুন *',
          hint: 'পাসওয়ার্ড পুনরায় লিখুন',
          icon: 'lock_outline',
          isPassword: true,
          isValid: fieldValidation['confirmPassword'] ?? false,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'পাসওয়ার্ড নিশ্চিত করুন';
            }
            if (value != passwordController.text) {
              return 'পাসওয়ার্ড মিলছে না';
            }
            return null;
          },
        ),

        // Donor-specific fields
        if (userType == 'রক্তদাতা') ...[
          SizedBox(height: 3.h),
          Text(
            'রক্তদানের তথ্য',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 2.h),

          // Last Donation Date
          _buildDateField(
            label: 'সর্বশেষ রক্তদানের তারিখ',
            hint: 'তারিখ নির্বাচন করুন (ঐচ্ছিক)',
            selectedDate: lastDonationDate,
            onDateSelected: onLastDonationDateChanged,
          ),
          SizedBox(height: 2.h),

          // Availability Switch
          _buildAvailabilitySwitch(),
        ],
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    bool isValid = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: icon,
                color: isValid
                    ? AppTheme.getSuccessColor(true)
                    : AppTheme.getTextSecondary(true),
                size: 20,
              ),
            ),
            suffixIcon: isValid
                ? Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.getSuccessColor(true),
                      size: 20,
                    ),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.dividerColor,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isValid
                    ? AppTheme.getSuccessColor(true)
                    : AppTheme.lightTheme.dividerColor,
                width: isValid ? 2 : 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required String label,
    required String hint,
    required DateTime? selectedDate,
    required Function(DateTime?) onDateSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        GestureDetector(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: null as BuildContext,
              initialDate:
                  selectedDate ?? DateTime.now().subtract(Duration(days: 90)),
              firstDate: DateTime.now().subtract(Duration(days: 365 * 2)),
              lastDate: DateTime.now(),
              locale: Locale('bn', 'BD'),
            );
            if (picked != null) {
              onDateSelected(picked);
            }
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.dividerColor,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'calendar_today',
                  color: AppTheme.getTextSecondary(true),
                  size: 20,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'
                        : hint,
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: selectedDate != null
                          ? AppTheme.lightTheme.colorScheme.onSurface
                          : AppTheme.getTextSecondary(true),
                    ),
                  ),
                ),
                CustomIconWidget(
                  iconName: 'keyboard_arrow_down',
                  color: AppTheme.getTextSecondary(true),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilitySwitch() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.dividerColor,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'notifications_active',
            color: isAvailable
                ? AppTheme.getSuccessColor(true)
                : AppTheme.getTextSecondary(true),
            size: 24,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'রক্তদানের জন্য উপলব্ধ',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'জরুরি প্রয়োজনে যোগাযোগের অনুমতি',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.getTextSecondary(true),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isAvailable,
            onChanged: onAvailabilityChanged,
          ),
        ],
      ),
    );
  }
}
