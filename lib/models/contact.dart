class Contact {
  String id;
  String name;
  String phone;
  String email;
  String note;
  bool favorite;

  Contact({
    required this.id,
    required this.name,
    required this.phone,
    this.email = '',
    this.note = '',
    this.favorite = false,
  });

  // Convertir un document Firestore en Contact
  factory Contact.fromFirestore(Map<String, dynamic> data, String id) {
    return Contact(
      id: id,
      name: data['name'],
      phone: data['phone'],
      email: data['email'] ?? '',
      note: data['note'] ?? '',
      favorite: data['favorite'] ?? false,
    );
  }

  // Convertir un Contact en Map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'note': note,
      'favorite': favorite,
    };
  }

  // Convertir un Contact en JSON pour local storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'note': note,
      'favorite': favorite,
    };
  }

  // Factory pour JSON
  factory Contact.fromJson(Map<String, dynamic> json) {
    final data = Map<String, dynamic>.from(json);
    final id = data.remove('id') as String;
    return Contact.fromFirestore(data, id);
  }
}