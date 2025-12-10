import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Utility class for mapping FontAwesome CSS class strings to IconData
/// Supports both FontAwesome 4 and FontAwesome 5/6 icon names
class IconMapper {
  // Private constructor to prevent instantiation
  IconMapper._();

  /// Map of FontAwesome CSS class strings to IconData
  /// Format: 'fa-icon-name' => FontAwesomeIcons.iconName
  static final Map<String, IconData> _iconMap = {
    // Common icons
    'fa-university': FontAwesomeIcons.buildingColumns,
    'fa-users': FontAwesomeIcons.users,
    'fa-user': FontAwesomeIcons.user,
    'fa-user-plus': FontAwesomeIcons.userPlus,
    'fa-user-md': FontAwesomeIcons.userDoctor,

    // Healthcare & Medical
    'fa-hand-holding-heart': FontAwesomeIcons.handHoldingHeart,
    'fa-stethoscope': FontAwesomeIcons.stethoscope,
    'fa-hospital': FontAwesomeIcons.hospital,
    'fa-hospital-o': FontAwesomeIcons.hospital,
    'fa-medkit': FontAwesomeIcons.suitcaseMedical,

    // Calendar & Time
    'fa-calendar-check': FontAwesomeIcons.calendarCheck,
    'fa-calendar-check-o': FontAwesomeIcons.calendarCheck,
    'fa-calendar': FontAwesomeIcons.calendar,
    'fa-clock': FontAwesomeIcons.clock,
    'fa-clock-o': FontAwesomeIcons.clock,

    // Business & Office
    'fa-building': FontAwesomeIcons.building,
    'fa-briefcase': FontAwesomeIcons.briefcase,
    'fa-handshake': FontAwesomeIcons.handshake,
    'fa-handshake-o': FontAwesomeIcons.handshake,
    'fa-certificate': FontAwesomeIcons.certificate,

    // Education
    'fa-graduation-cap': FontAwesomeIcons.graduationCap,
    'fa-book': FontAwesomeIcons.book,
    'fa-pencil': FontAwesomeIcons.pencil,

    // Charts & Stats
    'fa-bar-chart': FontAwesomeIcons.chartBar,
    'fa-chart-bar': FontAwesomeIcons.chartBar,
    'fa-chart-line': FontAwesomeIcons.chartLine,
    'fa-chart-pie': FontAwesomeIcons.chartPie,

    // Nature & Environment
    'fa-leaf': FontAwesomeIcons.leaf,
    'fa-tree': FontAwesomeIcons.tree,
    'fa-seedling': FontAwesomeIcons.seedling,

    // Water & Utilities
    'fa-tint': FontAwesomeIcons.droplet,
    'fa-droplet': FontAwesomeIcons.droplet,

    // Food & Kitchen
    'fa-cutlery': FontAwesomeIcons.utensils,
    'fa-utensils': FontAwesomeIcons.utensils,

    // Children & Family
    'fa-child': FontAwesomeIcons.child,
    'fa-baby': FontAwesomeIcons.baby,

    // Documents & Files
    'fa-file-text': FontAwesomeIcons.fileLines,
    'fa-file-lines': FontAwesomeIcons.fileLines,
    'fa-file': FontAwesomeIcons.file,
    'fa-folder': FontAwesomeIcons.folder,

    // Lists & Tasks
    'fa-list-alt': FontAwesomeIcons.listCheck,
    'fa-list-check': FontAwesomeIcons.listCheck,
    'fa-check-square': FontAwesomeIcons.squareCheck,
    'fa-square-check': FontAwesomeIcons.squareCheck,
    'fa-tasks': FontAwesomeIcons.listCheck,

    // UI Elements
    'fa-th-large': FontAwesomeIcons.tableCellsLarge,
    'fa-th': FontAwesomeIcons.tableCells,
    'fa-bars': FontAwesomeIcons.bars,

    // Actions
    'fa-trash': FontAwesomeIcons.trash,
    'fa-edit': FontAwesomeIcons.penToSquare,
    'fa-save': FontAwesomeIcons.floppyDisk,

    // Games & Entertainment
    'fa-gamepad': FontAwesomeIcons.gamepad,

    // Default/Fallback
    'fa-circle': FontAwesomeIcons.circle,
    'fa-dot-circle': FontAwesomeIcons.circleDot,
  };

  /// Maps a FontAwesome CSS class string to IconData
  ///
  /// Accepts various input formats:
  /// - "fa fa-university"
  /// - "fa-university"
  /// - "fas fa-university"
  /// - "far fa-university"
  ///
  /// Returns the corresponding IconData or FontAwesomeIcons.circle as fallback
  ///
  /// Example:
  /// ```dart
  /// final icon = IconMapper.mapIcon("fa fa-university");
  /// // Returns: FontAwesomeIcons.university
  /// ```
  static IconData mapIcon(String iconString) {
    if (iconString.isEmpty) {
      return FontAwesomeIcons.circle;
    }

    // Clean the string: remove "fa ", "fas ", "far ", "fab " prefixes
    String cleaned = iconString
        .replaceAll('fa ', '')
        .replaceAll('fas ', '')
        .replaceAll('far ', '')
        .replaceAll('fab ', '')
        .trim();

    // Look up in map
    final icon = _iconMap[cleaned];

    // Return icon or fallback to circle
    return icon ?? FontAwesomeIcons.circle;
  }

  /// Checks if an icon string is mapped
  ///
  /// Returns true if the icon string has a mapping in the icon map
  static bool hasMapping(String iconString) {
    if (iconString.isEmpty) return false;

    String cleaned = iconString
        .replaceAll('fa ', '')
        .replaceAll('fas ', '')
        .replaceAll('far ', '')
        .replaceAll('fab ', '')
        .trim();

    return _iconMap.containsKey(cleaned);
  }

  /// Returns the list of all supported icon names
  static List<String> get supportedIcons => _iconMap.keys.toList();
}
