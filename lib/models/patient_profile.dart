class PatientProfile {
  final String firstName;
  final String middleName;
  final String lastName;
  final String phone;
  final String email;
  final String dob;
  final String age;
  final String address;

  PatientProfile({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.dob,
    required this.age,
    required this.address,
  });

  factory PatientProfile.fromJson(Map<String, dynamic> json) {
    return PatientProfile(
      firstName: json['firstName'] ?? '',
      middleName: json['middleName'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      dob: json['dob'] ?? '',
      age: json['age']?.toString() ?? '',
      address: json['address'] ?? '',
    );
  }
}
