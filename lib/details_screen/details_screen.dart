import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web_dashboard/services/program_service.dart';
import 'package:web_dashboard/services/sets_service.dart';
import 'dart:js' as js;

import '../models/Day.dart';
import '../models/Program.dart';
import '../models/Workout.dart';
import '../models/block.dart';
import '../models/setExersice.dart';
import '../services/block_service.dart';
import '../services/day_service.dart';
import '../services/workout_service.dart';

Future<List<Workout>> getWorkout() async {
  try {
    User? user = FirebaseAuth.instance.currentUser;
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance
            .collection('workout')
            // .doc("f7f9c0a0-10b1-11ee-a2a8-23b6abbced55")
            .get();
    List<Workout> workout = snapshot.docs
        .map((e) => Workout.fromJson(e.data()))
        .where((element) => element.coachId == user!.uid)
        .toList();
    if (workout != null || workout.isNotEmpty) {
      return workout;
    } else {
      return [];
    }
  } catch (e) {
    print('Error get document: ${e.toString()}');
    return [];
  }
}

Future<List<setExersice>> getSet() async {
  try {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('sets').get();
    return snapshot.docs.map((e) => setExersice.fromJson(e.data())).toList();
  } catch (e) {
    print('Error get document: ${e.toString()}');
    return [];
  }
}

Future<List<Program>> getProgram() async {
  try {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('program').get();
    return snapshot.docs.map((e) => Program.fromJson(e.data())).toList();
  } catch (e) {
    print('Error get document: ${e.toString()}');
    return [];
  }
}

Future<List<Day>> getDay() async {
  try {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('day').get();
    return snapshot.docs.map((e) => Day.fromJson(e.data())).toList();
  } catch (e) {
    print('Error get document: ${e.toString()}');
    return [];
  }
}

Future<List<Block>> getBlock() async {
  try {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('block').get();
    return snapshot.docs.map((e) => Block.fromJson(e.data())).toList();
  } catch (e) {
    print('Error get document: ${e.toString()}');
    return [];
  }
}

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late List<Workout> workout;
  late List<setExersice> set;
  late List<Day> day;
  late List<Block> block;
  late List<Program> program;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  bool isLoading = false;
  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });
    try {
      workout = await getWorkout();
      set = await getSet();
      day = await getDay();
      block = await getBlock();
      program = await getProgram();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading coach name: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff181818),
      appBar: AppBar(
        title: const Text('Back'),
        backgroundColor: const Color(0xff181818),
        elevation: 0,
      ),
      body: isLoading == true
          ? Center(
              child: CircularProgressIndicator(
              color: Color(0xff5bc500),
            ))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: workout.isEmpty
                  ? Center(
                      child: Column(
                        children: [
                          Text(
                            'No workouts added yet!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color(0xff5bc500))),
                              child: Text(
                                'Add Workout',
                                style: TextStyle(
                                  color: Colors.white,
                                  // fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                ),
                              ))
                        ],
                      ),
                    )
                  : ListView(
                      children: [
                        ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Wrap(
                                children: [
                                  Text(
                                    'Workout ${index + 1}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 15),
                                  Container(
                                    padding: const EdgeInsets.all(12.0),
                                    color: const Color(0xff454545),
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        itemBuilder: (context, indexx) {
                                          return workOutItem(context,
                                              workout[index].data![indexx]);
                                        },
                                        separatorBuilder: (context, index) =>
                                            const Divider(),
                                        itemCount: workout[index].data!.length),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 15),
                            itemCount: workout.length),
                      ],
                    ),
            ),
    );
  }

  Widget workOutItem(context, setExersice model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.chat,
                color: Colors.deepPurple[800],
                size: 18,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(model.notes!),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xff5bc500))),
                  padding: const EdgeInsets.all(5),
                  child: const Text('A')),
              const SizedBox(width: 5),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                color: Colors.grey.shade700,
                child: const Text('Squat',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // const SizedBox(
              //   width: 5,
              // ),
              customNumber(context, title: 'Sets', value: '2'),
              customNumber(context, title: 'Reps', value: model.reps),
              customNumber(context, title: 'RPE', value: model.RPE),
              customNumber(context, title: 'Load', value: '${model.load}kg'),
              customNumber(context,
                  title: 'Intensty', value: '${model.intensity}%'),
              Expanded(
                flex: 2,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Link',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          js.context.callMethod('open', [model.link]);
                        },
                        child: Text(
                          model.link!,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 10,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              // const SizedBox(
              //   width: 150,
              // ),
            ],
          ),
        ],
      );

  Widget customNumber(context, {required title, required value}) => Expanded(
        flex: 2,
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              value,
              style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 10,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
}
