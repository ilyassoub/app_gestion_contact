import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/contact.dart';
import '../providers/contact_provider.dart';
import 'add_edit_contact_screen.dart';

class ContactDetailsScreen extends StatelessWidget {
  final Contact contact;

  ContactDetailsScreen({required this.contact});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ContactProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(contact.name),
        actions: [
          // BOUTON MODIFIER
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddEditContactScreen(contact: contact),
                ),
              );
            },
          ),

          // BOUTON SUPPRIMER
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _confirmDelete(context, provider);
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NOM
            Text(
              contact.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 12),

            // TELEPHONE
            Row(
              children: [
                Icon(Icons.phone, color: Colors.blue),
                SizedBox(width: 10),
                Text(contact.phone, style: TextStyle(fontSize: 18)),
              ],
            ),
            SizedBox(height: 16),

            // EMAIL
            Row(
              children: [
                Icon(Icons.email, color: Colors.orange),
                SizedBox(width: 10),
                Text(contact.email.isEmpty ? "—" : contact.email,
                    style: TextStyle(fontSize: 18)),
              ],
            ),
            SizedBox(height: 16),

            // NOTE
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.note, color: Colors.green),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    contact.note.isEmpty ? "Aucune note" : contact.note,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // CONFIRMATION DE SUPPRESSION
  void _confirmDelete(BuildContext context, ContactProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Supprimer"),
        content: Text("Voulez-vous vraiment supprimer ce contact ?"),
        actions: [
          TextButton(
            child: Text("Annuler"),
            onPressed: () => Navigator.pop(ctx),
          ),
          TextButton(
            child: Text("Supprimer", style: TextStyle(color: Colors.red)),
            onPressed: () {
              provider.deleteContact(contact.id);
              Navigator.pop(ctx); // ferme dialog
              Navigator.pop(context); // retourne liste
            },
          ),
        ],
      ),
    );
  }
}
