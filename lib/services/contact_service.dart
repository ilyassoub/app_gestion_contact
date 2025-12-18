import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/contact.dart';

class ContactService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _uuid = Uuid();

  Future<List<Contact>> getAll() async {
    try {
      final snapshot = await _firestore.collection('contacts').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Contact(
          id: doc.id,
          name: data['name'],
          phone: data['phone'],
          email: data['email'] ?? '',
          note: data['note'] ?? '',
          favorite: data['favorite'] ?? false,
        );
      }).toList();
    } catch (e) {
      print('Error fetching contacts: $e');
      return [];
    }
  }

  Future<void> add(Contact contact) async {
    try {
      await _firestore.collection('contacts').doc(contact.id).set({
        'name': contact.name,
        'phone': contact.phone,
        'email': contact.email,
        'note': contact.note,
        'favorite': contact.favorite,
      });
    } catch (e) {
      print('Error adding contact: $e');
    }
  }

  Future<void> update(Contact contact) async {
    try {
      await _firestore.collection('contacts').doc(contact.id).update({
        'name': contact.name,
        'phone': contact.phone,
        'email': contact.email,
        'note': contact.note,
        'favorite': contact.favorite,
      });
    } catch (e) {
      print('Error updating contact: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      await _firestore.collection('contacts').doc(id).delete();
    } catch (e) {
      print('Error deleting contact: $e');
    }
  }

  String createId() => _uuid.v4();
}