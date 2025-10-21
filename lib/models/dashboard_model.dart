import 'package:flutter/material.dart';

class Activity {
  final String title;
  final String time;
  final IconData icon;
  final Color iconColor;

  Activity({
    required this.title,
    required this.time,
    required this.icon,
    required this.iconColor,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      title: json['title'],
      time: json['time'],
      icon: _getIconFromString(json['icon']),
      iconColor: _getColorFromString(json['iconColor']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'time': time,
      'icon': icon.codePoint,
      'iconColor': iconColor.value,
    };
  }

  static IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'cleaning_services':
        return Icons.cleaning_services;
      case 'calendar_today':
        return Icons.calendar_today;
      case 'warning':
        return Icons.warning;
      default:
        return Icons.info;
    }
  }

  static Color _getColorFromString(String colorName) {
    switch (colorName) {
      case 'success':
        return const Color(0xFF4CAF50);
      case 'primary':
        return const Color(0xFF2196F3);
      case 'warning':
        return const Color(0xFFFF9800);
      default:
        return Colors.grey;
    }
  }
}

class DashboardStats {
  final String activeReservations;
  final String occupiedRooms;
  final String completedTasks;

  DashboardStats({
    required this.activeReservations,
    required this.occupiedRooms,
    required this.completedTasks,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      activeReservations: json['activeReservations'],
      occupiedRooms: json['occupiedRooms'],
      completedTasks: json['completedTasks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activeReservations': activeReservations,
      'occupiedRooms': occupiedRooms,
      'completedTasks': completedTasks,
    };
  }
}