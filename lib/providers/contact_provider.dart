import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/contact.dart';
import '../services/auth_service.dart';

class ContactProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _auth;

  ContactProvider({required AuthService auth}) : _auth = auth;

  List<Contact> _contacts = [];
  List<Contact> get contacts => _contacts;

  String _searchQuery = '';
  List<Contact> get filteredContacts {
    if (_searchQuery.isEmpty) {
      return _contacts;
    }
    return _contacts.where((c) => c.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  List<Contact> get favorites => _contacts.where((c) => c.favorite).toList();

  Future<void> loadContacts() async {
    if (_auth.currentUserId != null) {
      try {
        final snapshot = await _firestore.collection('users').doc(_auth.currentUserId).collection('contacts').get();
        _contacts = snapshot.docs.map((doc) => Contact.fromFirestore(doc.data(), doc.id)).toList();
        notifyListeners();
      } catch (e) {
        print('Erreur lors du chargement des contacts: $e');
      }
    }
  }

  Future<void> addContact(Contact contact) async {
    if (_auth.currentUserId != null) {
      try {
        final docRef = await _firestore.collection('users').doc(_auth.currentUserId).collection('contacts').add(contact.toFirestore());
        final newContact = Contact(
          id: docRef.id,
          name: contact.name,
          phone: contact.phone,
          email: contact.email,
          note: contact.note,
          favorite: contact.favorite,
        );
        _contacts.add(newContact);
        notifyListeners();
      } catch (e) {
        throw Exception('Erreur Firebase: $e');
      }
    }
  }

  Future<void> updateContact(Contact c) async {
    if (_auth.currentUserId != null) {
      try {
        await _firestore.collection('users').doc(_auth.currentUserId).collection('contacts').doc(c.id).set(c.toFirestore(), SetOptions(merge: true));
        final index = _contacts.indexWhere((contact) => contact.id == c.id);
        if (index != -1) {
          _contacts[index] = c;
        }
        notifyListeners();
      } catch (e) {
        throw Exception('Erreur Firebase: $e');
      }
    }
  }

  Future<void> toggleFavorite(Contact c) async {
    final updated = Contact(
      id: c.id,
      name: c.name,
      phone: c.phone,
      email: c.email,
      note: c.note,
      favorite: !c.favorite,
    );
    await updateContact(updated);
  }

  Future<void> deleteContact(String id) async {
    if (_auth.currentUserId != null) {
      try {
        await _firestore.collection('users').doc(_auth.currentUserId).collection('contacts').doc(id).delete();
        _contacts.removeWhere((contact) => contact.id == id);
        notifyListeners();
      } catch (e) {
        throw Exception('Erreur Firebase: $e');
      }
    }
  }

  Contact createEmpty() {
    return Contact(
      id: '',
      name: '',
      phone: '',
      email: '',
      note: '',
      favorite: false,
    );
  }

  void searchContacts(String query) {
    _searchQuery = query;
    notifyListeners();
  }
}