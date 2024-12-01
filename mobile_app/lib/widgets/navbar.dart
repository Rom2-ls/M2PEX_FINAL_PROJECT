import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
    final authService = context.read<AuthService>();
    final firestoreService = context.read<FirestoreService>();

    return AppBar(
      title: const Text('Super Marché Flutter'),
      actions: [
        if (user != null) ...[
          IconButton(
            icon: const Icon(FontAwesomeIcons.cartShopping),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
          FutureBuilder<bool>(
            future: firestoreService.isAdmin(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(); // Placeholder while checking admin status
              } else if (snapshot.hasData && snapshot.data == true) {
                return IconButton(
                  icon: const Icon(Icons.admin_panel_settings),
                  onPressed: () {
                    Navigator.pushNamed(context, '/admin');
                  },
                );
              } else {
                return Container(); // Not an admin, no button displayed
              }
            },
          ),
          IconButton(
            icon: const Icon(FontAwesomeIcons.rightFromBracket),
            onPressed: () async {
              await authService.signOut();
            },
          ),
        ] else ...[
          IconButton(
            icon: const Icon(Icons.login),
            onPressed: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
