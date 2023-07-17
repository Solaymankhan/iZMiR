class user_model {
  final String name;
  final String? profile_img;
  final String email;
  final String phone;
  final String password;
  final String address;

  const user_model({
    required this.name,
    this.profile_img,
    required this.email,
    required this.phone,
    required this.password,
    required this.address,
  });

  toJason() {
    return {
      "name": name,
      "profile_picture": profile_img,
      "email": email,
      "phone": phone,
      "password": password,
      "address": address
    };
  }
}
