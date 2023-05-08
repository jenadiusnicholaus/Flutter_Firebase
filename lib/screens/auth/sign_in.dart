import 'package:flutter/material.dart';
import 'package:x_app_a/screens/auth/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:x_app_a/screens/homepage.dart';
import 'package:x_app_a/core/local_storage/prfs.dart';

class SiginIn extends StatefulWidget {
  const SiginIn({super.key});

  @override
  State<SiginIn> createState() => _SiginInState();
}

class _SiginInState extends State<SiginIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(hintText: 'Email'),
                    // The validator receives the text that the user has entered.
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(hintText: 'Password'),
                    // The validator receives the text that the user has entered.
                  ),
                  Row(
                    children: [
                      SizedBox(
                          child: TextButton(
                        style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused))
                              return Colors.red;
                            return null; // Defer to the widget's default.
                          }),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              final credential = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('authenticating user...')),
                              );

                              AppLocalStorage.addToPref(
                                  'token', '${credential.credential?.token}');

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyHomePage(
                                          title: '${credential.user?.email}')));
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'No user found for that email.')),
                                );
                              } else if (e.code == 'wrong-password') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Wrong password provided for that user.')),
                                );
                              }
                            }
                          }
                        },
                        child: const Text('SiginIn'),
                      )),
                      SizedBox(
                          child: TextButton(
                        style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused))
                              return Colors.red;
                            return null; // Defer to the widget's default.
                          }),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SiginUp()));
                        },
                        child: const Text(
                            'You don\'t have an account? ccreate one'),
                      )),
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
