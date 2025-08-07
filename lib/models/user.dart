
class User {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String userType; // 'farmer' or 'consumer'
  final String? address;
  final String? profileImage;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
    this.address,
    this.profileImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'userType': userType,
      'address': address,
      'profileImage': profileImage,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      userType: map['userType'],
      address: map['address'],
      profileImage: map['profileImage'],
    );
  }
}
