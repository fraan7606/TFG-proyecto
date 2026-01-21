enum Role { client, admin }
enum AuthMethod { email, phone }

class User {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final AuthMethod authMethod;
  final Role role;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    required this.authMethod,
    required this.role,
    required this.createdAt,
  });

  // Desde JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      authMethod: AuthMethod.values.firstWhere(
        (e) => e.name.toUpperCase() == json['authMethod'],
      ),
      role: Role.values.firstWhere(
        (e) => e.name.toUpperCase() == json['role'],
      ),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // A JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'authMethod': authMethod.name.toUpperCase(),
      'role': role.name.toUpperCase(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Verificar si es admin
  bool get isAdmin => role == Role.admin;

  // Obtener método de notificación preferido
  String get notificationMethod => authMethod == AuthMethod.email ? 'email' : 'sms';
}
