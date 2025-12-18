import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
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
        title: Text(
          "Paramètres",
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
      ),
      
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildSectionTitle("Apparence"),
          SizedBox(height: 8),
          _buildSettingsCard(
            child: SwitchListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              title: Text(
                "Mode sombre",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                "Activer le thème sombre",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              secondary: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.dark_mode_rounded, color: Color(0xFFF59E0B)),
              ),
              value: isDarkMode,
              activeColor: Color(0xFF6366F1),
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
            ),
          ),
          
          SizedBox(height: 24),
          
          _buildSectionTitle("Données"),
          SizedBox(height: 8),
          _buildSettingsCard(
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.delete_forever_rounded, color: Color(0xFFEF4444)),
              ),
              title: Text(
                "Supprimer tous les contacts",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                "Action irréversible",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
              onTap: () => _confirmDeleteAll(context, provider),
            ),
          ),
          
          SizedBox(height: 24),
          
          _buildSectionTitle("Compte"),
          SizedBox(height: 8),
          _buildSettingsCard(
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.logout_rounded, color: Color(0xFF3B82F6)),
              ),
              title: Text(
                "Déconnexion",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                "Se déconnecter de l'application",
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
              onTap: () async {
                await auth.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                  (_) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade600,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required Widget child}) {
    return Container(
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
      child: child,
    );
  }

  void _confirmDeleteAll(BuildContext context, ContactProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Tout supprimer",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text("Voulez-vous vraiment supprimer tous les contacts ? Cette action est irréversible."),
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
            onPressed: () async {
              final contacts = provider.contacts;
              for (var contact in contacts) {
                await provider.deleteContact(contact.id);
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
