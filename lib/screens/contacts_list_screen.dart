import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/contact_provider.dart';
import '../screens/add_edit_contact_screen.dart';
import '../screens/contact_details_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/settings_screen.dart';

class ContactsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ContactProvider>(context);
    final contacts = provider.filteredContacts;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Contacts'),
        actions: [
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (_) => FavoritesScreen())),
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen())),
          ),
        ],
      ),

      body: Column(
        children: [
          // 🔍 SEARCH BAR
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              onChanged: (value) => provider.searchContacts(value),
              decoration: InputDecoration(
                hintText: "Rechercher un contact...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // LISTE DES CONTACTS
          Expanded(
            child: contacts.isEmpty
                ? Center(
                    child: Text(
                      "Aucun contact trouvé",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final c = contacts[index];

                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: Text(
                              c.name.isNotEmpty ? c.name[0].toUpperCase() : '?',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(c.name),
                          subtitle: Text(c.phone),
                          trailing: IconButton(
                            icon: Icon(
                              c.favorite ? Icons.star : Icons.star_border,
                              color: c.favorite ? Colors.amber : Colors.grey,
                            ),
                            onPressed: () => provider.toggleFavorite(c),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ContactDetailsScreen(contact: c)),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          final newContact = provider.createEmpty();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEditContactScreen(contact: newContact),
            ),
          );
        },
      ),
    );
  }
}
