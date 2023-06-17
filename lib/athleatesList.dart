import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AthleteHoverNotifier(),
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Athletes'),
          ),
          body: AthletesGrid(),
        ),
      ),
    );
  }
}

class AthletesGrid extends StatelessWidget {
  final List<String> athletes = [
    'Athlete 1',
    'Athlete 2',
    'Athlete 3',
    'Athlete 4',
    'Athlete 5',
    'Athlete 6',
    'Athlete 1',
    'Athlete 2',
    'Athlete 3',
    'Athlete 4',
    'Athlete 5',
    'Athlete 6',
    'Athlete 1',
    'Athlete 2',
    'Athlete 3',
    'Athlete 4',
    'Athlete 5',
    'Athlete 6',
    'Athlete 1',
    'Athlete 2',
    'Athlete 3',
    'Athlete 4',
    'Athlete 5',
    'Athlete 6'
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 6, // Limit the maximum number of cards in a row to 6
      children:
          athletes.map((athlete) => AthleteCard(athleteName: athlete)).toList(),
    );
  }
}

class AthleteCard extends StatefulWidget {
  final String athleteName;

  AthleteCard({required this.athleteName});

  @override
  _AthleteCardState createState() => _AthleteCardState();
}

class _AthleteCardState extends State<AthleteCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final athleteHoverNotifier = Provider.of<AthleteHoverNotifier>(context);

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovering = true;
          athleteHoverNotifier.setHovering(true);
        });
      },
      onExit: (_) {
        setState(() {
          _isHovering = false;
          athleteHoverNotifier.setHovering(false);
        });
      },
      child: Card(
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Visibility(
                visible: !_isHovering,
                child: Text(widget.athleteName),
              ),
              Visibility(
                visible: _isHovering,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.person),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.message),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AthleteHoverNotifier with ChangeNotifier {
  bool _isHovering = false;

  bool get isHovering => _isHovering;

  void setHovering(bool hovering) {
    _isHovering = hovering;
    notifyListeners();
  }
}
