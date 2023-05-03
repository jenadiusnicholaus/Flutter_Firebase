import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:x_app_a/utils/firestore_cruds.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              child: Form(
                key: _formKey,
                child: Column(children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(hintText: 'Name'),
                    // The validator receives the text that the user has entered.
                  ),
                  TextFormField(
                    controller: _companyController,
                    decoration: const InputDecoration(hintText: 'Company'),
                    // The validator receives the text that the user has entered.
                  ),
                  TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(hintText: 'Age'),
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        CollectionReferenceTo.addUser(
                            fullName: _nameController.text,
                            company: _companyController.text,
                            age: _ageController.text,
                            users: users);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                      }
                    },
                    child: Text('Add'),
                  )

                      // IconButton(
                      //     color: Colors.blue,
                      //     icon: const Icon(Icons.add),
                      //     onPressed: () => () {
                      //           // if (_formKey.currentState!.validate()) {
                      //           CollectionReferenceTo.addUser(
                      //               fullName: _nameController.text,
                      //               company: _companyController.text,
                      //               age: _ageController.text,
                      //               users: users);

                      //           ScaffoldMessenger.of(context).showSnackBar(
                      //             const SnackBar(
                      //                 content: Text('Processing Data')),
                      //           );
                      //           return true;
                      //         }
                      //     // ScaffoldMessenger.of(context).showSnackBar(
                      //     //   const SnackBar(content: Text('form not valide')),
                      //     // );
                      //     // return false;
                      //     // },
                      //     ),
                      )
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
