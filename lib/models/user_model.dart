import 'dart:convert';

class UserModel {
  String name;
  final String email;
  DateTime dateOfBirth;
  String phone;
  String imagePath;
  UserModel({
    required this.dateOfBirth,
    this.name = "",
    this.email = "",
    this.phone = "",
    this.imagePath = "",
  });

  UserModel copyWith({
    String? name,
    String? email,
    DateTime? dateOfBirth,
    String? phone,
    String? imagePath,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phone: phone ?? this.phone,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'Email': email,
      'DateOfBirth': dateOfBirth.millisecondsSinceEpoch,
      'Phone': phone,
      'ImagePath': imagePath,
    };
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(Name: $name, Email: $email, DateOfBirth: $dateOfBirth, Phone: $phone, ImagePath: $imagePath)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.name == name &&
        other.email == email &&
        other.dateOfBirth == dateOfBirth &&
        other.phone == phone &&
        other.imagePath == imagePath;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        dateOfBirth.hashCode ^
        phone.hashCode ^
        imagePath.hashCode;
  }

  // factory UserModel.fromMap(Map<String, dynamic> map) {
  //   return UserModel(
  //     name: map['name'] ?? '',
  //     email: map['email'] ?? '',
  //     dateOfBirth: map['dateOfBirth'] ?? '',
  //     phone: map['phone'] ?? '',
  //     imagePath: map['imagePath'] ?? '',
  //   );
  // }

  factory UserModel.fromMap(Map<String, dynamic>? map) {
    return UserModel(
      name: map!['Name'] ?? '',
      email: map['Email'] ?? '',
      dateOfBirth: DateTime.fromMillisecondsSinceEpoch(map['DateOfBirth']),
      phone: map['Phone'] ?? '',
      imagePath: map['ImagePath'] ?? '',
    );
  }
}
