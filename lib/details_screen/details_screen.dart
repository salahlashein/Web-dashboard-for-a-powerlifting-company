import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Back'),
        backgroundColor: const Color(0xff181818),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Workout 1',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.all(12.0),
              color: const Color(0xff454545),
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => workOutItem(context, index),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: 4),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Workout 2',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.all(12.0),
              color: const Color(0xff454545),
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => workOutItem(context, index),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: 4),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Workout 3',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              padding: const EdgeInsets.all(12.0),
              color: const Color(0xff454545),
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) => workOutItem(context, index),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: 4),
            ),
          ],
        ),
      ),
    );
  }

  Widget workOutItem(context, index) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (index != 0)
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
                const Text('Work up to 75% and perform 2 sets of 6-8 @8'),
              ],
            ),
          if (index != 0)
            const SizedBox(
              height: 20,
            ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xff5bc500))),
                padding: const EdgeInsets.all(5),
                child: const Text('A'),
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                color: Colors.grey.shade700,
                child: const Text(
                  'Squat',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 5,
              ),
              customNumber(context, title: 'Sets', value: '1'),
              customNumber(context, title: 'Reps', value: '7'),
              customNumber(context, title: 'RPE', value: '8'),
              customNumber(context, title: 'Load', value: '170 kg'),
              customNumber(context, title: 'Intensty', value: '75%'),
              const SizedBox(
                width: 150,
              ),
            ],
          ),
        ],
      );

  Widget customNumber(context, {required title, required value}) => Column(
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
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
      );
}
