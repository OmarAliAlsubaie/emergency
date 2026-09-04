import 'package:flutter/material.dart';

class IconHelper {
  static IconData getIcon(String iconName) {
    switch (iconName) {
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'water':
      case 'water_drop':
        return Icons.water_drop;
      case 'wb_sunny':
        return Icons.wb_sunny;
      case 'directions_car':
      case 'car_crash':
        return Icons.directions_car;
      case 'home':
      case 'home_repair_service':
        return Icons.home;
      case 'corporate_fare':
      case 'exit_to_app':
        return Icons.corporate_fare;
      case 'bolt':
      case 'electrical_services':
        return Icons.bolt;
      case 'medical_services':
      case 'favorite':
        return Icons.medical_services;
      case 'shield':
        return Icons.shield;
      case 'health':
        return Icons.health_and_safety;
      case 'star':
        return Icons.star;
      case 'medal':
      case 'military_tech':
        return Icons.military_tech;
      case 'emergency':
        return Icons.emergency;
      case 'add_road':
        return Icons.add_road;
      case 'water_damage':
        return Icons.water_damage;
      case 'support_agent':
        return Icons.support_agent;
      case 'timer':
        return Icons.timer;
      case 'play_circle_filled':
        return Icons.play_circle_filled;
      case 'tsunami':
        return Icons.tsunami;
      case 'fire_extinguisher':
        return Icons.fire_extinguisher;
      case 'backpack':
        return Icons.backpack;
      case 'warning':
        return Icons.warning_amber_rounded;
      case 'people':
        return Icons.people;
      case 'person':
        return Icons.person;
      default:
        return Icons.shield;
    }
  }
}
