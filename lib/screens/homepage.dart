import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:x_app_a/utils/firestore_cruds.dart';
import 'package:x_app_a/screens/user_list.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 66, 38, 122),
              child: Center(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    customButton: const Icon(
                      Icons.more_vert,
                      color: Color.fromARGB(255, 230, 229, 233),
                    ),
                    items: [
                      ...MenuItems.firstItems.map(
                        (item) => DropdownMenuItem<MenuItem>(
                          value: item,
                          child: MenuItems.buildItem(item),
                        ),
                      ),
                      const DropdownMenuItem<Divider>(
                          enabled: false, child: Divider()),
                      ...MenuItems.secondItems.map(
                        (item) => DropdownMenuItem<MenuItem>(
                          value: item,
                          child: MenuItems.buildItem(item),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      MenuItems.onChanged(context, value as MenuItem);
                    },
                    dropdownStyleData: DropdownStyleData(
                      width: 160,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: const Color.fromARGB(255, 66, 38, 122),
                      ),
                      elevation: 8,
                      offset: const Offset(0, 8),
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      customHeights: [
                        ...List<double>.filled(MenuItems.firstItems.length, 48),
                        8,
                        ...List<double>.filled(
                            MenuItems.secondItems.length, 48),
                      ],
                      padding: const EdgeInsets.only(left: 16, right: 16),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
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
                  Row(
                    children: [
                      SizedBox(
                          child: TextButton(
                        style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused))
                              return const Color.fromARGB(255, 66, 38, 122);
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
                        child: const Text('Add'),
                      )),
                      SizedBox(
                          child: TextButton(
                        style: ButtonStyle(
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                            if (states.contains(MaterialState.focused))
                              return const Color.fromARGB(255, 66, 38, 122);
                            return null; // Defer to the widget's default.
                          }),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Users()));
                        },
                        child: const Text('user list'),
                      )),
                    ],
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

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [home, share, settings];
  static const List<MenuItem> secondItems = [logout];

  static const home = MenuItem(text: 'Home', icon: Icons.home);
  static const share = MenuItem(text: 'Share', icon: Icons.share);
  static const settings = MenuItem(text: 'Settings', icon: Icons.settings);
  static const logout = MenuItem(text: 'Log Out', icon: Icons.logout);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item) async {
    switch (item) {
      case MenuItems.home:
        //Do something
        break;
      case MenuItems.settings:
        //Do something
        break;
      case MenuItems.share:
        //Do something
        break;
      case MenuItems.logout:
        await FirebaseAuth.instance.signOut();
        break;
    }
  }
}
