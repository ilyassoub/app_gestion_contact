import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_gestion_contacts/services/auth_service.dart';
import 'login_screen.dart';

import '../providers/contact_provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ContactProvider>(context, listen: false);
    final auth = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Paramètres"),
      ),

      body: ListView(
        children: [
          // MODE SOMBRE
          SwitchListTile(
            title: Text("Mode sombre"),
            value: isDarkMode,
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
              });
            },
          ),

          Divider(),

          // VIDER TOUS LES CONTACTS
          ListTile(
            leading: Icon(Icons.delete_forever, color: Colors.red),
            title: Text("Supprimer tous les contacts"),
            onTap: () {
              _confirmDeleteAll(context, provider);
            },
          ),

          Divider(),

          // INFOS
          ListTile(
            leading: Icon(Icons.info),
            title: Text("Version"),
            subtitle: Text("1.0.0"),
          ),

          // DÉCONNEXION
          ListTile(
            leading: Icon(Icons.logout, color: Colors.blue),
            title: Text("Déconnexion"),
            onTap: () async {
              await auth.signOut();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
                (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  // CONFIRMATION
  void _confirmDeleteAll(BuildContext context, ContactProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Tout supprimer"),
        content: Text("Voulez-vous vraiment supprimer tous les contacts ?"),
        actions: [
          TextButton(
            child: Text("Annuler"),
            onPressed: () => Navigator.pop(ctx),
          ),
          TextButton(
            child: Text("Supprimer", style: TextStyle(color: Colors.red)),
            onPressed: () async {
              final contacts = provider.contacts;
              for (var c in contacts) {
                await provider.deleteContact(c.id);
              }

              Navigator.pop(ctx);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}