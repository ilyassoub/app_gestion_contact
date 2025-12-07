import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'models/contact.dart';
import 'providers/contact_provider.dart';
import 'services/auth_service.dart';

import 'screens/contacts_list_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/add_edit_contact_screen.dart';
import 'screens/contact_details_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser Hive
  try {
    await Hive.initFlutter();
    Hive.registerAdapter(ContactAdapter());
    await Hive.openBox('contactsBox');
  } catch (e) {
    print('Hive init error: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ContactProvider()..loadContacts(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Contacts App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: SplashScreen(),
        routes: {
          '/contacts': (context) => ContactsListScreen(),
          '/favorites': (context) => FavoritesScreen(),
          '/settings': (context) => SettingsScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/details') {
            final contact = settings.arguments as Contact;
            return MaterialPageRoute(
              builder: (_) => ContactDetailsScreen(contact: contact),
            );
          }
          if (settings.name == '/add_contact') {
            final provider = Provider.of<ContactProvider>(
              settings.arguments as BuildContext,
              listen: false,
            );
            final newContact = provider.createEmpty();
            return MaterialPageRoute(
              builder: (_) => AddEditContactScreen(contact: newContact),
            );
          }
          return null;
        },
      ),
    );
  }
}