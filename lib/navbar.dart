import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
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
        //<-- SEE HERE

        backgroundColor: Color.fromARGB(255, 50, 50, 48),
        automaticallyImplyLeading: false, // This will remove the back button
        title: Column(
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(width: 10),

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
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.white,
                ),
                SizedBox(width: 10),
                Text('Salah lashein', style: TextStyle(color: Colors.white)),
                SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: Color.fromARGB(255, 50, 50, 48),
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            labelType: NavigationRailLabelType.selected,
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.library_books, color: Colors.white),
                selectedIcon: Icon(
                  Icons.library_books,
                  size: 30,
                  color: Color.fromARGB(255, 9, 181, 152),
                ),
                label: Text('Exercise Library',
                    style: TextStyle(color: Colors.white)),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.layers, color: Colors.white),
                selectedIcon: Icon(
                  Icons.layers,
                  size: 30,
                  color: Color.fromARGB(255, 9, 181, 152),
                ),
                label: Text('Templates', style: TextStyle(color: Colors.white)),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people, color: Colors.white),
                selectedIcon: Icon(
                  Icons.people,
                  size: 30,
                  color: Color.fromARGB(255, 9, 181, 152),
                ),
                label: Text('Athlete Overview',
                    style: TextStyle(color: Colors.white)),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.list, color: Colors.white),
                selectedIcon: Icon(
                  Icons.list,
                  size: 30,
                  color: Color.fromARGB(255, 9, 181, 152),
                ),
                label:
                    Text('Athlete List', style: TextStyle(color: Colors.white)),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.chat, color: Colors.white),
                selectedIcon: Icon(
                  Icons.chat,
                  size: 30,
                  color: Color.fromARGB(255, 9, 181, 152),
                ),
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
