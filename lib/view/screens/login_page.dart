import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskforge/model/user_model.dart';
import 'package:taskforge/services/auth_services.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _loginKey = GlobalKey<FormState>();

  UserModel _usermodel = UserModel();
  AuthService _authService = AuthService();
  bool _isLoading = false;

  void _login() async {
    //2.22.00 time line   //31/03
    setState(() {
      _isLoading = true;
    });

    try {
      _usermodel = UserModel(
          email: _emailController.text, password: _passwordController.text);

      final data = await _authService.loginUser(_usermodel);

      if (data != null) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }

      ///
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });

      List err = e.toString().split("]");

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err[1])));
    }

    ///
  }

  @override
  Widget build(BuildContext context) {
    final themedata = Theme.of(context);
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Stack(
          children: [
            Form(
              key: _loginKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Login to your Account',
                    style: themedata.textTheme.displayMedium,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    style: themedata.textTheme.displaySmall,
                    controller: _emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter an Email Id";
                      }
                      return null;
                    },
                    cursorColor: Colors.teal,
                    decoration: InputDecoration(
                      hintText: "Enter Email",
                      hintStyle: themedata.textTheme.displaySmall,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    style: themedata.textTheme.displaySmall,
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password is mandatory";
                      }
                      return null;
                    },
                    cursorColor: Colors.teal,
                    decoration: InputDecoration(
                      hintText: "Enter Password",
                      hintStyle: themedata.textTheme.displaySmall,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () async {
                      if (_loginKey.currentState!.validate()) {


                        
                        UserCredential userdata = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim());

                        if (userdata != null) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/home', (route) => false);
                        }
                      }
                    },
                    child: Container(
                      height: 48,
                      width: 250,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          "Login",
                          style: themedata.textTheme.displayMedium,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an Account?",
                        style: themedata.textTheme.displaySmall,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          "Create Now",
                          style: themedata.textTheme.displayMedium,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Visibility(
                visible: _isLoading,
                child: Center(
                  child: CircularProgressIndicator(),
                ))
          ],
        ),
      ),
    );
  }
}
