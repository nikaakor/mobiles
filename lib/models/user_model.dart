class UserModel {
  final String name;
  final String email;
  final String password;
  final String role;
  final String eventName;
  final String gender;
  final int age;
  final String phone;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.eventName = "",
    this.gender = "Не вказано",
    this.age = 0,
    this.phone = "",
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'eventName': eventName,
      'gender': gender,
      'age': age,
      'phone': phone,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      role: map['role'] ?? 'Відвідувач',
      eventName: map['eventName'] ?? '',
      gender: map['gender'] ?? 'Не вказано',
      age: map['age'] ?? 0,
      phone: map['phone'] ?? '',
    );
  }

  UserModel copyWith({
    String? name,
    String? gender,
    int? age,
    String? phone,
    String? eventName,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email,
      password: password,
      role: role,
      eventName: eventName ?? this.eventName,
      gender: gender ?? this.gender,
      age: age ?? this.age,
      phone: phone ?? this.phone,
    );
  }
}