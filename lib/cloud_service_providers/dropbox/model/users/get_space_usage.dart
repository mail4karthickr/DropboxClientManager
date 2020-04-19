import 'package:json_annotation/json_annotation.dart';
part 'package:dropbox_clients_manager/cloud_service_providers/dropbox/model/users/get_space_usage.g.dart';

@JsonSerializable(explicitToJson: true)
class GetSpaceUsage {
  double used;
  Allocation allocation;

  GetSpaceUsage({this.used, this.allocation});

  factory GetSpaceUsage.fromJson(Map<String, dynamic> json) => _$GetSpaceUsageFromJson(json);

  Map<String, dynamic> toJson() => _$GetSpaceUsageToJson(this);

  @override
  String toString() {
    return {
      'used': used, 'allocation': allocation
    }.toString();
  }
}

@JsonSerializable(explicitToJson: true)
class Allocation {

  @JsonKey(name: '.tag')
  String tag;
  double allocated;

  Allocation({this.tag, this.allocated});

  factory Allocation.fromJson(Map<String, dynamic> json) => _$AllocationFromJson(json);

  Map<String, dynamic> toJson() => _$AllocationToJson(this);

  @override
  String toString() {
    return {
      'tag': tag, 'allocated': allocated
    }.toString();
  }
}