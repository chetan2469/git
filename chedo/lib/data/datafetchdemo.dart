
// import 'package:cloud_firestore/cloud_firestore.dart';
// class User {
//   final String name, email, phone, country;
//   DocumentReference reference;

//   User(this.name, this.email, this.phone, this.country, this.reference);
// }

// List<User> userList = [];

// fetchUserData() async {
//     setState(() {
//       userList.clear();
//     });

//     final QuerySnapshot result =
//         await FirebaseFirestore.instance.collection('kriyayog_user').get();

//     final List<DocumentSnapshot> documents = result.docs;
//     for (var data in documents) {
//       User u = User(
//           (data as dynamic)['name'],
//           (data as dynamic)['phone'],
//           (data as dynamic)['email'],
//           (data as dynamic)['country'],
          
// data.reference,
  //     userList.add(u);
  //   }
  // }