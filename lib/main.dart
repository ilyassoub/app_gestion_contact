import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'providers/contact_provider.dart';
import 'services/auth_service.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'AIzaSyA3nAcn1jfS9lWEYg2xxkHQkvCj48cE-rI',
          appId: '1:1015282084100:android:2449856d8e938a57964851',
          messagingSenderId: '1015282084100',
          projectId: 'appgestioncontacts',
        ),
      );
    } else {
      // For web, Windows, etc., initialize without options
      await Firebase.initializeApp();
    }
  } catch (e) {
    print('Firebase initialization failed: $e');
    // Continue without Firebase
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProxyProvider<AuthService, ContactProvider>(
          create: (context) => ContactProvider(auth: Provider.of<AuthService>(context, listen: false)),
          update: (context, auth, previous) => previous ?? ContactProvider(auth: auth)..loadContacts(),
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
      ),
    );
  }
}