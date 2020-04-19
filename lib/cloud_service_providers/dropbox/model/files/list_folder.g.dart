// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_folder.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListFolder _$FilesFromJson(Map<String, dynamic> json) {
  return ListFolder(
    entries: (json['entries'] as List)
        ?.map(
            (e) => e == null ? null : Entry.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    cursor: json['cursor'] as String,
    hasMore: json['has_more'] as bool,
  );
}

Map<String, dynamic> _$FilesToJson(ListFolder instance) => <String, dynamic>{
      'entries': instance.entries?.map((e) => e?.toJson())?.toList(),
      'cursor': instance.cursor,
      'has_more': instance.hasMore,
    };

Entry _$EntryFromJson(Map<String, dynamic> json) {
  return Entry(
    tag: json['.tag'] as String,
    name: json['name'] as String,
    id: json['id'] as String,
    clientModified: json['client_modified'] == null
        ? null
        : DateTime.parse(json['client_modified'] as String),
    serverModified: json['server_modified'] == null
        ? null
        : DateTime.parse(json['server_modified'] as String),
    rev: json['rev'] as String,
    size: json['size'] as int,
    pathLower: json['path_lower'] as String,
    pathDisplay: json['path_display'] as String,
    sharingInfo: json['sharing_info'] == null
        ? null
        : SharingInfo.fromJson(json['sharing_info'] as Map<String, dynamic>),
    isDownloadable: json['is_downloadable'] as bool,
    propertyGroups: (json['property_groups'] as List)
        ?.map((e) => e == null
            ? null
            : PropertyGroup.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    hasExplicitSharedMembers: json['has_explicit_shared_members'] as bool,
    contentHash: json['content_hash'] as String,
    fileLockInfo: json['fileLockInfo'] == null
        ? null
        : FileLockInfo.fromJson(json['fileLockInfo'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$EntryToJson(Entry instance) => <String, dynamic>{
      '.tag': instance.tag,
      'name': instance.name,
      'id': instance.id,
      'client_modified': instance.clientModified?.toIso8601String(),
      'server_modified': instance.serverModified?.toIso8601String(),
      'rev': instance.rev,
      'size': instance.size,
      'path_lower': instance.pathLower,
      'path_display': instance.pathDisplay,
      'sharing_info': instance.sharingInfo?.toJson(),
      'is_downloadable': instance.isDownloadable,
      'property_groups':
          instance.propertyGroups?.map((e) => e?.toJson())?.toList(),
      'has_explicit_shared_members': instance.hasExplicitSharedMembers,
      'content_hash': instance.contentHash,
      'fileLockInfo': instance.fileLockInfo?.toJson(),
    };

FileLockInfo _$FileLockInfoFromJson(Map<String, dynamic> json) {
  return FileLockInfo(
    isLockholder: json['is_lockholder'] as bool,
    lockholderName: json['lockholder_name'] as String,
    created: json['created'] == null
        ? null
        : DateTime.parse(json['created'] as String),
  );
}

Map<String, dynamic> _$FileLockInfoToJson(FileLockInfo instance) =>
    <String, dynamic>{
      'is_lockholder': instance.isLockholder,
      'lockholder_name': instance.lockholderName,
      'created': instance.created?.toIso8601String(),
    };

PropertyGroup _$PropertyGroupFromJson(Map<String, dynamic> json) {
  return PropertyGroup(
    templateId: json['template_id'] as String,
    fields: (json['fields'] as List)
        ?.map(
            (e) => e == null ? null : Field.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PropertyGroupToJson(PropertyGroup instance) =>
    <String, dynamic>{
      'template_id': instance.templateId,
      'fields': instance.fields?.map((e) => e?.toJson())?.toList(),
    };

Field _$FieldFromJson(Map<String, dynamic> json) {
  return Field(
    name: json['name'] as String,
    value: json['value'] as String,
  );
}

Map<String, dynamic> _$FieldToJson(Field instance) => <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
    };

SharingInfo _$SharingInfoFromJson(Map<String, dynamic> json) {
  return SharingInfo(
    readOnly: json['read_only'] as bool,
    parentSharedFolderId: json['parent_shared_folder_id'] as String,
    modifiedBy: json['modified_by'] as String,
    traverseOnly: json['traverse_only'] as bool,
    noAccess: json['no_access'] as bool,
  );
}

Map<String, dynamic> _$SharingInfoToJson(SharingInfo instance) =>
    <String, dynamic>{
      'read_only': instance.readOnly,
      'parent_shared_folder_id': instance.parentSharedFolderId,
      'modified_by': instance.modifiedBy,
      'traverse_only': instance.traverseOnly,
      'no_access': instance.noAccess,
    };
