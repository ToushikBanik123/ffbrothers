class UserModel {
  final String id;
  final String username;
  final String phone;
  final String password;

  UserModel({
    required this.id,
    required this.username,
    required this.phone,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      phone: json['phone'],
      password: json['password'], // Include the password in the model
    );
  }
}


