import 'package:blood_donor/constants/color_constant.dart';
import 'package:blood_donor/helper_widget/custom_appbar.dart';
import 'package:blood_donor/helper_widget/custom_drawer.dart';
import 'package:blood_donor/screens/dashboard/home/home_screen.dart';
import 'package:blood_donor/theme/theme_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'profile/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;

  List<Widget> widgets = [
    const HomeScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final themeChanger = Provider.of<ThemeManager>(context);
    void logOUt() {
      FirebaseAuth.instance.signOut();
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const CustomDrawer(),
      appBar: _selectedIndex == 0
          ? PreferredSize(
              preferredSize: const Size.fromHeight(60.0),
              child: CustomAppBar(
                action: [
                  IconButton(
                    icon: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      logOUt();
                    },
                  ),
                  Switch(
                    value: themeChanger.themeMode == ThemeMode.dark,
                    onChanged: (newValue) => themeChanger.toggleTheme(newValue),
                  )
                ],
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
                title: 'Blood-Bank App',
              ))
          : _selectedIndex == 1
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(60.0),
                  child: CustomAppBar(
                    title: 'Donor Form',
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                    ),
                  ))
              : _selectedIndex == 2
                  ? const PreferredSize(
                      preferredSize: Size.fromHeight(60.0),
                      child: CustomAppBar(
                        title: 'Blood-Bank',
                      ))
                  : AppBar(),
      body: SafeArea(child: widgets.elementAt(_selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: whiteColor,
        selectedFontSize: 16,
        currentIndex: _selectedIndex,
        selectedItemColor: isDark ? Colors.blue : primaryColor,
        unselectedItemColor: Colors.black45,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.electrical_services_sharp,
            ),
            label: " Profile",
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    _selectedIndex = index;
    setState(() {});
  }
}
