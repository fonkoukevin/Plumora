import 'package:flutter/material.dart';

class PlumoraBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final VoidCallback onHome;
  final VoidCallback onBeta;
  final VoidCallback onReading;
  final VoidCallback onNotif;
  final VoidCallback onProfile;

  const PlumoraBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onHome,
    required this.onBeta,
    required this.onReading,
    required this.onNotif,
    required this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: const Color(0xFF8B5E3C),
      unselectedItemColor: Colors.grey[500],
      onTap: (i) {
        switch (i) {
          case 0:
            onHome();
            break;
          case 1:
            onBeta();
            break;
          case 2:
            onReading();
            break;
          case 3:
            onNotif();
            break;
          case 4:
            onProfile();
            break;
        }
      },
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), label: "Accueil"),
        BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined), label: "Bêta"),
        BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined), label: "Lecture"),
        BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined), label: "Notifs"),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: "Profil"),
      ],
    );
  }
}
