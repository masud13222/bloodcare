import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/emergency_banner_widget.dart';
import './widgets/recent_request_card_widget.dart';
import './widgets/statistics_card_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({Key? key}) : super(key: key);

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  late AnimationController _emergencyAnimationController;
  late Animation<double> _emergencyPulseAnimation;

  bool _isLoading = false;
  int _selectedTabIndex = 0;

  // Mock data for statistics
  final List<Map<String, dynamic>> _statisticsData = [
    {
      "title": "১২৫০+ দাতা",
      "subtitle": "নিবন্ধিত দাতা",
      "count": 1250,
      "icon": "people",
      "color": Color(0xFFD32F2F),
    },
    {
      "title": "৮৯০+ রক্তের ইউনিট",
      "subtitle": "সংগৃহীত রক্ত",
      "count": 890,
      "icon": "water_drop",
      "color": Color(0xFFE91E63),
    },
    {
      "title": "৪৫+ জেলা",
      "subtitle": "সেবা এলাকা",
      "count": 45,
      "icon": "location_on",
      "color": Color(0xFF2E7D32),
    },
  ];

  // Mock data for recent blood requests
  final List<Map<String, dynamic>> _recentRequests = [
    {
      "id": 1,
      "bloodType": "A+",
      "patientName": "রহিম উদ্দিন",
      "location": "ঢাকা মেডিকেল কলেজ হাসপাতাল",
      "district": "ঢাকা",
      "contactNumber": "+৮৮০১৭১২৩৪৫৬৭৮",
      "urgencyLevel": "জরুরি",
      "requestTime": DateTime.now().subtract(Duration(minutes: 15)),
      "unitsNeeded": 2,
      "donorType": "যেকোনো দাতা",
      "isEmergency": true,
    },
    {
      "id": 2,
      "bloodType": "O-",
      "patientName": "ফাতেমা খাতুন",
      "location": "চট্টগ্রাম মেডিকেল কলেজ",
      "district": "চট্টগ্রাম",
      "contactNumber": "+৮৮০১৮১২৩৪৫৬৭৮",
      "urgencyLevel": "অতি জরুরি",
      "requestTime": DateTime.now().subtract(Duration(hours: 1)),
      "unitsNeeded": 3,
      "donorType": "পুরুষ দাতা",
      "isEmergency": true,
    },
    {
      "id": 3,
      "bloodType": "B+",
      "patientName": "করিম আহমেদ",
      "location": "সিলেট এমএজি ওসমানী মেডিকেল কলেজ",
      "district": "সিলেট",
      "contactNumber": "+৮৮০১৯১২৩৪৫৬৭৮",
      "urgencyLevel": "সাধারণ",
      "requestTime": DateTime.now().subtract(Duration(hours: 3)),
      "unitsNeeded": 1,
      "donorType": "যেকোনো দাতা",
      "isEmergency": false,
    },
    {
      "id": 4,
      "bloodType": "AB+",
      "patientName": "নাসির হোসেন",
      "location": "রাজশাহী মেডিকেল কলেজ",
      "district": "রাজশাহী",
      "contactNumber": "+৮৮০১৬১২৩৪৫৬৭৮",
      "urgencyLevel": "জরুরি",
      "requestTime": DateTime.now().subtract(Duration(hours: 5)),
      "unitsNeeded": 2,
      "donorType": "মহিলা দাতা",
      "isEmergency": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _emergencyAnimationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _emergencyPulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _emergencyAnimationController,
      curve: Curves.easeInOut,
    ));

    _emergencyAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _emergencyAnimationController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
    });

    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.pushNamed(context, '/blood-search-screen');
        break;
      case 2:
        // Navigate to notifications
        break;
      case 3:
        // Navigate to profile
        break;
    }
  }

  void _onFindBloodPressed() {
    Navigator.pushNamed(context, '/blood-search-screen');
  }

  void _onEmergencyRequestPressed() {
    Navigator.pushNamed(context, '/emergency-request-screen');
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} মিনিট আগে';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ঘন্টা আগে';
    } else {
      return '${difference.inDays} দিন আগে';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'BloodCare',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  // Navigate to notifications
                },
                icon: CustomIconWidget(
                  iconName: 'notifications',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _handleRefresh,
        color: AppTheme.lightTheme.primaryColor,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),

                // Statistics Cards Section
                _buildStatisticsSection(),

                SizedBox(height: 3.h),

                // Emergency Banner
                _buildEmergencyBanner(),

                SizedBox(height: 3.h),

                // Recent Requests Section
                _buildRecentRequestsSection(),

                SizedBox(height: 10.h), // Bottom padding for FAB
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onFindBloodPressed,
        backgroundColor: AppTheme.lightTheme.primaryColor,
        foregroundColor: Colors.white,
        icon: CustomIconWidget(
          iconName: 'search',
          color: Colors.white,
          size: 20,
        ),
        label: Text(
          'রক্ত খুঁজুন',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 6,
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

  Widget _buildStatisticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'পরিসংখ্যান',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 2.h,
            childAspectRatio: 1.2,
          ),
          itemCount: _statisticsData.length > 2 ? 2 : _statisticsData.length,
          itemBuilder: (context, index) {
            return StatisticsCardWidget(
              data: _statisticsData[index],
            );
          },
        ),
        if (_statisticsData.length > 2) ...[
          SizedBox(height: 2.h),
          StatisticsCardWidget(
            data: _statisticsData[2],
            isFullWidth: true,
          ),
        ],
      ],
    );
  }

  Widget _buildEmergencyBanner() {
    final emergencyRequests = _recentRequests
        .where((request) => (request["isEmergency"] as bool) == true)
        .toList();

    if (emergencyRequests.isEmpty) {
      return SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _emergencyPulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _emergencyPulseAnimation.value,
          child: EmergencyBannerWidget(
            emergencyCount: emergencyRequests.length,
            onPressed: _onEmergencyRequestPressed,
          ),
        );
      },
    );
  }

  Widget _buildRecentRequestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'সাম্প্রতিক অনুরোধ',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to all requests
              },
              child: Text(
                'সব দেখুন',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        _recentRequests.isEmpty
            ? _buildEmptyState()
            : ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _recentRequests.length,
                separatorBuilder: (context, index) => SizedBox(height: 2.h),
                itemBuilder: (context, index) {
                  final request = _recentRequests[index];
                  return RecentRequestCardWidget(
                    bloodType: request["bloodType"] as String,
                    patientName: request["patientName"] as String,
                    location: request["location"] as String,
                    district: request["district"] as String,
                    contactNumber: request["contactNumber"] as String,
                    urgencyLevel: request["urgencyLevel"] as String,
                    timeAgo: _getTimeAgo(request["requestTime"] as DateTime),
                    unitsNeeded: request["unitsNeeded"] as int,
                    donorType: request["donorType"] as String,
                    isEmergency: request["isEmergency"] as bool,
                    onCallPressed: () {
                      // Handle call action
                    },
                    onSharePressed: () {
                      // Handle share action
                    },
                    onReportPressed: () {
                      // Handle report action
                    },
                  );
                },
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
          CustomIconWidget(
            iconName: 'water_drop',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'কোন জরুরি অনুরোধ নেই',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'বর্তমানে কোন জরুরি রক্তের অনুরোধ নেই।\nনতুন অনুরোধের জন্য অপেক্ষা করুন।',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
