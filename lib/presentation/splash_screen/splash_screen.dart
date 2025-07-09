import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _textFadeAnimation;

  bool _isLoading = true;
  String _loadingStatus = 'শুরু হচ্ছে...'; // Starting...

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    ));

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    ));
  }

  void _startSplashSequence() async {
    // Set status bar color to match brand
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: AppTheme.lightTheme.primaryColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    // Start logo animation
    _logoController.forward();

    // Start text animation after logo
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();

    // Simulate initialization tasks
    await _performInitializationTasks();

    // Navigate to appropriate screen
    _navigateToNextScreen();
  }

  Future<void> _performInitializationTasks() async {
    final tasks = [
      {
        'status': 'প্রমাণীকরণ পরীক্ষা করা হচ্ছে...',
        'delay': 600
      }, // Checking authentication...
      {
        'status': 'ভাষা সেটিংস লোড করা হচ্ছে...',
        'delay': 500
      }, // Loading language settings...
      {
        'status': 'জরুরি অনুরোধ আনা হচ্ছে...',
        'delay': 700
      }, // Fetching emergency requests...
      {
        'status': 'ডেটা প্রস্তুত করা হচ্ছে...',
        'delay': 400
      }, // Preparing data...
    ];

    for (var task in tasks) {
      if (mounted) {
        setState(() {
          _loadingStatus = task['status'] as String;
        });
        await Future.delayed(Duration(milliseconds: task['delay'] as int));
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToNextScreen() {
    // Simulate authentication check
    final bool isAuthenticated = _checkAuthenticationStatus();
    final bool isFirstTime = _checkFirstTimeUser();

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        if (isAuthenticated) {
          Navigator.pushReplacementNamed(context, '/home-dashboard');
        } else if (isFirstTime) {
          Navigator.pushReplacementNamed(context, '/registration-screen');
        } else {
          Navigator.pushReplacementNamed(context, '/login-screen');
        }
      }
    });
  }

  bool _checkAuthenticationStatus() {
    // Mock authentication check
    // In real app, check SharedPreferences or secure storage
    return false;
  }

  bool _checkFirstTimeUser() {
    // Mock first time user check
    // In real app, check SharedPreferences
    return true;
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 100.w,
        height: 100.h,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightTheme.primaryColor,
              AppTheme.lightTheme.colorScheme.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScaleAnimation.value,
                        child: Opacity(
                          opacity: _logoFadeAnimation.value,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildLogo(),
                              SizedBox(height: 3.h),
                              _buildAppName(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _textController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _textFadeAnimation.value,
                          child: _buildTagline(),
                        );
                      },
                    ),
                    SizedBox(height: 4.h),
                    _buildLoadingSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 25.w,
      height: 25.w,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: 'water_drop',
          color: AppTheme.lightTheme.primaryColor,
          size: 12.w,
        ),
      ),
    );
  }

  Widget _buildAppName() {
    return Text(
      'BloodCare',
      style: AppTheme.lightTheme.textTheme.headlineLarge?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildTagline() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Text(
        'রক্তদান জীবনদান',
        style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
          color: Colors.white.withValues(alpha: 0.9),
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      children: [
        if (_isLoading) ...[
          SizedBox(
            width: 6.w,
            height: 6.w,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            _loadingStatus,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ] else ...[
          CustomIconWidget(
            iconName: 'check_circle',
            color: Colors.white,
            size: 6.w,
          ),
          SizedBox(height: 1.h),
          Text(
            'প্রস্তুত!',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}
