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
        title: Text(
          contact.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        actions: [
          // BOUTON MODIFIER
          IconButton(
            icon: Icon(Icons.edit_rounded),
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
            icon: Icon(Icons.delete_rounded),
            onPressed: () {
              _confirmDelete(context, provider);
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: Center(
                      child: Text(
                        contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    contact.name,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // TELEPHONE
                  _buildInfoCard(
                    icon: Icons.phone_rounded,
                    iconColor: Color(0xFF10B981),
                    iconBgColor: Color(0xFFD1FAE5),
                    title: "Téléphone",
                    content: contact.phone,
                  ),
                  SizedBox(height: 16),

                  // EMAIL
                  _buildInfoCard(
                    icon: Icons.email_rounded,
                    iconColor: Color(0xFF3B82F6),
                    iconBgColor: Color(0xFFDBEAFE),
                    title: "Email",
                    content: contact.email.isEmpty ? "Non renseigné" : contact.email,
                  ),
                  SizedBox(height: 16),

                  // NOTE
                  _buildInfoCard(
                    icon: Icons.note_rounded,
                    iconColor: Color(0xFFF59E0B),
                    iconBgColor: Color(0xFFFEF3C7),
                    title: "Note",
                    content: contact.note.isEmpty ? "Aucune note" : contact.note,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade500,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // CONFIRMATION DE SUPPRESSION
  void _confirmDelete(BuildContext context, ContactProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Supprimer le contact",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text("Voulez-vous vraiment supprimer ce contact ?"),
        actions: [
          TextButton(
            child: Text(
              "Annuler",
              style: TextStyle(color: Colors.grey.shade600),
            ),
            onPressed: () => Navigator.pop(ctx),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text("Supprimer"),
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
