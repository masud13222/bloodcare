import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class StatisticsCardWidget extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool isFullWidth;

  const StatisticsCardWidget({
    Key? key,
    required this.data,
    this.isFullWidth = false,
  }) : super(key: key);

  @override
  State<StatisticsCardWidget> createState() => _StatisticsCardWidgetState();
}

class _StatisticsCardWidgetState extends State<StatisticsCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<int> _counterAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _counterAnimation = IntTween(
      begin: 0,
      end: widget.data["count"] as int,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.isFullWidth ? double.infinity : null,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: (widget.data["color"] as Color).withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: widget.isFullWidth
                ? _buildFullWidthContent()
                : _buildRegularContent(),
          ),
        );
      },
    );
  }

  Widget _buildRegularContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: (widget.data["color"] as Color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: widget.data["icon"] as String,
                color: widget.data["color"] as Color,
                size: 24,
              ),
            ),
            CustomIconWidget(
              iconName: 'trending_up',
              color: AppTheme.getSuccessColor(true),
              size: 16,
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Text(
          _formatNumber(_counterAnimation.value),
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: widget.data["color"] as Color,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          widget.data["subtitle"] as String,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildFullWidthContent() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: (widget.data["color"] as Color).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: CustomIconWidget(
            iconName: widget.data["icon"] as String,
            color: widget.data["color"] as Color,
            size: 32,
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _formatNumber(_counterAnimation.value),
                style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: widget.data["color"] as Color,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                widget.data["subtitle"] as String,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        CustomIconWidget(
          iconName: 'trending_up',
          color: AppTheme.getSuccessColor(true),
          size: 20,
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(0)}k+';
    }
    return '$number+';
  }
}
