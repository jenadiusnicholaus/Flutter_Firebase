import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class FirebaseStorageCRUD {
  // upload file

  static Future uploadFile(photo) async {
    if (photo == null) return;
    final fileName = basename(photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('file/');
      await ref.putFile(photo!);
    } catch (e) {
      print('error occured');
    }
  }

  //list files

  static ListFiles() async {
    final storageRef =
        firebase_storage.FirebaseStorage.instance.ref().child("files/uid");
    final listResult = await storageRef.listAll();

    return listResult.items;
  }
  //download file
  // delete file
}
