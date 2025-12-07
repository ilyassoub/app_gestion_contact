import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/contact_provider.dart';
import '../screens/contact_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ContactProvider>(context);
    final favorites = provider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: Text("Favoris"),
      ),

      body: favorites.isEmpty
          ? Center(
              child: Text(
                "Aucun contact favori ⭐",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final c = favorites[index];

                return ListTile(
                  leading: CircleAvatar(
                    child: Text(c.name.isNotEmpty ? c.name[0].toUpperCase() : '?'),
                  ),
                  title: Text(c.name),
                  subtitle: Text(c.phone),

                  // Retirer des favoris
                  trailing: IconButton(
                    icon: Icon(Icons.star, color: Colors.amber),
                    onPressed: () {
                      provider.toggleFavorite(c);
                    },
                  ),

                  // Voir détails
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ContactDetailsScreen(contact: c),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
