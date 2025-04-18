import 'package:flutter/material.dart';
import 'package:habit_tracker/data/habit_databases.dart';
import 'package:habit_tracker/pages/login_page.dart';
import 'package:habit_tracker/pages/about_page.dart';

class CustomDrawer extends StatefulWidget {
  final String username;

  CustomDrawer({super.key, required this.username});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final HabitDatabases db = HabitDatabases();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFFE2E2E2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Container(
            margin: EdgeInsets.only(left: 15.0),
            child: Image.asset(
              'assets/account_circle.png',
              width: 80,
              height: 80,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            margin: EdgeInsets.only(left: 15.0),
            child: Text(widget.username,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const Divider(thickness: 2, height: 30, color: Colors.black),
          drawerItem(iconAsset: 'assets/home.png', label: 'Home', onTap: () {}),
          drawerItem(
              iconAsset: 'assets/settings.png',
              label: 'Settings',
              onTap: () {}),
          drawerItem(
              iconAsset: 'assets/user.png',
              label: 'Invite Friend',
              onTap: () {}),
          drawerItem(
              iconAsset: 'assets/share.png',
              label: 'Rate the App',
              onTap: () {}),
          drawerItem(
              iconAsset: 'assets/about.png',
              label: 'About Us',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          OurTeamPage()), // Navigasi ke OurTeamPage
                );
              }),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black12)),
            ),
            child: GestureDetector(
              onTap: () {
                final db = HabitDatabases();

                db.todaysHabitList.clear();
                db.heatMapDataSet.clear();
                setState(() {});
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Sign Out', style: TextStyle(color: Colors.black)),
                  SizedBox(width: 10),
                  Icon(Icons.logout, color: Colors.red),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget drawerItem(
      {required String iconAsset,
      required String label,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Image.asset(
        iconAsset,
        width: 24,
        height: 24,
      ),
      title: Text(label, style: const TextStyle(fontSize: 14)),
      onTap: onTap,
    );
  }
}
