import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/donation_summary_card_widget.dart';
import './widgets/donation_timeline_widget.dart';
import './widgets/filter_options_widget.dart';
import './widgets/health_trends_widget.dart';

class DonationHistoryScreen extends StatefulWidget {
  const DonationHistoryScreen({Key? key}) : super(key: key);

  @override
  State<DonationHistoryScreen> createState() => _DonationHistoryScreenState();
}

class _DonationHistoryScreenState extends State<DonationHistoryScreen>
    with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  late AnimationController _countdownController;
  late Animation<int> _countdownAnimation;

  bool _isLoading = false;
  Map<String, dynamic> _appliedFilters = {};

  // Mock data for donation summary
  final Map<String, dynamic> _summaryData = {
    'totalDonations': 6,
    'totalUnits': 12,
    'nextEligibleDate': DateTime.now().add(Duration(days: 11)),
    'lastDonationDate': DateTime.now().subtract(Duration(days: 45)),
  };

  // Mock data for donation history
  List<Map<String, dynamic>> _donationHistory = [
    {
      'id': 1,
      'date': '২৫ মে, ২০২৪',
      'hospital': 'ঢাকা মেডিকেল কলেজ হাসপাতাল',
      'bloodType': 'B+',
      'units': 2,
      'status': 'completed',
      'feedback': 'অসাধারণ সেবা! দাতার জন্য অনেক ধন্যবাদ।',
      'staffSignature': 'ডা. রহিম উদ্দিন',
      'timestamp': DateTime.now().subtract(Duration(days: 45)),
    },
    {
      'id': 2,
      'date': '১৫ মার্চ, ২০২৪',
      'hospital': 'চট্টগ্রাম মেডিকেল কলেজ',
      'bloodType': 'B+',
      'units': 2,
      'status': 'completed',
      'feedback': null,
      'staffSignature': 'ডা. ফাতেমা খাতুন',
      'timestamp': DateTime.now().subtract(Duration(days: 116)),
    },
    {
      'id': 3,
      'date': '১০ জানু, ২০২৪',
      'hospital': 'সিলেট এমএজি ওসমানী মেডিকেল কলেজ',
      'bloodType': 'B+',
      'units': 2,
      'status': 'completed',
      'feedback': 'সময়মত পৌঁছানোর জন্য ধন্যবাদ।',
      'staffSignature': 'ডা. করিম আহমেদ',
      'timestamp': DateTime.now().subtract(Duration(days: 181)),
    },
    {
      'id': 4,
      'date': '২০ নভেম্বর, ২০২৩',
      'hospital': 'রাজশাহী মেডিকেল কলেজ',
      'bloodType': 'B+',
      'units': 2,
      'status': 'completed',
      'feedback': null,
      'staffSignature': 'ডা. নাসির হোসেন',
      'timestamp': DateTime.now().subtract(Duration(days: 232)),
    },
    {
      'id': 5,
      'date': '৫ সেপ্টেম্বর, ২০২৩',
      'hospital': 'বরিশাল শের-ই-বাংলা মেডিকেল কলেজ',
      'bloodType': 'B+',
      'units': 2,
      'status': 'cancelled',
      'feedback': null,
      'staffSignature': null,
      'timestamp': DateTime.now().subtract(Duration(days: 308)),
    },
    {
      'id': 6,
      'date': '২২ জুলাই, ২০২৩',
      'hospital': 'খুলনা মেডিকেল কলেজ',
      'bloodType': 'B+',
      'units': 2,
      'status': 'completed',
      'feedback': 'দুর্দান্ত! এই ধরনের দাতাদের আমাদের আরও প্রয়োজন।',
      'staffSignature': 'ডা. সালমা বেগম',
      'timestamp': DateTime.now().subtract(Duration(days: 352)),
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeCountdown();
    _applyFilters();
  }

  void _initializeCountdown() {
    _countdownController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    final daysLeft =
        _summaryData['nextEligibleDate'].difference(DateTime.now()).inDays;
    _countdownAnimation = IntTween(
      begin: daysLeft,
      end: daysLeft,
    ).animate(_countdownController);
  }

  @override
  void dispose() {
    _countdownController.dispose();
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

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterOptionsWidget(
        onFilterApplied: (filters) {
          setState(() {
            _appliedFilters = filters;
          });
          _applyFilters();
        },
        currentFilters: _appliedFilters,
      ),
    );
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filteredHistory = List.from(_donationHistory);

    // Apply blood type filter
    if (_appliedFilters['bloodType'] != null) {
      filteredHistory = filteredHistory
          .where((donation) =>
              donation['bloodType'] == _appliedFilters['bloodType'])
          .toList();
    }

    // Apply status filter
    if (_appliedFilters['status'] != null) {
      String statusFilter = _appliedFilters['status'];
      String statusKey = statusFilter == 'সফল'
          ? 'completed'
          : statusFilter == 'বাতিল'
              ? 'cancelled'
              : statusFilter == 'পেন্ডিং'
                  ? 'pending'
                  : statusFilter;

      if (statusKey != 'সব') {
        filteredHistory = filteredHistory
            .where((donation) => donation['status'] == statusKey)
            .toList();
      }
    }

    // Apply date range filter
    if (_appliedFilters['dateRange'] != null) {
      DateTimeRange range = _appliedFilters['dateRange'];
      filteredHistory = filteredHistory
          .where((donation) =>
              donation['timestamp'].isAfter(range.start) &&
              donation['timestamp'].isBefore(range.end.add(Duration(days: 1))))
          .toList();
    }

    setState(() {
      _donationHistory = filteredHistory;
    });
  }

  void _exportHistory() {
    // Implement export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('দানের ইতিহাস PDF হিসেবে রপ্তানি করা হচ্ছে...'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Text(
          'দানের ইতিহাস',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showFilterOptions,
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
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

                // Summary Cards Section
                _buildSummarySection(),

                SizedBox(height: 3.h),

                // Health Trends Section
                HealthTrendsWidget(donationData: _donationHistory),

                SizedBox(height: 3.h),

                // Reminder Card
                _buildReminderCard(),

                SizedBox(height: 3.h),

                // Donation Timeline
                DonationTimelineWidget(
                  donations: _donationHistory,
                  onExport: _exportHistory,
                ),

                SizedBox(height: 10.h), // Bottom padding
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'দানের সারসংক্ষেপ',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        GridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 3.w,
          mainAxisSpacing: 2.h,
          childAspectRatio: 0.9,
          children: [
            DonationSummaryCardWidget(
              title: 'মোট দান',
              value: '${_summaryData['totalDonations']}',
              subtitle: 'সফল দান সম্পন্ন',
              icon: Icons.volunteer_activism,
              color: AppTheme.lightTheme.primaryColor,
            ),
            DonationSummaryCardWidget(
              title: 'রক্তের ইউনিট',
              value: '${_summaryData['totalUnits']}',
              subtitle: 'ইউনিট দান করেছেন',
              icon: Icons.water_drop,
              color: AppTheme.getSuccessColor(true),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReminderCard() {
    final daysLeft =
        _summaryData['nextEligibleDate'].difference(DateTime.now()).inDays;
    final canDonateNow = daysLeft <= 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: canDonateNow
                ? [
                    AppTheme.getSuccessColor(true).withAlpha(26),
                    AppTheme.getSuccessColor(true).withAlpha(13)
                  ]
                : [
                    AppTheme.getWarningColor(true).withAlpha(26),
                    AppTheme.getWarningColor(true).withAlpha(13)
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: canDonateNow
                        ? AppTheme.getSuccessColor(true).withAlpha(51)
                        : AppTheme.getWarningColor(true).withAlpha(51),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    canDonateNow ? Icons.check_circle : Icons.schedule,
                    color: canDonateNow
                        ? AppTheme.getSuccessColor(true)
                        : AppTheme.getWarningColor(true),
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        canDonateNow
                            ? 'দানের জন্য প্রস্তুত!'
                            : 'পরবর্তী দানের সময়',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: canDonateNow
                              ? AppTheme.getSuccessColor(true)
                              : AppTheme.getWarningColor(true),
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        canDonateNow
                            ? 'আপনি এখন রক্তদান করতে পারেন।'
                            : 'আরও $daysLeft দিন অপেক্ষা করুন।',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'সুস্থ থাকতে এবং নিয়মিত দান করতে প্রচুর পানি পান করুন এবং পুষ্টিকর খাবার খান।',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
