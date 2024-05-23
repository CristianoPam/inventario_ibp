import 'package:flutter/material.dart';
import 'package:inventario_ibp/pages/relatorios_pages.dart';
import 'package:inventario_ibp/pages/home_page.dart';



import 'settings_page.dart';

class Pages extends StatefulWidget {
  const Pages({Key? key}) : super(key: key);

  @override
  State<Pages> createState() => _PagesState();
}

class _PagesState extends State<Pages> {
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Patrimônios',
          ),
         
          NavigationDestination(
            selectedIcon: Icon(Icons.assessment),
            icon: Icon(Icons.assessment),
            label: 'Relatórios',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.settings),
            icon: Icon(Icons.settings),
            label: 'configurações',
          ),
        ],
      ),
      body: <Widget>[
        const Homepage(),
        const RelatoriosPages(),                       
        const SettingsPage(),
      ][currentPageIndex],
    );
  }
}
