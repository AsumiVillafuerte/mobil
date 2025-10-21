class RegisterRequest {
  final String names;
  final String surnames;
  final String gender;
  final String email;
  final String password;
  final String phone;
  final String documentType;
  final String documentNumber;

  RegisterRequest({
    required this.names,
    required this.surnames,
    required this.gender,
    required this.email,
    required this.password,
    required this.phone,
    required this.documentType,
    required this.documentNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'names': names,
      'surnames': surnames,
      'gender': gender,
      'email': email,
      'password': password,
      'phone': phone,
      'documentType': documentType,
      'documentNumber': documentNumber,
    };
  }
}