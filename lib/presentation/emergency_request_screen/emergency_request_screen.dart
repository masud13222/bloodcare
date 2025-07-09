import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/blood_type_selector_widget.dart';
import './widgets/confirmation_modal_widget.dart';
import './widgets/units_stepper_widget.dart';
import './widgets/urgency_level_picker_widget.dart';

class EmergencyRequestScreen extends StatefulWidget {
  const EmergencyRequestScreen({Key? key}) : super(key: key);

  @override
  State<EmergencyRequestScreen> createState() => _EmergencyRequestScreenState();
}

class _EmergencyRequestScreenState extends State<EmergencyRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientNameController = TextEditingController();
  final _hospitalController = TextEditingController();
  final _contactController = TextEditingController();
  final _detailsController = TextEditingController();

  String? _selectedBloodType;
  String _selectedUrgency = 'অতি জরুরি';
  int _unitsNeeded = 1;
  bool _isLoading = false;

  final List<String> _bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];
  final List<String> _urgencyLevels = ['অতি জরুরি', 'জরুরি', 'সাধারণ'];

  final List<String> _hospitals = [
    'ঢাকা মেডিকেল কলেজ হাসপাতাল',
    'বঙ্গবন্ধু শেখ মুজিব মেডিকেল বিশ্ববিদ্যালয়',
    'চট্টগ্রাম মেডিকেল কলেজ হাসপাতাল',
    'রাজশাহী মেডিকেল কলেজ হাসপাতাল',
    'সিলেট এম এ জি ওসমানী মেডিকেল কলেজ',
    'খুলনা মেডিকেল কলেজ হাসপাতাল',
    'বরিশাল শের-ই-বাংলা মেডিকেল কলেজ',
    'রংপুর মেডিকেল কলেজ হাসপাতাল'
  ];

  @override
  void initState() {
    super.initState();
    _contactController.text = '+৮৮০১৭১২৩৪৫৬৭৮'; // Pre-filled mock number
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _hospitalController.dispose();
    _contactController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  void _onBloodTypeSelected(String bloodType) {
    setState(() {
      _selectedBloodType = bloodType;
    });
  }

  void _onUrgencySelected(String urgency) {
    setState(() {
      _selectedUrgency = urgency;
    });
  }

  void _onUnitsChanged(int units) {
    setState(() {
      _unitsNeeded = units;
    });
  }

  void _showConfirmationModal() {
    final estimatedDonors = _calculateEstimatedDonors();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmationModalWidget(
        estimatedDonors: estimatedDonors,
        onConfirm: _submitRequest,
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  int _calculateEstimatedDonors() {
    // Mock calculation based on urgency and blood type
    int base = 50;
    if (_selectedUrgency == 'অতি জরুরি') base += 30;
    if (_selectedUrgency == 'জরুরি') base += 15;
    if (_selectedBloodType == 'O+' || _selectedBloodType == 'B+') base += 20;
    return base;
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate() || _selectedBloodType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('সকল তথ্য সঠিকভাবে পূরণ করুন'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Mock API call delay
    await Future.delayed(Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      Navigator.of(context).pop(); // Close confirmation modal

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('জরুরি অনুরোধ সফলভাবে পাঠানো হয়েছে'),
          backgroundColor: AppTheme.getSuccessColor(true),
        ),
      );

      // Navigate back to home dashboard
      Navigator.pushReplacementNamed(context, '/home-dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBloodTypeSection(),
                          SizedBox(height: 3.h),
                          _buildPatientNameField(),
                          SizedBox(height: 2.h),
                          _buildHospitalField(),
                          SizedBox(height: 2.h),
                          _buildContactField(),
                          SizedBox(height: 2.h),
                          _buildUrgencySection(),
                          SizedBox(height: 2.h),
                          _buildUnitsSection(),
                          SizedBox(height: 2.h),
                          _buildDetailsField(),
                          SizedBox(height: 4.h),
                          _buildSubmitButton(),
                          SizedBox(height: 2.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_isLoading) _buildLoadingOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsets.all(1.w),
              child: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 6.w,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'জরুরি অনুরোধ',
              textAlign: TextAlign.center,
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 8.w), // Balance the close button
        ],
      ),
    );
  }

  Widget _buildBloodTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'রক্তের গ্রুপ *',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        BloodTypeSelectorWidget(
          bloodTypes: _bloodTypes,
          selectedBloodType: _selectedBloodType,
          onBloodTypeSelected: _onBloodTypeSelected,
        ),
      ],
    );
  }

  Widget _buildPatientNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'রোগীর নাম *',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _patientNameController,
          decoration: InputDecoration(
            hintText: 'রোগীর নাম লিখুন',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'রোগীর নাম আবশ্যক';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildHospitalField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'হাসপাতাল/অবস্থান *',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _hospitalController,
          decoration: InputDecoration(
            hintText: 'হাসপাতাল বা অবস্থান লিখুন',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
            ),
            suffixIcon: PopupMenuButton<String>(
              icon: CustomIconWidget(
                iconName: 'arrow_drop_down',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
              onSelected: (String value) {
                _hospitalController.text = value;
              },
              itemBuilder: (BuildContext context) {
                return _hospitals.map((String hospital) {
                  return PopupMenuItem<String>(
                    value: hospital,
                    child: Text(
                      hospital,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  );
                }).toList();
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'হাসপাতাল/অবস্থান আবশ্যক';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildContactField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'যোগাযোগ নম্বর *',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _contactController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: 'যোগাযোগ নম্বর',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'phone',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 5.w,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'যোগাযোগ নম্বর আবশ্যক';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildUrgencySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'জরুরি মাত্রা *',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        UrgencyLevelPickerWidget(
          urgencyLevels: _urgencyLevels,
          selectedUrgency: _selectedUrgency,
          onUrgencySelected: _onUrgencySelected,
        ),
      ],
    );
  }

  Widget _buildUnitsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'প্রয়োজনীয় ব্যাগ সংখ্যা *',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        UnitsStepperWidget(
          unitsNeeded: _unitsNeeded,
          onUnitsChanged: _onUnitsChanged,
        ),
      ],
    );
  }

  Widget _buildDetailsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'অতিরিক্ত বিবরণ',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _detailsController,
          maxLines: 4,
          maxLength: 200,
          decoration: InputDecoration(
            hintText: 'রোগীর অবস্থা বা অন্যান্য প্রয়োজনীয় তথ্য লিখুন',
            alignLabelWithHint: true,
          ),
          buildCounter: (context,
              {required currentLength, required isFocused, maxLength}) {
            return Text(
              '$currentLength/${maxLength ?? 200}',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            );
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _showConfirmationModal,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.w),
          ),
        ),
        child: _isLoading
            ? SizedBox(
                width: 5.w,
                height: 5.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.onPrimary,
                  ),
                ),
              )
            : Text(
                'অনুরোধ পাঠান',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.circular(3.w),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'অনুরোধ পাঠানো হচ্ছে...',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
