// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAccount _$GetAccountFromJson(Map<String, dynamic> json) {
  return GetAccount(
    accountId: json['account_id'] as String,
    name: json['name'] == null
        ? null
        : Name.fromJson(json['name'] as Map<String, dynamic>),
    email: json['email'] as String,
    emailVerified: json['email_verified'] as bool,
    disabled: json['disabled'] as bool,
    isTeammate: json['is_teammate'] as bool,
    profilePhotoUrl: json['profile_photo_url'] as String,
  );
}

Map<String, dynamic> _$GetAccountToJson(GetAccount instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'name': instance.name?.toJson(),
      'email': instance.email,
      'email_verified': instance.emailVerified,
      'disabled': instance.disabled,
      'is_teammate': instance.isTeammate,
      'profile_photo_url': instance.profilePhotoUrl,
    };

Name _$NameFromJson(Map<String, dynamic> json) {
  return Name(
    givenName: json['given_name'] as String,
    surname: json['surname'] as String,
    familiarName: json['familiar_name'] as String,
    displayName: json['display_name'] as String,
    abbreviatedName: json['abbreviated_name'] as String,
  );
}

Map<String, dynamic> _$NameToJson(Name instance) => <String, dynamic>{
      'given_name': instance.givenName,
      'surname': instance.surname,
      'familiar_name': instance.familiarName,
      'display_name': instance.displayName,
      'abbreviated_name': instance.abbreviatedName,
    };
