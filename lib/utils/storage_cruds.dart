import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

class FirebaseStorageCRUD {
  // upload file

  static Future uploadFile(photo) async {
    if (photo == null) return;
    final fileName = basename(photo!.path);
    final destination = 'files/';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('images/$fileName');
      await ref.putFile(photo);
    } catch (e) {
      print('error occured');
    }
  }

  //list files

  static Future<List<String>> ListFiles() async {
    final firebase_storage.ListResult storageRef = await firebase_storage
        .FirebaseStorage.instance
        .ref('files/')
        .child('images/')
        .listAll();

    final List<firebase_storage.Reference> allFiles = storageRef.items;

    final List<String> urls = await Future.wait(
      allFiles.map((firebase_storage.Reference ref) => ref.getDownloadURL()),
    );

    return urls;
  }
  //download file
  // delete file
}
