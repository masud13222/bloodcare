import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/app_export.dart';

class NotificationCardWidget extends StatelessWidget {
  final Map<String, dynamic> notification;
  final String timeAgo;
  final bool isBulkSelectionMode;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onMarkAsRead;
  final VoidCallback onMarkAsUnread;
  final VoidCallback onDelete;
  final VoidCallback onShare;
  final Function(bool) onSelectionChanged;

  const NotificationCardWidget({
    Key? key,
    required this.notification,
    required this.timeAgo,
    required this.isBulkSelectionMode,
    required this.isSelected,
    required this.onTap,
    required this.onMarkAsRead,
    required this.onMarkAsUnread,
    required this.onDelete,
    required this.onShare,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification['id'] as String),
      background: _buildSwipeBackground(true),
      secondaryBackground: _buildSwipeBackground(false),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          if (notification['isRead'] as bool) {
            onMarkAsUnread();
          } else {
            onMarkAsRead();
          }
        } else {
          onDelete();
        }
      },
      child: GestureDetector(
        onTap:
            isBulkSelectionMode ? () => onSelectionChanged(!isSelected) : onTap,
        onLongPress: () => onSelectionChanged(!isSelected),
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: _getBorderColor(),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow
                    .withValues(alpha: 0.1),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              if (isBulkSelectionMode) ...[
                Checkbox(
                  value: isSelected,
                  onChanged: (value) => onSelectionChanged(value ?? false),
                  activeColor: AppTheme.lightTheme.primaryColor,
                ),
                SizedBox(width: 2.w),
              ],
              _buildAvatar(),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    SizedBox(height: 1.h),
                    _buildMessage(),
                    SizedBox(height: 0.5.h),
                    _buildFooter(),
                  ],
                ),
              ),
              if (!isBulkSelectionMode && !(notification['isRead'] as bool))
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: _getTypeColor().withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: notification['senderAvatar'] as String,
          width: 12.w,
          height: 12.w,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: AppTheme.lightTheme.colorScheme.surface,
            child: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: AppTheme.lightTheme.colorScheme.surface,
            child: CustomIconWidget(
              iconName: 'person',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: _getTypeColor().withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: _getTypeIcon(),
                color: _getTypeColor(),
                size: 12,
              ),
              SizedBox(width: 1.w),
              Text(
                _getTypeLabel(),
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: _getTypeColor(),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (notification['type'] == 'emergency' &&
            notification['bloodType'] != null) ...[
          SizedBox(width: 2.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: _getBloodTypeColor().withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getBloodTypeColor(),
                width: 1,
              ),
            ),
            child: Text(
              notification['bloodType'] as String,
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: _getBloodTypeColor(),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        Spacer(),
        Text(
          timeAgo,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          notification['title'] as String,
          style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: (notification['isRead'] as bool)
                ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                : AppTheme.lightTheme.colorScheme.onSurface,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 0.5.h),
        Text(
          notification['message'] as String,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: (notification['isRead'] as bool)
                ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                : AppTheme.lightTheme.colorScheme.onSurface,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Text(
          'থেকে: ${notification['senderName'] as String}',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        Spacer(),
        if (notification['type'] == 'emergency')
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'জরুরি প্রয়োজন',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        if (notification['type'] == 'donation')
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.getSuccessColor(true),
                  size: 12,
                ),
                SizedBox(width: 1.w),
                Text(
                  'ধন্যবাদ',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.getSuccessColor(true),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildSwipeBackground(bool isLeft) {
    return Container(
      alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 6.w),
      decoration: BoxDecoration(
        color: isLeft
            ? AppTheme.lightTheme.primaryColor
            : AppTheme.lightTheme.colorScheme.error,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: isLeft
                ? (notification['isRead'] as bool
                    ? 'mark_email_unread'
                    : 'mark_email_read')
                : 'delete',
            color: Colors.white,
            size: 24,
          ),
          SizedBox(height: 0.5.h),
          Text(
            isLeft
                ? (notification['isRead'] as bool ? 'অপঠিত' : 'পঠিত')
                : 'মুছুন',
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Border? _getBorderColor() {
    if (notification['type'] == 'emergency') {
      return Border.all(
        color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
        width: 2,
      );
    }
    return null;
  }

  Color _getTypeColor() {
    switch (notification['type']) {
      case 'emergency':
        return AppTheme.lightTheme.primaryColor;
      case 'donation':
        return AppTheme.getSuccessColor(true);
      case 'system':
        return Color(0xFF3182CE);
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getTypeIcon() {
    switch (notification['type']) {
      case 'emergency':
        return 'emergency';
      case 'donation':
        return 'water_drop';
      case 'system':
        return 'settings';
      default:
        return 'info';
    }
  }

  String _getTypeLabel() {
    switch (notification['type']) {
      case 'emergency':
        return 'জরুরি';
      case 'donation':
        return 'দান';
      case 'system':
        return 'সিস্টেম';
      default:
        return 'অন্যান্য';
    }
  }

  Color _getBloodTypeColor() {
    final bloodType = notification['bloodType'] as String? ?? '';
    switch (bloodType) {
      case 'A+':
      case 'A-':
        return Color(0xFFE53E3E);
      case 'B+':
      case 'B-':
        return Color(0xFF3182CE);
      case 'AB+':
      case 'AB-':
        return Color(0xFF805AD5);
      case 'O+':
      case 'O-':
        return Color(0xFF38A169);
      default:
        return AppTheme.lightTheme.primaryColor;
    }
  }
}