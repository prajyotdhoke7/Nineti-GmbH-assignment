
class User1 {
  final int id;
  final String name;
  final String email;
  final String image;

  User1({
    required this.id,
    required this.name,
    required this.email,
    required this.image,
  });

  factory User1.fromJson(Map<String, dynamic> json) {
    return User1(
      id: json['id'],
      name: "${json['firstName']} ${json['lastName']}",
      email: json['email'],
      image: json['image'] ?? 'https://via.placeholder.com/150',
    );
  }
}
