
class LostItem {
  final String id;
  final String name;
  final String category;
  final String description;
  final String colour;
  final String location;
  final String type;
  final String status;
  final String? imagePath;
  final DateTime date;
  final DateTime createdAt;

  LostItem({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.colour,
    required this.location,
    required this.type,
    this.status = 'Open',
    this.imagePath,
    required this.date,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'colour': colour,
      'location': location,
      'type': type,
      'status': status,
      'imagePath': imagePath,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory LostItem.fromJson(Map<String, dynamic> json) {
    return LostItem(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      colour: json['colour'] ?? '',
      location: json['location'],
      type: json['type'],
      status: json['status'] ?? 'Open',
      imagePath: json['imagePath'],
      date: DateTime.parse(json['date']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
