class CollectionReferenceTo {
  //add entry
  static Future<void> addUser({fullName, company, age, users}) {
    // Call the user's CollectionReference to add a new user
    return users
        .add({
          'full_name': fullName, // John Doe
          'company': company, // Stokes and Sons
          'age': age // 42
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  //Read

  //Delete

  //Change
}
