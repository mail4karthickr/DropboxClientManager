import 'package:json_annotation/json_annotation.dart';
part 'get_account.g.dart';

@JsonSerializable(explicitToJson: true)
class GetAccount {

  @JsonKey(name: 'account_id')
  String accountId;
  Name name;
  String email;

  @JsonKey(name: 'email_verified')
  bool emailVerified;
  bool disabled;

  @JsonKey(name: 'is_teammate')
  bool isTeammate;

  @JsonKey(name: 'profile_photo_url')
  String profilePhotoUrl;

  GetAccount({this.accountId, this.name, this.email,
    this.emailVerified, this.disabled, this.isTeammate, this.profilePhotoUrl});

  factory GetAccount.fromJson(Map<String, dynamic> json) => _$GetAccountFromJson(json);

  Map<String, dynamic> toJson() => _$GetAccountToJson(this);

  @override
  String toString() {
    return {
      'AccountId': accountId, 'Name': name, 'Email': email,
      'EmailVerified': emailVerified, 'Disabled': disabled, 'isTeammate': isTeammate,
      'ProfilePhotoUrl': profilePhotoUrl
    }.toString();
  }
}

@JsonSerializable(explicitToJson: true)
class Name {

  @JsonKey(name: 'given_name')
  String givenName;
  String surname;

  @JsonKey(name: 'familiar_name')
  String familiarName;

  @JsonKey(name: 'display_name')
  String displayName;

  @JsonKey(name: 'abbreviated_name')
  String abbreviatedName;

  Name({this.givenName, this.surname, this.familiarName, this.displayName, this.abbreviatedName});

  factory Name.fromJson(Map<String, dynamic> json) => _$NameFromJson(json);

  Map<String, dynamic> toJson() => _$NameToJson(this);

  @override
  String toString() {
    return {
      'givenName': givenName, 'surname': surname, 'familiarName': familiarName,
      'displayName': displayName, 'abbreviatedName': abbreviatedName
    }.toString();
  }
}