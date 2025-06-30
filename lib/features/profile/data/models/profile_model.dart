import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {
  ProfileModel({
    required this.id,
    required this.password,
    required this.lastLogin,
    required this.isSuperuser,
    required this.firstName,
    required this.email,
    required this.isStaff,
    required this.isActive,
    required this.dateJoined,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.deleted,
    required this.name,
    required this.surname,
    required this.lastName,
    required this.phone,
    required this.username,
    required this.autoWorkingTime,
    required this.groups,
    required this.userPermissions,
  });

  final int id;
  final String password;
  final dynamic lastLogin;
  final bool isSuperuser;
  final String firstName;
  final String email;
  final bool isStaff;
  final bool isActive;
  final DateTime? dateJoined;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic deletedAt;
  final bool deleted;
  final String name;
  final String surname;
  final String lastName;
  final String phone;
  final String username;
  final dynamic autoWorkingTime;
  final List<dynamic> groups;
  final List<dynamic> userPermissions;

  ProfileModel copyWith({
    int? id,
    String? password,
    dynamic? lastLogin,
    bool? isSuperuser,
    String? firstName,
    String? email,
    bool? isStaff,
    bool? isActive,
    DateTime? dateJoined,
    DateTime? createdAt,
    DateTime? updatedAt,
    dynamic? deletedAt,
    bool? deleted,
    String? name,
    String? surname,
    String? lastName,
    String? phone,
    String? username,
    dynamic? autoWorkingTime,
    List<dynamic>? groups,
    List<dynamic>? userPermissions,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      password: password ?? this.password,
      lastLogin: lastLogin ?? this.lastLogin,
      isSuperuser: isSuperuser ?? this.isSuperuser,
      firstName: firstName ?? this.firstName,
      email: email ?? this.email,
      isStaff: isStaff ?? this.isStaff,
      isActive: isActive ?? this.isActive,
      dateJoined: dateJoined ?? this.dateJoined,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      deleted: deleted ?? this.deleted,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      username: username ?? this.username,
      autoWorkingTime: autoWorkingTime ?? this.autoWorkingTime,
      groups: groups ?? this.groups,
      userPermissions: userPermissions ?? this.userPermissions,
    );
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json["id"] ?? 0,
      password: json["password"] ?? "",
      lastLogin: json["last_login"],
      isSuperuser: json["is_superuser"] ?? false,
      firstName: json["first_name"] ?? "",
      email: json["email"] ?? "",
      isStaff: json["is_staff"] ?? false,
      isActive: json["is_active"] ?? false,
      dateJoined: DateTime.tryParse(json["date_joined"] ?? ""),
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? ""),
      deletedAt: json["deleted_at"],
      deleted: json["deleted"] ?? false,
      name: json["name"] ?? "",
      surname: json["surname"] ?? "",
      lastName: json["last_name"] ?? "",
      phone: json["phone"] ?? "",
      username: json["username"] ?? "",
      autoWorkingTime: json["auto_working_time"],
      groups: json["groups"] == null
          ? []
          : List<dynamic>.from(json["groups"]!.map((x) => x)),
      userPermissions: json["user_permissions"] == null
          ? []
          : List<dynamic>.from(json["user_permissions"]!.map((x) => x)),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "password": password,
        "last_login": lastLogin,
        "is_superuser": isSuperuser,
        "first_name": firstName,
        "email": email,
        "is_staff": isStaff,
        "is_active": isActive,
        "date_joined": dateJoined?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "deleted": deleted,
        "name": name,
        "surname": surname,
        "last_name": lastName,
        "phone": phone,
        "username": username,
        "auto_working_time": autoWorkingTime,
        "groups": groups,
        "user_permissions": userPermissions,
      };

  @override
  List<Object?> get props => [
        id,
        password,
        lastLogin,
        isSuperuser,
        firstName,
        email,
        isStaff,
        isActive,
        dateJoined,
        createdAt,
        updatedAt,
        deletedAt,
        deleted,
        name,
        surname,
        lastName,
        phone,
        username,
        autoWorkingTime,
        groups,
        userPermissions,
      ];
}
