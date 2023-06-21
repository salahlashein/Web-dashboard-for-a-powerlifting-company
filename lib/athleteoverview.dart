import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:calendar_timeline/calendar_timeline.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
 late  DateTime _selectedDate;
  List<DocumentSnapshot> _documents = [];

  @override
  void initState() {
    super.initState();
  _resetSelectedDate();
  _selectedDate = DateTime.now();
  }

  void _resetSelectedDate() {
  DateTime  now = DateTime.now();
_onDateSelected(DateTime(now.year, now.month, now.day, 0,0,0));
  } 
    
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body:Column(
        children: [Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Athlete Overview',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: Colors.tealAccent[100]),
              ),
            ),
             CalendarTimeline(
              showYears: true,
              initialDate: _selectedDate,
              firstDate: DateTime.now().subtract(Duration(days:30)),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              leftMargin: 100,
              monthColor: Colors.white70,
              dayColor: Colors.teal[200],
              dayNameColor: const Color(0xFF333A47),
              activeDayColor: Colors.white,
              activeBackgroundDayColor: Colors.greenAccent[100],
              dotsColor: const Color(0xFF333A47),
              selectableDayPredicate: (date) => date.day != 23,
              locale: 'en',
              onDateSelected: (date) => _onDateSelected(date),
          ), const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.teal[200]),
                ),
                child: const Text(
                  'TODAY',
                  style: TextStyle(color: Color(0xFF333A47)),
                ),
                onPressed: () => setState(() => _resetSelectedDate()),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
          Expanded(
            child: _buildTable(),
          ),
        ],
      ),
    );
  }

  void _onDateSelected(DateTime date) {

    setState(() {
      _selectedDate = date;
      DateTime _endDate = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 23, 59, 59);
      _retrieveData(_endDate);
    });
  }

  void _retrieveData(DateTime _endDate) {
    // Retrieve the collection reference
    CollectionReference collection =
        FirebaseFirestore.instance.collection('Athletes');

    collection
       .where('date', isGreaterThanOrEqualTo: _selectedDate)
       .where('date', isLessThanOrEqualTo: _endDate)
        .get()
        .then((querySnapshot) {
      setState(() {
        _documents = querySnapshot.docs;
      });
    });
  }

  Widget _buildTable() {
    if (_documents.isEmpty) {
      return Center(
        child: Text('No data'),
      );
    }

    return DataTable(
      columns: const [
        DataColumn(label: Text('Athletes')),

      ],
     rows: _documents.map((document) {
  Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
  return DataRow(cells: [
    DataCell(Text(data?['firstName'])),
        ]);
      }).toList(),
    );
  }
}