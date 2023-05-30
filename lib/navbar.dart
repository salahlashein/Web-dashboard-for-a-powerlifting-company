import 'package:flutter/material.dart';
class Navbar extends StatefulWidget {
  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    Text('Dashboard Page', style: TextStyle(color: Colors.white)),
    Text('Exercise Library Page', style: TextStyle(color: Colors.white)),
    Text('Templates Page', style: TextStyle(color: Colors.white)),
    Text('Athlete Overview Page', style: TextStyle(color: Colors.white)),
    Text('Athlete List Page', style: TextStyle(color: Colors.white)),
    Text('Chat Page', style: TextStyle(color: Colors.white)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // This will remove the back button
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/300'), // Replace this with your image link
            ),
            SizedBox(width: 10),
            Text('User Name', style: TextStyle(color: Colors.white)),
            // Replace this with the user's name
            SizedBox(width: 20),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                // Add your action for settings icon here
              },
            ),
            SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.notifications),
              onPressed: () {
                // Add your action for notification icon here
              },
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            labelType: NavigationRailLabelType.selected,
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard),
                selectedIcon: Icon(Icons.dashboard, size: 30),
                label: Text('Dashboard', style: TextStyle(color: Colors.white)),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.library_books),
                selectedIcon: Icon(Icons.library_books, size: 30),
                label: Text(
                    'Exercise Library', style: TextStyle(color: Colors.white)),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.layers),
                selectedIcon: Icon(Icons.layers, size: 30),
                label: Text('Templates', style: TextStyle(color: Colors.white)),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people),
                selectedIcon: Icon(Icons.people, size: 30),
                label: Text(
                    'Athlete Overview', style: TextStyle(color: Colors.white)),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.list),
                selectedIcon: Icon(Icons.list, size: 30),
                label: Text(
                    'Athlete List', style: TextStyle(color: Colors.white)),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.chat),
                selectedIcon: Icon(Icons.chat, size: 30),
                label: Text('Chat', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
          ),
        ],
      ),
    );
  }
}