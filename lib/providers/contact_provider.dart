// lib/providers/contact_provider.dart
import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../services/contact_service.dart';

class ContactProvider extends ChangeNotifier {
  final ContactService _service = ContactService();
  List<Contact> contacts = [];
  List<Contact> favorites = [];
  List<Contact> filteredContacts = [];

 void loadContacts() {
  contacts = _service.getAll();
  favorites = contacts.where((c) => c.favorite).toList();
  filteredContacts = contacts;
  notifyListeners();
}


  Future<void> addContact(Contact contact) async {
    await _service.add(contact);
    loadContacts();
  }

  Future<void> updateContact(Contact contact) async {
    await _service.update(contact);
    loadContacts();
  }

  Future<void> deleteContact(String id) async {
    await _service.delete(id);
    loadContacts();
  }

  void toggleFavorite(Contact contact) async {
    contact.favorite = !contact.favorite;
    await _service.update(contact);
    loadContacts();
  }

  Contact createEmpty() {
    return Contact(id: _service.createId(), name: '', phone: '');
  }
  void searchContacts(String query) {
  if (query.isEmpty) {
    filteredContacts = contacts;
  } else {
    filteredContacts = contacts
        .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
  notifyListeners();
}

}
