import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/my_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  late final String? uid;
  DatabaseService({this.uid});

  // reference to a collection is needed
  final CollectionReference helper = FirebaseFirestore.instance.collection(
      "brews"); // we want to store data which tells us the brew preferences of each person

  Future updateUserData(String sugars, String name, int strength) async {
    helper.doc(uid).set({
      'sugar': sugars,
      'name': name,
      'strength': strength,
    });
  }

  // a stream to let us know whenever data changes in the document. It will supply us a snapshot of the collection.
  // we will take out the data we need from the snapshot.

  // a function to convert querysnapshots to brew objects

  List<Brew> _brewListFromQuerySnapshot(QuerySnapshot? snapshot) {
    return snapshot!.docs.map((doc) {
      return Brew(
          name: doc.get("name") ?? "",
          strength: doc.get("strength") ?? 0,
          sugars: doc.get("sugar") ?? "0");
    }).toList();
  }

  Stream<List<Brew>> get snaps {
    return helper.snapshots().map(_brewListFromQuerySnapshot);
  }

  // a function to convert document snapshots to a more convenient model
  UserData _userDataFromDocumentSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.get("name"),
        sugars: snapshot.get("sugar"),
        strength: snapshot.get("strength"));
  }

  // stream which will give us the changes occuring in a particular user document
  // (lists the data inside a particular document of a user)
  Stream<UserData> get individualSnaps {
    return helper.doc(uid).snapshots().map(_userDataFromDocumentSnapshot);
  }
}
