// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_space_usage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetSpaceUsage _$GetSpaceUsageFromJson(Map<String, dynamic> json) {
  return GetSpaceUsage(
    used: (json['used'] as num)?.toDouble(),
    allocation: json['allocation'] == null
        ? null
        : Allocation.fromJson(json['allocation'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GetSpaceUsageToJson(GetSpaceUsage instance) =>
    <String, dynamic>{
      'used': instance.used,
      'allocation': instance.allocation?.toJson(),
    };

Allocation _$AllocationFromJson(Map<String, dynamic> json) {
  return Allocation(
    tag: json['.tag'] as String,
    allocated: (json['allocated'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$AllocationToJson(Allocation instance) =>
    <String, dynamic>{
      '.tag': instance.tag,
      'allocated': instance.allocated,
    };
