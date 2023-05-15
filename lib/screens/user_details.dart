import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:x_app_a/screens/upload_files.dart';
import 'package:x_app_a/utils/storage_cruds.dart';

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
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 2,
          child: FutureBuilder<DocumentSnapshot>(
            future: users.doc(documentId).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return const Text("Document does not exist");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        color: Color.fromARGB(255, 199, 194, 199),
                        child: Column(children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              child: Icon(
                                Icons.person,
                                size: 60,
                              ),
                              radius: 50,
                            ),
                          ),
                          Text(
                            "Full Name: ${data['full_name']}",
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Company:  ${data['company']}",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Text("Age:  ${data['age']} years old"),
                        ]),
                      ),
                      Container(
                        width: 300,
                        child: FutureBuilder<List<String>>(
                          future: FirebaseStorageCRUD
                              .ListFiles(), // a previously-obtained Future<String> or null
                          builder: (BuildContext context,
                              AsyncSnapshot<List<String>> snapshot) {
                            List<Widget> children;
                            if (snapshot.hasData) {
                              children = <Widget>[
                                const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.green,
                                  size: 60,
                                ),
                                Container(
                                    height: 900,
                                    width: MediaQuery.of(context).size.width,
                                    child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data?.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2),
                                            child: Image(
                                              image: NetworkImage(snapshot
                                                  .data![index]
                                                  .toString()),
                                            ),
                                          );
                                        })),
                              ];
                            } else if (snapshot.hasError) {
                              children = <Widget>[
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 60,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text('Error: ${snapshot.error}'),
                                ),
                              ];
                            } else {
                              children = const <Widget>[
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: CircularProgressIndicator(),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: Text('Awaiting result...'),
                                ),
                              ];
                            }
                            return Column(
                              children: children,
                            );
                          },
                        ),

                        // CustomScrollView(
                        //   primary: false,
                        //   slivers: <Widget>[
                        //     SliverPadding(
                        //       padding: const EdgeInsets.all(20),
                        //       sliver: SliverGrid.count(
                        //         crossAxisSpacing: 10,
                        //         mainAxisSpacing: 10,
                        //         crossAxisCount: 2,
                        //         children: <Widget>[
                        //           Container(
                        //             padding: const EdgeInsets.all(8),
                        //             color: Colors.green[100],
                        //             child: const Text(
                        //                 "He'd have you all unravel at the"),
                        //           ),
                        //           Container(
                        //             padding: const EdgeInsets.all(8),
                        //             color: Colors.green[200],
                        //             child: const Text('Heed not the rabble'),
                        //           ),
                        //           Container(
                        //             padding: const EdgeInsets.all(8),
                        //             color: Colors.green[300],
                        //             child: const Text(
                        //                 'Sound of screams but the'),
                        //           ),
                        //           Container(
                        //             padding: const EdgeInsets.all(8),
                        //             color: Colors.green[400],
                        //             child: const Text('Who scream'),
                        //           ),
                        //           Container(
                        //             padding: const EdgeInsets.all(8),
                        //             color: Colors.green[500],
                        //             child:
                        //                 const Text('Revolution is coming...'),
                        //           ),
                        //           Container(
                        //             padding: const EdgeInsets.all(8),
                        //             color: Colors.green[600],
                        //             child: const Text('Revolution, they...'),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ],
                        // )
                      ),
                    ],
                  ),
                );
              }

              return Text("loading");
            },
          ),
        ),
      ),
    );
  }
}
