// TODO Implement this library.
import 'package:country_list_pick/country_list_pick.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_dashboard/models/userdata.dart';
import 'package:web_dashboard/setting_screen/setting.dart';

import '../services/userservice.dart';
import 'dart:html' as html;

class ManageBilling extends StatefulWidget {
  final List<ManageBillingModel> manageBillingModel;
  const ManageBilling({super.key, required this.manageBillingModel});

  @override
  State<ManageBilling> createState() => _ManageBillingState();
}

class _ManageBillingState extends State<ManageBilling> {
  late TextEditingController manageBillingController;
  late TextEditingController addressLineOneController;
  late TextEditingController addressLineTwoController;

  late TextEditingController cityController;
  late TextEditingController stateController;
  late TextEditingController postalCodeController;
  var formKey = GlobalKey<FormState>();
  @override
  void initState() {
    manageBillingController =
        TextEditingController(text: widget.manageBillingModel[0].cardNum);
    addressLineOneController =
        TextEditingController(text: widget.manageBillingModel[0].address1);
    addressLineTwoController =
        TextEditingController(text: widget.manageBillingModel[0].address2);
    cityController =
        TextEditingController(text: widget.manageBillingModel[0].city);
    stateController =
        TextEditingController(text: widget.manageBillingModel[0].country);
    postalCodeController =
        TextEditingController(text: widget.manageBillingModel[0].postalNum);
    super.initState();
  }

  Future<void> _updateManageBilling() async {
    var address1 = addressLineOneController.text;
    var address2 = addressLineTwoController.text;
    var cardNum = manageBillingController.text;
    var city = cityController.text;
    var country = stateController.text;
    var postalNum = postalCodeController.text;
    setState(() {
      isLoadingUpdate = true;
    });
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await UserService().updateCoachManageBilling(
            coachId: user.uid,
            manageId: widget.manageBillingModel[0].id,
            address1: address1,
            address2: address2,
            cardNum: cardNum,
            city: city,
            country: country,
            postalNum: postalNum);
        setState(() {
          isLoadingUpdate = false;
          Get.snackbar('Updated', 'Update Successfull');
        });
      }
    } catch (e) {
      print('Error loading coach name: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: const Color(0xff454545),
          borderRadius: BorderRadius.circular(20)),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Credit card information"),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 55,
                  child: TextFormField(
                    controller: manageBillingController,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please, fill out this field !';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.credit_card, color: Colors.white),
                      hintText: "**** **** **** 5021",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xff5bc500),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text("Billing Address"),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 55,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please, fill out this field !';
                      }
                      return null;
                    },
                    controller: addressLineOneController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Address Line One",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                        borderSide: const BorderSide(
                          color: Color(0xff5bc500),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text("Billing Address"),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 55,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please, fill out this field !';
                      }
                      return null;
                    },
                    controller: addressLineTwoController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Address Line Two",
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                        borderSide: const BorderSide(
                          color: Color(0xff5bc500),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(3),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 55,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please, fill out this field !';
                            }
                            return null;
                          },
                          controller: cityController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "City",
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: const BorderSide(
                                color: Color(0xff5bc500),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 55,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please, fill out this field !';
                            }
                            return null;
                          },
                          controller: stateController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Country",
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: const BorderSide(
                                color: Color(0xff5bc500),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 55,
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please, fill out this field !';
                            }
                            return null;
                          },
                          controller: postalCodeController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: "Postal Code",
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: const BorderSide(
                                color: Color(0xff5bc500),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(3),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                const SizedBox(height: 25),
                isLoadingUpdate == true
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            _updateManageBilling().then((value) {
                              html.window.location.reload();
                            });
                          } else {
                            Get.snackbar('Error', 'Something went wrong !');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          maximumSize: const Size(150.0, 70.0),
                          backgroundColor: const Color(0xff5bc500),
                        ),
                        child: const Text(
                          'Save Change',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
