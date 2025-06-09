// lib/controllers/permission_controller.dart

import 'package:permission_handler/permission_handler.dart';

/// Handles requesting and (if needed) directing the user to enable

class PermissionController {
  /// The set of permissions we need at startup.
  final List<Permission> _requiredPermissions = [
    Permission.camera,
    Permission.photos, // iOS
    Permission.storage, // Android
  ];

  /// Requests all required permissions in one go.
  /// If any permission is permanently denied, opens the app settings.
  Future<void> requestAllPermissions() async {
    final statuses = await _requiredPermissions.request();

    // If any permission is permanently denied, open app settings
    if (statuses.values.any((st) => st.isPermanentlyDenied)) {
      await openAppSettings();
    }
  }

  /// Returns true if all required permissions are granted.
  Future<bool> arePermissionsGranted() async {
    final statuses = await Future.wait(
      _requiredPermissions.map((p) => p.status),
    );
    return statuses.every((st) => st.isGranted);
  }
}
