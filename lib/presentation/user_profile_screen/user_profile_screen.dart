import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/achievement_badges_widget.dart';
import './widgets/profile_actions_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/profile_info_widget.dart';
import './widgets/profile_stats_widget.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _selectedTabIndex = 3; // Profile tab active
  bool _isAvailable = true;

  // Mock user data
  final Map<String, dynamic> _userData = {
    "name": "মোহাম্মদ রহিম উদ্দিন",
    "bloodType": "A+",
    "location": "ঢাকা",
    "district": "ঢাকা",
    "profileImage":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
    "userType": "donor", // donor or recipient
    "phone": "+৮৮০১৭১২৩৪৫৬৭৮",
    "email": "rahim.uddin@example.com",
    "registrationDate": "২০২৩-০১-১৫",
    "donationCount": 8,
    "livesSaved": 24,
    "lastDonation": "২০২৪-১১-২৫",
    "profileCompletion": 85,
    "achievements": [
      {
        "id": "first_donation",
        "title": "প্রথম দান",
        "description": "প্রথমবার রক্তদান সম্পন্ন",
        "icon": "water_drop",
        "color": 0xFF3182CE,
        "isUnlocked": true,
      },
      {
        "id": "regular_donor",
        "title": "৫+ দান",
        "description": "৫ বার রক্তদান সম্পন্ন",
        "icon": "star",
        "color": 0xFFD69E2E,
        "isUnlocked": true,
      },
      {
        "id": "hero_donor",
        "title": "১০+ দান",
        "description": "১০ বার রক্তদান সম্পন্ন",
        "icon": "military_tech",
        "color": 0xFF38A169,
        "isUnlocked": false,
      },
    ],
    "compatibleBloodTypes": ["A+", "A-", "AB+", "AB-"],
    "notificationSettings": {
      "emergencyAlerts": true,
      "donationReminders": true,
      "systemUpdates": false,
    },
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
  }

  void _startAnimations() {
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home-dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/blood-search-screen');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/notifications-screen');
        break;
      case 3:
        // Already on profile
        break;
    }
  }

  void _onEditProfile() {
    // Navigate to edit profile
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildEditProfileSheet(),
    );
  }

  void _onPrivacySettings() {
    // Navigate to privacy settings
  }

  void _onHelp() {
    // Navigate to help/support
  }

  void _onLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'লগ আউট',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'আপনি কি নিশ্চিত যে আপনি লগ আউট করতে চান?',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('বাতিল'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login-screen');
            },
            child: Text('লগ আউট'),
          ),
        ],
      ),
    );
  }

  void _toggleAvailability(bool value) {
    setState(() {
      _isAvailable = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'প্রোফাইল',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _onEditProfile,
            icon: CustomIconWidget(
              iconName: 'edit',
              color: AppTheme.lightTheme.primaryColor,
              size: 24,
            ),
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  children: [
                    SizedBox(height: 2.h),
                    // Profile Header
                    ProfileHeaderWidget(
                      userData: _userData,
                      isAvailable: _isAvailable,
                      onAvailabilityToggle: _toggleAvailability,
                    ),
                    SizedBox(height: 3.h),
                    // Statistics
                    ProfileStatsWidget(
                      donationCount: _userData['donationCount'] as int,
                      livesSaved: _userData['livesSaved'] as int,
                      lastDonation: _userData['lastDonation'] as String,
                    ),
                    SizedBox(height: 3.h),
                    // Profile Information
                    ProfileInfoWidget(
                      userData: _userData,
                    ),
                    SizedBox(height: 3.h),
                    // Achievement Badges
                    AchievementBadgesWidget(
                      achievements: _userData['achievements']
                          as List<Map<String, dynamic>>,
                    ),
                    SizedBox(height: 3.h),
                    // Action Buttons
                    ProfileActionsWidget(
                      onEditProfile: _onEditProfile,
                      onPrivacySettings: _onPrivacySettings,
                      onHelp: _onHelp,
                      onLogout: _onLogout,
                    ),
                    SizedBox(height: 10.h), // Bottom padding
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.backgroundColor,
        selectedItemColor: AppTheme.lightTheme.primaryColor,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        selectedLabelStyle: AppTheme.lightTheme.textTheme.labelSmall,
        unselectedLabelStyle: AppTheme.lightTheme.textTheme.labelSmall,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: _selectedTabIndex == 0
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'হোম',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'search',
              color: _selectedTabIndex == 1
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'খুঁজুন',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'notifications',
              color: _selectedTabIndex == 2
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'বিজ্ঞপ্তি',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _selectedTabIndex == 3
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'প্রোফাইল',
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfileSheet() {
    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'বাতিল',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Text(
                  'প্রোফাইল সম্পাদনা',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'সংরক্ষণ',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  // Profile photo section
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 25.w,
                          height: 25.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.lightTheme.primaryColor,
                              width: 3,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              _userData['profileImage'] as String,
                              width: 25.w,
                              height: 25.w,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: AppTheme.lightTheme.colorScheme.surface,
                                  child: CustomIconWidget(
                                    iconName: 'person',
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurfaceVariant,
                                    size: 40,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    AppTheme.lightTheme.scaffoldBackgroundColor,
                                width: 2,
                              ),
                            ),
                            child: CustomIconWidget(
                              iconName: 'camera_alt',
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  // Form fields would go here
                  Text(
                    'Edit profile form would be implemented here',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}