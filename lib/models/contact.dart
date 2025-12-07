import 'package:hive/hive.dart';

part 'contact.g.dart';

@HiveType(typeId: 0)
class Contact extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String phone;

  @HiveField(3)
  String email;

  @HiveField(4)
  String note;

  @HiveField(5)
  bool favorite;

  Contact({
    required this.id,
    required this.name,
    required this.phone,
    this.email = '',
    this.note = '',
    this.favorite = false,
  });
}
