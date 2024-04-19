import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskforge/model/user_model.dart';
import 'package:taskforge/services/auth_services.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  UserModel _usermodel = UserModel();
  final AuthService _authService = AuthService();
  final _regKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _register(context) async {
    setState(() {
      _isLoading = true;
    });
    _usermodel = UserModel(
        email: _emailController.text,
        name: _nameController.text,
        password: _passwordController.text,
        status: 1,
        createdAt: DateTime.now());

    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(('name'), _usermodel.name!);

    try {
      await Future.delayed(const Duration(seconds: 3));
      final userdata = await _authService.registerUser(_usermodel);
      if (userdata != null) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _isLoading = false;
      });
      List err = e.toString().split("]");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(err[1])));
    }
  }

  @override
  Widget build(BuildContext context) {
    final themedata = Theme.of(context);
    return Scaffold(
        appBar: AppBar(),
        body: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            child: Stack(
              children: [
                Form(
                    key: _regKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Create an Account',
                          style: themedata.textTheme.displayMedium,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          style: themedata.textTheme.displaySmall,
                          controller: _nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "please enter your name";
                            }
                            return null;
                          },
                          cursorColor: Colors.teal,
                          decoration: InputDecoration(
                            hintText: "Enter your name",
                            hintStyle: themedata.textTheme.displaySmall,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
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
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
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
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                            onTap: () async {
                              try {
                                if (_regKey.currentState!.validate()) {
                                  _register(context);
                                }
                              } on FirebaseAuthException catch (e) {
                                String errorMessage = 'An error occurred';

                                if (e.code == 'user-not-found') {
                                  errorMessage =
                                      'No user found for that email.';
                                } else if (e.code == 'wrong-password') {
                                  errorMessage =
                                      'Wrong password provided for that user.';
                                } else {
                                  errorMessage =
                                      e.message ?? 'An error occurred';
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(errorMessage)));
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'An unexpected error occurred')));
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
                                    child: Text("Create Account",
                                        style: themedata
                                            .textTheme.displayMedium)))),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an Account?",
                              style: themedata.textTheme.displaySmall,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Login",
                                    style: themedata.textTheme.displayMedium))
                          ],
                        )
                      ],
                    )),
                Visibility(
                    visible: _isLoading,
                    child: const Center(child: CircularProgressIndicator()))
              ],
            )));
  }
}
