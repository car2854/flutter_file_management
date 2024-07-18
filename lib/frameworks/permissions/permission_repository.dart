
import 'package:file_management/frameworks/permissions/permission_handle_adapter.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionRepository {
  final PermissionHandlerAdapter _permissionHandler;

  PermissionRepository(this._permissionHandler);

  Future<bool> requestStoragePermission() async {
    var status = await _permissionHandler.requestStoragePermission();
    return status.isGranted;
  }

  Future<bool> hasStoragePermission() async {
    return await _permissionHandler.hasStoragePermission();
  }
}