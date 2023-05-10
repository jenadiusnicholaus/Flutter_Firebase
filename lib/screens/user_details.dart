import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:x_app_a/screens/upload_files.dart';

class GetUserName extends StatelessWidget {
  final String? documentId;

  GetUserName({this.documentId});

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(
        title: const Text('User details'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ImageUploads()));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<DocumentSnapshot>(
          future: users.doc(documentId).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return SafeArea(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Full Name: ${data['full_name']}",
                    ),
                    Text("Company:  ${data['company']}"),
                    Text("Age:  ${data['company']}"),
                  ],
                ),
              ));
            }

            return Text("loading");
          },
        ),
      ),
    );
  }
}
