import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/pages/admin_home.dart';
import 'package:mobile_app/pages/cart.dart';
import 'package:mobile_app/pages/shop.dart';
import 'package:mobile_app/services/firestore_service.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'pages/login.dart';
import 'pages/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final firestoreService = FirestoreService();

    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => authService,
        ),
        Provider<FirestoreService>(
          create: (_) => firestoreService,
        ),
        StreamProvider<User?>(
          create: (_) => authService.userChanges,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Shopping App',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: Consumer<User?>(
          builder: (context, user, _) {
            if (user == null) {
              return LoginPage();
            } else {
              return HomePage();
            }
          },
        ),
        routes: {
          '/login': (context) => LoginPage(),
          '/shop': (context) => ShopPage(),
          '/cart': (context) => CartPage(),
          '/admin': (context) => AdminHomePage(),
        },
      ),
    );
  }
}
