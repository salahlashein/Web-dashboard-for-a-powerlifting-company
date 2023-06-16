import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:web_dashboard/services/auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var _isObscured;
  final _auth = FirebaseAuth.instance;
  late String _email;
  late String _password;
  late String _confirmPassword;
  late String _firstName;
  late String _lastName;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _isObscured = true;
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    bool isSignedUp = await AuthService().isUserSignedUp(_email);
    if (isSignedUp) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Text('Sign Up Error'),
            content: Text('The email is already registered.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      await AuthService()
          .registerUser(_email, _password, _firstName, _lastName,);

      // Additional steps after successful sign-up
      // e.g., saving user data to database

      Navigator.pushNamed(context, '/Navbar');
    } catch (e) {
      print(e.toString());
      // Handle sign-up failure
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 150,
              ),
              Container(
                width: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 45,
                    ),
                    Image(
                      image: AssetImage('images/logo.png'),
                      height: 80,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: Text(
                        ' SIGN UP',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color.fromARGB(255, 48, 50, 51),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              onChanged: (value) {
                                _firstName = value;
                              },
                              decoration: InputDecoration(
                                labelText: "First Name",
                                labelStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Color(0xff45B39D),
                                  size: 20,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 32, 33, 34),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              onChanged: (value) {
                                _lastName = value;
                              },
                              decoration: InputDecoration(
                                labelText: "Last Name",
                                labelStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Color(0xff45B39D),
                                  size: 20,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 32, 33, 34),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onChanged: (value) {
                                _email = value;
                              },
                              decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Color(0xff45B39D),
                                  size: 20,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 32, 33, 34),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                } else if (!_isValidEmail(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Column(
                              children: [
                                TextFormField(
                                  obscureText: _isObscured,
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.visiblePassword,
                                  onChanged: (value) {
                                    _password = value;
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    labelStyle: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: _isObscured
                                          ? const Icon(
                                              Icons.visibility,
                                              color: Color(0xff45B39D),
                                            )
                                          : const Icon(
                                              Icons.visibility_off,
                                              color: Color(0xff45B39D),
                                            ),
                                      onPressed: () {
                                        setState(() {
                                          _isObscured = !_isObscured;
                                        });
                                      },
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Color(0xff45B39D),
                                      size: 20,
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(255, 32, 33, 34),
                                      ),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a password';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  obscureText: _isObscured,
                                  textInputAction: TextInputAction.done,
                                  keyboardType: TextInputType.visiblePassword,
                                  onChanged: (value) {
                                    _confirmPassword = value;
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please confirm your password';
                                    } else if (value != _password) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Confirm Password",
                                    labelStyle: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: _isObscured
                                          ? const Icon(
                                              Icons.visibility,
                                              color: Color(0xff45B39D),
                                            )
                                          : const Icon(
                                              Icons.visibility_off,
                                              color: Color(0xff45B39D),
                                            ),
                                      onPressed: () {
                                        setState(() {
                                          _isObscured = !_isObscured;
                                        });
                                      },
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Color(0xff45B39D),
                                      size: 20,
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(255, 32, 33, 34),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: _signUp,
                              style: ButtonStyle(
                                minimumSize:
                                    MaterialStateProperty.all(Size(380, 40)),
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xff45B39D)),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.all(10)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              child: Text(
                                "Sign Up",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Row(
                        children: [
                          SizedBox(
                            width: 90,
                          ),
                          Text(
                            'already have an account?',
                            style: TextStyle(color: Colors.grey),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Text(
                              ' Login',
                              style: TextStyle(color: Color(0xff45B39D)),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isValidEmail(String email) {
    // Use a regular expression to validate email format
    final pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }
}
