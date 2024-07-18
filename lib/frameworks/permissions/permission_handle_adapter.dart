import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerAdapter {
  Future<PermissionStatus> requestStoragePermission() async {
    return await Permission.storage.request();
  }

  Future<bool> hasStoragePermission() async {
    return await Permission.storage.isGranted;
  }
}