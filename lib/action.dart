import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreativeAction {
  final DocumentReference reference;
  final String name;
  final String _imageSlug;

  CreativeAction.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        name = map['name'],
        _imageSlug = map['imageSlug'];

  CreativeAction.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  Image get image => Image.asset(
        "assets/images/$_imageSlug.png",
        fit: BoxFit.fitHeight,
      );

  @override
  String toString() => "Action<$name>";
}

class ActionRepository {
  final CollectionReference collection =
      Firestore.instance.collection('actions');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<List<CreativeAction>> getActions() async {
    QuerySnapshot qShot =
        await collection.orderBy('name', descending: false).getDocuments();
    print(qShot);
    return qShot.documents
        .map((data) => CreativeAction.fromSnapshot(data))
        .toList();
  }
}
