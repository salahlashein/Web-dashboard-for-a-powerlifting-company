import 'package:flutter/material.dart';
//import 'package:grad_project/pages/addexercise.dart';

class exercise extends StatelessWidget {
  const exercise({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[850],
              height: double.infinity,
              child: Stack(children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 60, horizontal: 25),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EXERCISE LIBRARY',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 7),
                          child: Text(
                            'Build and manage the master exercise library for your account so you can build training programs',
                            style: TextStyle(color: Colors.white54),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 200),
                          child: ElevatedButton.icon(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 3)),
                            onPressed: () {
                              showDialogWidget(context);
                            },
                            icon: Icon(
                              Icons.add_circle,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Add New Exercise",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered))
                                return Colors.green;
                              return Colors.white54;
                            }),
                          ),
                          child: Text(
                            'Squat   ',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered))
                                return Colors.green;
                              return Colors.white54;
                            }),
                          ),
                          child: Text(
                            'Bench   ',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered))
                                return Colors.green;
                              return Colors.white54;
                            }),
                          ),
                          child: Text(
                            'Deadlift  ',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered))
                                return Colors.green;
                              return Colors.white54;
                            }),
                          ),
                          child: Text(
                            'Accessories                                                                                                                   ',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                        Container(
                          // child: TextField(
                          //   decoration: InputDecoration(
                          //     hintText: 'Search Exercise',
                          //     prefixIcon: Icon(Icons.search,color: Colors.white,)

                          //   ),
                          // ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0),
                              color: Colors.grey[700],
                            ),
                            width: 200,
                            height: 30,
                            child: TextField(
                              obscureText: false,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search Exercise",
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 160, horizontal: 35),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        DataTable(columns: [
                          DataColumn(
                            label: Text(
                              "Exercise Name",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Video",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Instruction",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Primary muscle",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Secondary muscle",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Exercise type",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          DataColumn(
                              label: Text(
                            'Actions',
                            style: TextStyle(color: Colors.white),
                          )),
                        ], rows: [
                          DataRow(cells: [
                            DataCell(Text(
                              "Squat",
                              style: TextStyle(color: Colors.white),
                            )),
                            DataCell(Icon(
                              Icons.video_call_sharp,
                              color: Colors.green,
                            )),
                            DataCell(Icon(
                              Icons.check_circle,
                              color: Colors.white,
                            )),
                            DataCell(Text(
                              "Legs",
                              style: TextStyle(color: Colors.white),
                            )),
                            DataCell(Text(
                              "Glutes",
                              style: TextStyle(color: Colors.white),
                            )),
                            DataCell(Text(
                              "Strength",
                              style: TextStyle(color: Colors.white),
                            )),
                            DataCell(ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                'Edit',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blueAccent)),
                            )),
                          ]),
                          DataRow(cells: [
                            DataCell(Text(
                              "006 Tempo Squat",
                              style: TextStyle(color: Colors.white),
                            )),
                            DataCell(Text("")),
                            DataCell(Text("")),
                            DataCell(Text(
                              "Glutes",
                              style: TextStyle(color: Colors.white),
                            )),
                            DataCell(Text(
                              "legs",
                              style: TextStyle(color: Colors.white),
                            )),
                            DataCell(Text(
                              "Strength",
                              style: TextStyle(color: Colors.white),
                            )),
                            DataCell(ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                'Edit',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blueAccent)),
                            )),
                          ]),
                          DataRow(cells: [
                            DataCell(Text(
                              "2ct Pause",
                              style: TextStyle(color: Colors.white),
                            )),
                            DataCell(Icon(
                              Icons.video_call_sharp,
                              color: Colors.green,
                            )),
                            DataCell(Icon(
                              Icons.check_circle,
                              color: Colors.white,
                            )),
                            DataCell(Text(
                              "Legs",
                              style: TextStyle(color: Colors.white),
                            )),
                            DataCell(Text(
                              "Glutes",
                              style: TextStyle(color: Colors.white),
                            )),
                            DataCell(Text(
                              "Strength",
                              style: TextStyle(color: Colors.white),
                            )),
                            DataCell(ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                'Edit',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.blueAccent)),
                            )),
                          ]),
                        ]),
                      ],
                    ),
                  ),
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

showDialogWidget(BuildContext context) {
  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.grey[850],
    title: Text(
      'Add Variation Movement',
      style: TextStyle(color: Colors.green),
    ),
    content: Container(
      width: 450,
      height: 450,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Name',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(70),
              color: Colors.grey[850],
            ),
            width: 350,
            height: 40,
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter Exercise Name',
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Exercise Type',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Primary Muscle',
                style: TextStyle(color: Colors.white),
              ),
              Text(
                'Secondary Muscle',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(70),
                  color: Colors.grey[850],
                ),
                width: 190,
                height: 33,
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'None',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(70),
                  color: Colors.grey[850],
                ),
                width: 190,
                height: 33,
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'None',
                      hintStyle: TextStyle(color: Colors.white),
                      suffixIcon: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.keyboard_arrow_down))),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(70),
                  color: Colors.grey[850],
                ),
                width: 190,
                height: 33,
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'None',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'Exercise URL',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(70),
              color: Colors.green,
            ),
            width: 300,
            height: 40,
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'YouTube,etc.',
                  hintStyle: TextStyle(color: Colors.white),
                  suffixIcon: Icon(Icons.youtube_searched_for)),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            "Instructions",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  color: Colors.grey[850],
                ),
                width: 580,
                height: 130,
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter some information for your athletes',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    ),
    actions: [
      TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.red),
          )),
      SizedBox(
        width: 450,
      ),
      TextButton(
          onPressed: () {},
          child: Text(
            'Add',
            style: TextStyle(color: Colors.green),
          )),
    ],
  );
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}
