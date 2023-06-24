import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_dashboard/models/Athlete.dart';
import 'models/userdata.dart';
import 'package:async/async.dart';

class Nutrition extends StatelessWidget {
  final Athlete athlete;
  Nutrition({required this.athlete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Nutrition'),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: // Modify the StreamBuilder to retrieve the steps data
            StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('nutritionData')
              .doc(athlete.id)
              .collection('data')
              .orderBy('date',
                  descending: false) // Order by date in descending order
              .limit(100)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            // Extract data from the snapshot
            List<Map<String, dynamic>> dataList = [];
            List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

            documents.forEach((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              String date = data['date'] ?? 'No date available';
              int protein = data['protein'] as int? ?? 0;
              int carbs = data['carbs'] as int? ?? 0;
              int fat = data['fat'] as int? ?? 0;
              int calories = (protein * 4) + (carbs * 4) + (fat * 9);

              dataList.add({
                'date': date,
                'protein': protein,
                'carbs': carbs,
                'fat': fat,
                'calories': calories,
              });
            });

            return ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> data = dataList[index];

                // Display data in a table
                return NutritionTable(
                  date: data['date'],
                  protein: data['protein'],
                  carbs: data['carbs'],
                  fat: data['fat'],
                  calories: data['calories'],
                );
              },
            );
          },
        ));
  }
}

class NutritionTable extends StatelessWidget {
  final String date;
  final int protein;
  final int carbs;
  final int fat;
  final int calories;

  const NutritionTable({
    Key? key,
    required this.date,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.calories,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      columnWidths: {
        0: FlexColumnWidth(1),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: Colors.green,
          ),
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Day',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Protein (g)',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Carbs (g)',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Fat (g)',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Calories',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(date),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(protein.toString()),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(carbs.toString()),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(fat.toString()),
              ),
            ),
            TableCell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(calories.toString()),
              ),
            ),
          ],
        ),
      ],
    );
  }
}