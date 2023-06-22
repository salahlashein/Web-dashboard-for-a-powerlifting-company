import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/models/Athlete.dart';
import 'package:web_dashboard/models/Coach.dart';
import 'package:web_dashboard/models/Coach.dart';
import 'package:web_dashboard/services/userservice.dart';
import 'profile.dart';

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
  @override
  Widget build(BuildContext context) {
    UserService userService = UserService(); // Make sure it's instantiated
    final coachProvider = Provider.of<CoachProvider>(context);
    final coach = coachProvider.coach;

    return StreamBuilder<List<Athlete>>(
      stream: userService.getAthletes(coach.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator while waiting for the data
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Show error message if something went wrong
          print('Stream error: ${snapshot.error}'); // Debugging print
          return Text('Error: ${snapshot.error}');
        } else {
          // Build the grid of athlete cards
          List<Athlete> athletes = snapshot.data ?? [];
          print('Athletes received: $athletes'); // Debugging print
          return GridView.count(
            crossAxisCount:
                6, // Limit the maximum number of cards in a row to 6
            children: athletes
                .map((athlete) => AthleteCard(athleteName: athlete.firstName))
                .toList(),
          );
        }
      },
      // Disable caching by setting maintainState to false
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.library_books_sharp),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.restaurant_menu_outlined),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.bar_chart),
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
