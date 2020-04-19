import 'package:dropbox_clients_manager/cloud_service_providers/dropbox/model/files/list_folder.dart';

extension EntryExtension on Entry {

  bool get isFolder {
    return tag == "folder";
  }

  bool get isFile {
    return tag == "file";
  }

  String get imageName {
    if (isFolder) {
      return 'images/db_folder.png';
    }
    return 'images/db_document.png';
  }

  String get lastModified {
    Duration diff = DateTime.now().difference(serverModified);
    if (diff.inDays > 365)
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    if (diff.inDays > 30)
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    if (diff.inDays > 7)
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    if (diff.inDays > 0)
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    if (diff.inHours > 0)
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    if (diff.inMinutes > 0)
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    return "just now";
  }

  String get fileSize {
    const double oneByte = 1000;
    const double oneKb = 1000;
    const double oneMb = 1;

    if (size < oneByte) {
      /// Less than 1 kilobyte
      return '$size bytes';
    } else if (size > oneByte && (size/1000) < oneKb) {
      /// 1 kilobyte
      final kb = (size/1000);
      return '${kb.toStringAsFixed(2)} kb';
    } else if (((size/1000)/1000) > oneMb) {
      /// greater than 1MB
      final mb = ((size/1000)/1000);
      return '${mb.toStringAsFixed(2)} mb';
    } else {
      return '';
    }
  }
}