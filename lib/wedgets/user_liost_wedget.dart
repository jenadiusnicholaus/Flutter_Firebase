import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:x_app_a/utils/firestore_cruds.dart';
import 'package:x_app_a/screens/user_details.dart';

userList() {
  return StreamBuilder<QuerySnapshot>(
      stream: CollectionReferenceTo.readUsers(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, index) {
              var data = snapshot.data?.docs;
              return ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GetUserName(
                            documentId: data?[index].id,
                          )));
                },
                title: Text(data?[index]['full_name']),
                subtitle: Text(data?[index]['company']),
              );
            },
          ),
        );
      });
}
