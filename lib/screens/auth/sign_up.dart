import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:x_app_a/screens/auth/sign_in.dart';

class SiginUp extends StatefulWidget {
  const SiginUp({super.key});

  @override
  State<SiginUp> createState() => _SiginUpState();
}

class _SiginUpState extends State<SiginUp> {
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
                  SizedBox(
                      child: TextButton(
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.resolveWith<Color?>(
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
                              .createUserWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('login now')),
                          );
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (constex) => const SiginIn()));
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'The password provided is too weak.')),
                            );
                          } else if (e.code == 'email-already-in-use') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'The account already exists for that email.')),
                            );
                          }
                        } catch (e) {
                          print(e);
                        }
                      }
                    },
                    child: const Text('SiginUp'),
                  )),
                ]),
          ),
        ),
      ),
    );
  }
}
