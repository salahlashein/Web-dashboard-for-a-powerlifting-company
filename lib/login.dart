import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _isObscured = true;
  final _auth = FirebaseAuth.instance;
  late String _email;
  late String _password;
  final _formKey = GlobalKey<FormState>();
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _isObscured = true;
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      if (userCredential.user != null) {
        Navigator.pushNamed(context, '/Navbar');
        print("Login successful");
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          setState(() {
            _errorMessage =
                'Invalid email. Please enter a valid email address.';
          });
        } else if (e.code == 'wrong-password') {
          setState(() {
            _errorMessage =
                'Invalid password. Please enter the correct password.';
          });
        } else {
          setState(() {
            _errorMessage = 'An error occurred. Please try again later.';
          });
        }
      } else {
        print(e);
      }
    }
  }

  bool _isValidEmail(String email) {
    final pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    final regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 150),
              Container(
                width: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 80),
                    Image(
                      image: AssetImage('images/logo.png'),
                      height: 80,
                    ),
                    SizedBox(height: 40),
                    Center(
                      child: Text(
                        ' SIGN IN',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
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
                            SizedBox(height: 5),
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
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            if (_errorMessage.isNotEmpty)
                              Text(
                                _errorMessage,
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _signIn,
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
                                "Login",
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            SizedBox(height: 15),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/forgetpass');
                              },
                              child: Text(
                                'Forget Password',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Not yet a member?',
                          style: TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/SignUp');
                          },
                          child: Text(
                            '  Sign Up',
                            style: TextStyle(
                              color: Color(0xff45B39D),
                            ),
                          ),
                        )
                      ],
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
