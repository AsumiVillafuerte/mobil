import 'package:flutter/material.dart';

class Room {
  final String roomNumber;
  final String type;
  final String description;
  final String floor;
  final double price;
  final String status;
  final String availability;
  final Color availabilityBgColor;
  final Color availabilityTextColor;
  final Color statusBgColor;
  final Color statusTextColor;
  final Color typeBgColor;
  final Color typeTextColor;

  Room({
    required this.roomNumber,
    required this.type,
    required this.description,
    required this.floor,
    required this.price,
    required this.status,
    required this.availability,
    required this.availabilityBgColor,
    required this.availabilityTextColor,
    required this.statusBgColor,
    required this.statusTextColor,
    required this.typeBgColor,
    required this.typeTextColor,
  });
}