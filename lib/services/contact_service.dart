// lib/services/contact_service.dart
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../models/contact.dart';

class ContactService {
  static const String boxName = 'contactsBox';
  final Box _box = Hive.box(boxName);
  final _uuid = Uuid();

  List<Contact> getAll() {
    return _box.values.cast<Contact>().toList();
  }

  Future<void> add(Contact contact) async {
    await _box.put(contact.id, contact);
  }

  Future<void> update(Contact contact) async {
    await contact.save();
  }

  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  String createId() => _uuid.v4();
}
