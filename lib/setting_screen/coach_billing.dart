import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:web_dashboard/models/userdata.dart';

class CoachBilling extends StatefulWidget {
  final List<CoachBillingModel> coachBillingModel;
  const CoachBilling({super.key, required this.coachBillingModel});

  @override
  State<CoachBilling> createState() => _CoachBillingState();
}

class _CoachBillingState extends State<CoachBilling> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: const Color(0xff454545),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Coach Billing",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: const [
                Expanded(
                  child: Text(
                    "Athlete",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "Total Days",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) => Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.coachBillingModel[index].athlete,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.coachBillingModel[index].email,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.coachBillingModel[index].totlaDays,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              separatorBuilder: (context, index) => SizedBox(height: 15),
              itemCount: widget.coachBillingModel.length,
            ),
          ),
        ],
      ),
    );
  }
}
