class User {
  final String id;
  final String email;
  final String name;
  final String? profileImage;
  final String? address;
  final String? registrationNo;
  final String? licenseNo;
  final String? phone;
  final String? alternativePhone;
  final String? password;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.profileImage,
    this.address,
    this.registrationNo,
    this.licenseNo,
    this.phone,
    this.alternativePhone,
    this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      profileImage: json['profileImage'] as String?,
      address: json['address'] as String?,
      registrationNo: json['registrationNo'] as String?,
      licenseNo: json['licenseNo'] as String?,
      phone: json['phone'] as String?,
      alternativePhone: json['alternativePhone'] as String?,
      password: json['password'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profileImage': profileImage,
      'address': address,
      'registrationNo': registrationNo,
      'licenseNo': licenseNo,
      'phone': phone,
      'alternativePhone': alternativePhone,
      'password': password,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? profileImage,
    String? address,
    String? registrationNo,
    String? licenseNo,
    String? phone,
    String? alternativePhone,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      address: address ?? this.address,
      registrationNo: registrationNo ?? this.registrationNo,
      licenseNo: licenseNo ?? this.licenseNo,
      phone: phone ?? this.phone,
      alternativePhone: alternativePhone ?? this.alternativePhone,
      password: password ?? this.password,
    );
  }
}
