class Service {
  final String id;
  final String name;
  final String? description;
  final int durationMinutes;
  final double price;
  final bool active;

  Service({
    required this.id,
    required this.name,
    this.description,
    required this.durationMinutes,
    required this.price,
    this.active = true,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      durationMinutes: json['durationMinutes'],
      price: json['price'] is String ? double.parse(json['price']) : json['price'].toDouble(),
      active: json['active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'durationMinutes': durationMinutes,
      'price': price,
      'active': active,
    };
  }
}
