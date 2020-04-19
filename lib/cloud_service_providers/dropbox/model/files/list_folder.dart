import 'package:json_annotation/json_annotation.dart';
part 'list_folder.g.dart';

@JsonSerializable(explicitToJson: true)
class ListFolder {
  List<Entry> entries;
  String cursor;

  @JsonKey(name: 'has_more')
  bool hasMore;

  ListFolder({
    this.entries,
    this.cursor,
    this.hasMore,
  });

  factory ListFolder.fromJson(Map<String, dynamic> json) => _$FilesFromJson(json);

  Map<String, dynamic> toJson() => _$FilesToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable(explicitToJson: true)
class Entry {

  @JsonKey(name: '.tag')
  String tag;
  String name;
  String id;

  @JsonKey(name: 'client_modified')
  DateTime clientModified;

  @JsonKey(name: 'server_modified')
  DateTime serverModified;
  String rev;
  int size;

  @JsonKey(name: 'path_lower')
  String pathLower;

  @JsonKey(name: 'path_display')
  String pathDisplay;

  @JsonKey(name: 'sharing_info')
  SharingInfo sharingInfo;

  @JsonKey(name: 'is_downloadable')
  bool isDownloadable;

  @JsonKey(name: 'property_groups')
  List<PropertyGroup> propertyGroups;

  @JsonKey(name: 'has_explicit_shared_members')
  bool hasExplicitSharedMembers;

  @JsonKey(name: 'content_hash')
  String contentHash;
  FileLockInfo fileLockInfo;

  Entry({
    this.tag,
    this.name,
    this.id,
    this.clientModified,
    this.serverModified,
    this.rev,
    this.size,
    this.pathLower,
    this.pathDisplay,
    this.sharingInfo,
    this.isDownloadable,
    this.propertyGroups,
    this.hasExplicitSharedMembers,
    this.contentHash,
    this.fileLockInfo,
  });

  factory Entry.fromJson(Map<String, dynamic> json) =>  _$EntryFromJson(json);

  Map<String, dynamic> toJson() =>  _$EntryToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

//  bool get isFolder {
//    return tag == "folder";
//  }
//
//  bool get isFile {
//    return tag == "file";
//  }
}

@JsonSerializable(explicitToJson: true)
class FileLockInfo {

  @JsonKey(name: 'is_lockholder')
  bool isLockholder;

  @JsonKey(name: 'lockholder_name')
  String lockholderName;
  DateTime created;

  FileLockInfo({
    this.isLockholder,
    this.lockholderName,
    this.created,
  });

  factory FileLockInfo.fromJson(Map<String, dynamic> json) => _$FileLockInfoFromJson(json);

  Map<String, dynamic> toJson() => _$FileLockInfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PropertyGroup {

  @JsonKey(name: 'template_id')
  String templateId;
  List<Field> fields;

  PropertyGroup({
    this.templateId,
    this.fields,
  });

  factory PropertyGroup.fromJson(Map<String, dynamic> json) => _$PropertyGroupFromJson(json);

  Map<String, dynamic> toJson() => _$PropertyGroupToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Field {
  String name;
  String value;

  Field({
    this.name,
    this.value,
  });

  factory Field.fromJson(Map<String, dynamic> json) => _$FieldFromJson(json);

  Map<String, dynamic> toJson() => _$FieldToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SharingInfo {

  @JsonKey(name: 'read_only')
  bool readOnly;

  @JsonKey(name: 'parent_shared_folder_id')
  String parentSharedFolderId;

  @JsonKey(name: 'modified_by')
  String modifiedBy;

  @JsonKey(name: 'traverse_only')
  bool traverseOnly;

  @JsonKey(name: 'no_access')
  bool noAccess;

  SharingInfo({
    this.readOnly,
    this.parentSharedFolderId,
    this.modifiedBy,
    this.traverseOnly,
    this.noAccess,
  });


  factory SharingInfo.fromJson(Map<String, dynamic> json) => _$SharingInfoFromJson(json);

  Map<String, dynamic> toJson() => _$SharingInfoToJson(this);
}
