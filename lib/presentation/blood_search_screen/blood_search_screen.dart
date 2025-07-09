import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/blood_type_selector_widget.dart';
import './widgets/donor_card_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/location_filter_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/sort_options_widget.dart';

class BloodSearchScreen extends StatefulWidget {
  const BloodSearchScreen({Key? key}) : super(key: key);

  @override
  State<BloodSearchScreen> createState() => _BloodSearchScreenState();
}

class _BloodSearchScreenState extends State<BloodSearchScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String selectedBloodType = '';
  String selectedLocation = 'ঢাকা';
  String searchQuery = '';
  bool isLoading = false;
  String sortBy = 'distance';

  // Mock data for donors
  final List<Map<String, dynamic>> donorsList = [
    {
      "id": 1,
      "name": "মোহাম্মদ রহিম",
      "bloodType": "A+",
      "location": "ধানমন্ডি, ঢাকা",
      "district": "ঢাকা",
      "isAvailable": true,
      "lastDonation": "২০২৪-০৫-১৫",
      "phone": "+৮৮০১৭১২৩৪৫৬৭৮",
      "distance": 2.5,
      "profileImage":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
      "lastActive": "২ ঘন্টা আগে",
      "donationCount": 8,
      "isFavorite": false
    },
    {
      "id": 2,
      "name": "ফাতেমা খাতুন",
      "bloodType": "B+",
      "location": "গুলশান, ঢাকা",
      "district": "ঢাকা",
      "isAvailable": true,
      "lastDonation": "২০২৪-০৬-২০",
      "phone": "+৮৮০১৮১২৩৪৫৬৭৮",
      "distance": 4.2,
      "profileImage":
          "https://images.unsplash.com/photo-1494790108755-2616b332c1c2?w=150&h=150&fit=crop&crop=face",
      "lastActive": "১ ঘন্টা আগে",
      "donationCount": 5,
      "isFavorite": true
    },
    {
      "id": 3,
      "name": "আহমেদ হাসান",
      "bloodType": "O+",
      "location": "মিরপুর, ঢাকা",
      "district": "ঢাকা",
      "isAvailable": false,
      "lastDonation": "২০২৪-০৭-০১",
      "phone": "+৮৮০১৯১২৩৪৫৬৭৮",
      "distance": 6.8,
      "profileImage":
          "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face",
      "lastActive": "৫ ঘন্টা আগে",
      "donationCount": 12,
      "isFavorite": false
    },
    {
      "id": 4,
      "name": "সালমা বেগম",
      "bloodType": "AB+",
      "location": "উত্তরা, ঢাকা",
      "district": "ঢাকা",
      "isAvailable": true,
      "lastDonation": "২০২৪-০৪-১০",
      "phone": "+৮৮০১৬১২৩৪৫৬৭৮",
      "distance": 8.1,
      "profileImage":
          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face",
      "lastActive": "৩০ মিনিট আগে",
      "donationCount": 3,
      "isFavorite": false
    },
    {
      "id": 5,
      "name": "করিম উদ্দিন",
      "bloodType": "A-",
      "location": "বনানী, ঢাকা",
      "district": "ঢাকা",
      "isAvailable": true,
      "lastDonation": "২০২৪-০৬-০৫",
      "phone": "+৮৮০১৫১২৩৪৫৬৭৮",
      "distance": 3.7,
      "profileImage":
          "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150&h=150&fit=crop&crop=face",
      "lastActive": "১ দিন আগে",
      "donationCount": 15,
      "isFavorite": true
    }
  ];

  List<Map<String, dynamic>> filteredDonors = [];
  int _currentIndex = 1; // Search tab is active

  @override
  void initState() {
    super.initState();
    filteredDonors = donorsList;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = _searchController.text;
      _filterDonors();
    });
  }

  void _filterDonors() {
    setState(() {
      filteredDonors = donorsList.where((donor) {
        bool matchesSearch = searchQuery.isEmpty ||
            (donor["name"] as String)
                .toLowerCase()
                .contains(searchQuery.toLowerCase()) ||
            (donor["location"] as String)
                .toLowerCase()
                .contains(searchQuery.toLowerCase());

        bool matchesBloodType = selectedBloodType.isEmpty ||
            donor["bloodType"] == selectedBloodType;

        bool matchesLocation =
            selectedLocation.isEmpty || donor["district"] == selectedLocation;

        return matchesSearch && matchesBloodType && matchesLocation;
      }).toList();

      _sortDonors();
    });
  }

  void _sortDonors() {
    switch (sortBy) {
      case 'distance':
        filteredDonors.sort((a, b) =>
            (a["distance"] as double).compareTo(b["distance"] as double));
        break;
      case 'lastActive':
        filteredDonors.sort((a, b) =>
            (a["lastActive"] as String).compareTo(b["lastActive"] as String));
        break;
      case 'donationHistory':
        filteredDonors.sort((a, b) =>
            (b["donationCount"] as int).compareTo(a["donationCount"] as int));
        break;
    }
  }

  void _onBloodTypeSelected(String bloodType) {
    setState(() {
      selectedBloodType = bloodType;
      _filterDonors();
    });
  }

  void _onLocationChanged(String location) {
    setState(() {
      selectedLocation = location;
      _filterDonors();
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        onApplyFilters: (filters) {
          // Apply filters logic here
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SortOptionsWidget(
        currentSort: sortBy,
        onSortChanged: (newSort) {
          setState(() {
            sortBy = newSort;
            _sortDonors();
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
      // Update donor availability status
      for (var donor in donorsList) {
        if (donor["id"] == 3) {
          donor["isAvailable"] = true;
        }
      }
      _filterDonors();
    });
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home-dashboard');
        break;
      case 1:
        // Current screen
        break;
      case 2:
        Navigator.pushNamed(context, '/emergency-request-screen');
        break;
      case 3:
        // Profile screen navigation would go here
        break;
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
          'রক্তদাতা খোঁজ',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: EdgeInsets.all(4.w),
            color: AppTheme.lightTheme.colorScheme.surface,
            child: SearchBarWidget(
              controller: _searchController,
              onChanged: (value) => _onSearchChanged(),
            ),
          ),

          // Blood Type Selector
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: BloodTypeSelectorWidget(
              selectedBloodType: selectedBloodType,
              onBloodTypeSelected: _onBloodTypeSelected,
            ),
          ),

          // Location Filter and Advanced Filters
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Expanded(
                  child: LocationFilterWidget(
                    selectedLocation: selectedLocation,
                    onLocationChanged: _onLocationChanged,
                  ),
                ),
                SizedBox(width: 3.w),
                ElevatedButton.icon(
                  onPressed: _showFilterBottomSheet,
                  icon: CustomIconWidget(
                    iconName: 'filter_list',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 18,
                  ),
                  label: Text(
                    'ফিল্টার',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Results List
          Expanded(
            child: filteredDonors.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      itemCount: filteredDonors.length,
                      itemBuilder: (context, index) {
                        final donor = filteredDonors[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 2.h),
                          child: DonorCardWidget(
                            donor: donor,
                            onCall: () => _onCallDonor(donor),
                            onMessage: () => _onMessageDonor(donor),
                            onFavorite: () => _onToggleFavorite(donor),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showSortOptions,
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        child: CustomIconWidget(
          iconName: 'sort',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.backgroundColor,
        selectedItemColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor:
            AppTheme.lightTheme.bottomNavigationBarTheme.unselectedItemColor,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: _currentIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
              size: 24,
            ),
            label: 'হোম',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'search',
              color: _currentIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
              size: 24,
            ),
            label: 'খোঁজ',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'emergency',
              color: _currentIndex == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
              size: 24,
            ),
            label: 'জরুরি',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentIndex == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
              size: 24,
            ),
            label: 'প্রোফাইল',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search_off',
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.3),
            size: 80,
          ),
          SizedBox(height: 3.h),
          Text(
            'কোন দাতা পাওয়া যায়নি',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'অনুসন্ধানের পরিসর বাড়ানোর চেষ্টা করুন',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () {
              setState(() {
                selectedBloodType = '';
                selectedLocation = '';
                _searchController.clear();
                _filterDonors();
              });
            },
            child: Text('ফিল্টার রিসেট করুন'),
          ),
        ],
      ),
    );
  }

  void _onCallDonor(Map<String, dynamic> donor) {
    // Implement call functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${donor["name"]} কে কল করা হচ্ছে...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _onMessageDonor(Map<String, dynamic> donor) {
    // Implement message functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${donor["name"]} কে বার্তা পাঠানো হচ্ছে...'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }

  void _onToggleFavorite(Map<String, dynamic> donor) {
    setState(() {
      donor["isFavorite"] = !(donor["isFavorite"] as bool);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(donor["isFavorite"]
            ? '${donor["name"]} প্রিয় তালিকায় যোগ করা হয়েছে'
            : '${donor["name"]} প্রিয় তালিকা থেকে সরানো হয়েছে'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      ),
    );
  }
}
