import 'package:dropbox_clients_manager/cloud_service_providers/dropbox/model/files/list_folder.dart';

extension on Entry {
  bool get isFolder {
    return tag == "folder";
  }

  bool get isFile {
    return tag == "file";
  }
}