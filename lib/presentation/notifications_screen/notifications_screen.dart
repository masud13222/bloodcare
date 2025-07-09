import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/notification_card_widget.dart';
import './widgets/notification_filter_tab_widget.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  late TabController _tabController;
  bool _isLoading = false;
  int _selectedTabIndex = 2; // Notifications tab active
  bool _isBulkSelectionMode = false;
  Set<String> _selectedNotificationIds = {};

  // Mock data for notifications
  final List<Map<String, dynamic>> _notifications = [
    {
      "id": "1",
      "type": "emergency",
      "title": "জরুরি রক্তের প্রয়োজন",
      "message": "A+ রক্তের জন্য জরুরি প্রয়োজন - ঢাকা মেডিকেল কলেজ হাসপাতালে",
      "senderName": "জনাব আহমেদ",
      "senderAvatar":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
      "timestamp": DateTime.now().subtract(Duration(minutes: 5)),
      "isRead": false,
      "bloodType": "A+",
      "priority": "high",
    },
    {
      "id": "2",
      "type": "donation",
      "title": "দান সম্পন্ন হয়েছে",
      "message":
          "আপনার রক্তদান সফলভাবে সম্পন্ন হয়েছে। ধন্যবাদ আপনার মহান দানের জন্য।",
      "senderName": "BloodCare সিস্টেম",
      "senderAvatar":
          "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?w=150&h=150&fit=crop&crop=face",
      "timestamp": DateTime.now().subtract(Duration(hours: 2)),
      "isRead": false,
      "priority": "normal",
    },
    {
      "id": "3",
      "type": "system",
      "title": "অ্যাপ আপডেট উপলব্ধ",
      "message":
          "নতুন ফিচার এবং বাগ ফিক্স সহ BloodCare অ্যাপের নতুন সংস্করণ উপলব্ধ।",
      "senderName": "BloodCare টিম",
      "senderAvatar":
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face",
      "timestamp": DateTime.now().subtract(Duration(hours: 6)),
      "isRead": true,
      "priority": "low",
    },
    {
      "id": "4",
      "type": "emergency",
      "title": "অতি জরুরি রক্তের প্রয়োজন",
      "message": "O- রক্তের জন্য অতি জরুরি প্রয়োজন - চট্টগ্রাম মেডিকেল কলেজে",
      "senderName": "ডাঃ রহিমা খাতুন",
      "senderAvatar":
          "https://images.unsplash.com/photo-1494790108755-2616b2e1e1c7?w=150&h=150&fit=crop&crop=face",
      "timestamp": DateTime.now().subtract(Duration(hours: 12)),
      "isRead": true,
      "bloodType": "O-",
      "priority": "high",
    },
    {
      "id": "5",
      "type": "donation",
      "title": "দান নিশ্চিতকরণ",
      "message": "আগামীকাল সকাল ১০টায় রক্তদানের জন্য নিবন্ধিত হয়েছেন।",
      "senderName": "রক্তদান কেন্দ্র",
      "senderAvatar":
          "https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=150&h=150&fit=crop&crop=face",
      "timestamp": DateTime.now().subtract(Duration(days: 1)),
      "isRead": true,
      "priority": "normal",
    },
    {
      "id": "6",
      "type": "system",
      "title": "নীতিমালা আপডেট",
      "message":
          "আমাদের গোপনীয়তা নীতি এবং ব্যবহারের শর্তাবলী আপডেট করা হয়েছে।",
      "senderName": "BloodCare টিম",
      "senderAvatar":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
      "timestamp": DateTime.now().subtract(Duration(days: 3)),
      "isRead": true,
      "priority": "low",
    },
  ];

  List<String> _filterTabs = ['সব', 'জরুরি', 'দান', 'সিস্টেম'];
  int _selectedFilterIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _filterTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
        Navigator.pushReplacementNamed(context, '/home-dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/blood-search-screen');
        break;
      case 2:
        // Already on notifications
        break;
      case 3:
        Navigator.pushNamed(context, '/user-profile-screen');
        break;
    }
  }

  void _onFilterChanged(int index) {
    setState(() {
      _selectedFilterIndex = index;
    });
  }

  void _toggleBulkSelection() {
    setState(() {
      _isBulkSelectionMode = !_isBulkSelectionMode;
      _selectedNotificationIds.clear();
    });
  }

  void _selectAllNotifications() {
    setState(() {
      _selectedNotificationIds = _getFilteredNotifications()
          .map((notification) => notification['id'] as String)
          .toSet();
    });
  }

  void _deleteSelectedNotifications() {
    // Implement delete logic
    setState(() {
      _selectedNotificationIds.clear();
      _isBulkSelectionMode = false;
    });
  }

  void _markAsRead(String notificationId) {
    setState(() {
      final index = _notifications.indexWhere((n) => n['id'] == notificationId);
      if (index != -1) {
        _notifications[index]['isRead'] = true;
      }
    });
  }

  void _markAsUnread(String notificationId) {
    setState(() {
      final index = _notifications.indexWhere((n) => n['id'] == notificationId);
      if (index != -1) {
        _notifications[index]['isRead'] = false;
      }
    });
  }

  void _deleteNotification(String notificationId) {
    setState(() {
      _notifications.removeWhere((n) => n['id'] == notificationId);
    });
  }

  void _shareNotification(String notificationId) {
    // Implement share logic
  }

  List<Map<String, dynamic>> _getFilteredNotifications() {
    if (_selectedFilterIndex == 0) return _notifications;

    String filterType = '';
    switch (_selectedFilterIndex) {
      case 1:
        filterType = 'emergency';
        break;
      case 2:
        filterType = 'donation';
        break;
      case 3:
        filterType = 'system';
        break;
    }

    return _notifications
        .where((notification) => notification['type'] == filterType)
        .toList();
  }

  int _getUnreadCount() {
    return _notifications.where((n) => !(n['isRead'] as bool)).length;
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
          'বিজ্ঞপ্তি',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.lightTheme.primaryColor,
          ),
        ),
        actions: [
          if (_isBulkSelectionMode) ...[
            TextButton(
              onPressed: _selectAllNotifications,
              child: Text(
                'সব নির্বাচন',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
            ),
            IconButton(
              onPressed: _deleteSelectedNotifications,
              icon: CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 24,
              ),
            ),
          ] else ...[
            IconButton(
              onPressed: _toggleBulkSelection,
              icon: CustomIconWidget(
                iconName: 'select_all',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
            IconButton(
              onPressed: () {
                // Navigate to settings
              },
              icon: CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
            ),
          ],
          SizedBox(width: 2.w),
        ],
      ),
      body: Column(
        children: [
          // Filter tabs
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: NotificationFilterTabWidget(
              tabs: _filterTabs,
              selectedIndex: _selectedFilterIndex,
              onTabSelected: _onFilterChanged,
            ),
          ),
          // Notifications list
          Expanded(
            child: RefreshIndicator(
              key: _refreshIndicatorKey,
              onRefresh: _handleRefresh,
              color: AppTheme.lightTheme.primaryColor,
              child: _getFilteredNotifications().isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      physics: AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      itemCount: _getFilteredNotifications().length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 2.h),
                      itemBuilder: (context, index) {
                        final notification = _getFilteredNotifications()[index];
                        return NotificationCardWidget(
                          notification: notification,
                          timeAgo: _getTimeAgo(
                              notification['timestamp'] as DateTime),
                          isBulkSelectionMode: _isBulkSelectionMode,
                          isSelected: _selectedNotificationIds
                              .contains(notification['id']),
                          onTap: () =>
                              _markAsRead(notification['id'] as String),
                          onMarkAsRead: () =>
                              _markAsRead(notification['id'] as String),
                          onMarkAsUnread: () =>
                              _markAsUnread(notification['id'] as String),
                          onDelete: () =>
                              _deleteNotification(notification['id'] as String),
                          onShare: () =>
                              _shareNotification(notification['id'] as String),
                          onSelectionChanged: (isSelected) {
                            setState(() {
                              if (isSelected) {
                                _selectedNotificationIds
                                    .add(notification['id'] as String);
                              } else {
                                _selectedNotificationIds
                                    .remove(notification['id'] as String);
                              }
                            });
                          },
                        );
                      },
                    ),
            ),
          ),
        ],
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
            icon: Stack(
              children: [
                CustomIconWidget(
                  iconName: 'notifications',
                  color: _selectedTabIndex == 2
                      ? AppTheme.lightTheme.primaryColor
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
                if (_getUnreadCount() > 0)
                  Positioned(
                    right: 0,
                    top: 0,
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
                        '${_getUnreadCount()}',
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

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'notifications_none',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'কোন বিজ্ঞপ্তি নেই',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'বর্তমানে কোন বিজ্ঞপ্তি নেই।\nনতুন বিজ্ঞপ্তির জন্য অপেক্ষা করুন।',
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
