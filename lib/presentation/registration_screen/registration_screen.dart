import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/blood_type_selector_widget.dart';
import './widgets/district_dropdown_widget.dart';
import './widgets/registration_form_widget.dart';
import './widgets/user_type_toggle_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Form controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Form state
  String _selectedBloodType = '';
  String _selectedDistrict = '';
  String _userType = 'রক্তদাতা'; // Default to donor
  DateTime? _lastDonationDate;
  bool _isAvailable = true;
  bool _acceptTerms = false;
  bool _isFormValid = false;

  // Validation states
  Map<String, bool> _fieldValidation = {
    'name': false,
    'email': false,
    'phone': false,
    'password': false,
    'confirmPassword': false,
    'bloodType': false,
    'district': false,
  };

  @override
  void initState() {
    super.initState();
    _setupFormValidation();
  }

  void _setupFormValidation() {
    _nameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
    _confirmPasswordController.addListener(_validateForm);
  }

  void _validateForm() {
    setState(() {
      _fieldValidation['name'] = _nameController.text.trim().length >= 2;
      _fieldValidation['email'] = _isValidEmail(_emailController.text.trim());
      _fieldValidation['phone'] = _isValidPhone(_phoneController.text.trim());
      _fieldValidation['password'] = _passwordController.text.length >= 6;
      _fieldValidation['confirmPassword'] =
          _confirmPasswordController.text == _passwordController.text &&
              _passwordController.text.isNotEmpty;
      _fieldValidation['bloodType'] = _selectedBloodType.isNotEmpty;
      _fieldValidation['district'] = _selectedDistrict.isNotEmpty;

      _isFormValid =
          _fieldValidation.values.every((isValid) => isValid) && _acceptTerms;
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    return RegExp(r'^(\+88)?01[3-9]\d{8}$').hasMatch(phone);
  }

  void _onBloodTypeChanged(String bloodType) {
    setState(() {
      _selectedBloodType = bloodType;
      _fieldValidation['bloodType'] = bloodType.isNotEmpty;
    });
    _validateForm();
  }

  void _onDistrictChanged(String district) {
    setState(() {
      _selectedDistrict = district;
      _fieldValidation['district'] = district.isNotEmpty;
    });
    _validateForm();
  }

  void _onUserTypeChanged(String userType) {
    setState(() {
      _userType = userType;
    });
  }

  void _onLastDonationDateChanged(DateTime? date) {
    setState(() {
      _lastDonationDate = date;
    });
  }

  void _onAvailabilityChanged(bool isAvailable) {
    setState(() {
      _isAvailable = isAvailable;
    });
  }

  void _onTermsChanged(bool accepted) {
    setState(() {
      _acceptTerms = accepted;
    });
    _validateForm();
  }

  void _showTermsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.lightTheme.dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'নিয়ম ও শর্তাবলী',
                    style: AppTheme.lightTheme.textTheme.titleLarge,
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
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Text(
                  '''১. ব্যবহারকারীর দায়িত্ব:
• সঠিক এবং সম্পূর্ণ তথ্য প্রদান করতে হবে
• রক্তদানের জন্য স্বাস্থ্যগত যোগ্যতা থাকতে হবে
• ১৮ বছর বা তার বেশি বয়স হতে হবে

২. গোপনীয়তা নীতি:
• ব্যক্তিগত তথ্য সুরক্ষিত রাখা হবে
• তৃতীয় পক্ষের সাথে তথ্য শেয়ার করা হবে না
• শুধুমাত্র জরুরি প্রয়োজনে যোগাযোগ করা হবে

৩. রক্তদানের নিয়ম:
• সর্বশেষ রক্তদানের ৩ মাস পর পুনরায় দান করা যাবে
• স্বাস্থ্য পরীক্ষার পর রক্তদান করতে হবে
• যেকোনো সময় প্রত্যাহার করার অধিকার রয়েছে

৪. দায়বদ্ধতা:
• অ্যাপ্লিকেশন শুধুমাত্র সংযোগ স্থাপনে সহায়তা করে
• চিকিৎসা সংক্রান্ত সিদ্ধান্তের দায়িত্ব ব্যবহারকারীর
• জরুরি অবস্থায় সরাসরি হাসপাতালে যোগাযোগ করুন''',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _completeRegistration() {
    if (!_isFormValid) return;

    // Show success modal
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.getSuccessColor(true),
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(
              'সফল!',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.getSuccessColor(true),
              ),
            ),
          ],
        ),
        content: Text(
          'আপনার নিবন্ধন সফলভাবে সম্পন্ন হয়েছে। ইমেইল যাচাইয়ের জন্য আপনার ইনবক্স চেক করুন।',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login-screen');
            },
            child: Text('ঠিক আছে'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Sticky Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.scaffoldBackgroundColor,
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.lightTheme.dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'নিবন্ধন',
                    style: AppTheme.lightTheme.textTheme.headlineSmall,
                  ),
                ],
              ),
            ),

            // Scrollable Form
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.all(4.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Text
                      Text(
                        'BloodCare পরিবারে স্বাগতম',
                        style: AppTheme.lightTheme.textTheme.headlineMedium
                            ?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'জীবন বাঁচানোর মহৎ কাজে যোগ দিন',
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color: AppTheme.getTextSecondary(true),
                        ),
                      ),
                      SizedBox(height: 4.h),

                      // User Type Toggle
                      UserTypeToggleWidget(
                        selectedType: _userType,
                        onChanged: _onUserTypeChanged,
                      ),
                      SizedBox(height: 3.h),

                      // Registration Form
                      RegistrationFormWidget(
                        nameController: _nameController,
                        emailController: _emailController,
                        phoneController: _phoneController,
                        passwordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController,
                        fieldValidation: _fieldValidation,
                        userType: _userType,
                        lastDonationDate: _lastDonationDate,
                        isAvailable: _isAvailable,
                        onLastDonationDateChanged: _onLastDonationDateChanged,
                        onAvailabilityChanged: _onAvailabilityChanged,
                      ),
                      SizedBox(height: 3.h),

                      // Blood Type Selector
                      BloodTypeSelectorWidget(
                        selectedBloodType: _selectedBloodType,
                        onChanged: _onBloodTypeChanged,
                      ),
                      SizedBox(height: 3.h),

                      // District Dropdown
                      DistrictDropdownWidget(
                        selectedDistrict: _selectedDistrict,
                        onChanged: _onDistrictChanged,
                      ),
                      SizedBox(height: 3.h),

                      // Terms and Conditions
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _acceptTerms,
                            onChanged: (value) =>
                                _onTermsChanged(value ?? false),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: _showTermsModal,
                              child: RichText(
                                text: TextSpan(
                                  style:
                                      AppTheme.lightTheme.textTheme.bodyMedium,
                                  children: [
                                    TextSpan(text: 'আমি '),
                                    TextSpan(
                                      text: 'নিয়ম ও শর্তাবলী',
                                      style: TextStyle(
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    TextSpan(text: ' পড়েছি এবং সম্মত আছি'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),

                      // Registration Button
                      SizedBox(
                        width: double.infinity,
                        height: 6.h,
                        child: ElevatedButton(
                          onPressed:
                              _isFormValid ? _completeRegistration : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isFormValid
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.getTextSecondary(true),
                          ),
                          child: Text(
                            'নিবন্ধন সম্পূর্ণ করুন',
                            style: AppTheme.lightTheme.textTheme.labelLarge
                                ?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),

                      // Login Link
                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(
                              context, '/login-screen'),
                          child: RichText(
                            text: TextSpan(
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                              children: [
                                TextSpan(text: 'ইতিমধ্যে অ্যাকাউন্ট আছে? '),
                                TextSpan(
                                  text: 'লগইন করুন',
                                  style: TextStyle(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
