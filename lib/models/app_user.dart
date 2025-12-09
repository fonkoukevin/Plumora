class AppUser {
  final String id;
  final String email;
  final String? penName;
  final String? role;
  final DateTime createdAt;

  AppUser({
    required this.id,
    required this.email,
    this.penName,
    this.role,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'penName': penName,
      'role': role,
      'createdAt': createdAt.toUtc().toIso8601String(),
    };
  }

  factory AppUser.fromMap(String id, Map<String, dynamic> map) {
    return AppUser(
      id: id,
      email: map['email'] as String,
      penName: map['penName'] as String?,
      role: map['role'] as String?,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
