import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'action.dart';

class Idea {
  final DocumentReference reference;
  final DocumentReference action;
  final String _description;
  final String _imageSlug;
  final String userUid;
  final bool isValidated;

  String get description => _description;
  Image get image => Image.asset(
        "assets/images/$_imageSlug.png",
        fit: BoxFit.fitHeight,
      );
  Image get imageDecorated => Image.asset(
        "assets/images/$_imageSlug-decorated.png",
        fit: BoxFit.fitHeight,
      );

  Idea.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['description'] != null),
        userUid = map['userUid'],
        isValidated = map['isValidated'],
        _description = map['description'],
        action = map['action'],
        _imageSlug = map['imageSlug'];

  Idea.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  String toString() => "Idea<description:$_description>";
}

//class UserIdea {
//  final DocumentReference reference;
//  final DocumentReference idea;
//  final String userUid;
//
//  UserIdea.fromMap(Map<String, dynamic> map, {this.reference})
//      : assert(map['idea'] != null),
//        assert(map['idea'] != userUid),
//        userUid = map['userUid'],
//        idea = map['idea'];
//
//  UserIdea.fromSnapshot(DocumentSnapshot snapshot)
//      : this.fromMap(snapshot.data, reference: snapshot.reference);
//
//  @override
//  String toString() => "Idea<description:$idea>";
//}

//class UserIdeaRepository {
//  final CollectionReference collection =
//      Firestore.instance.collection('userIdeas');
//
//  Future<List<Idea>> getIdeas(CreativeAction action) async {
//    final user = await Auth().getCurrentUser();
//    QuerySnapshot qShot = await collection
//        .where('action', isEqualTo: action.reference)
//        .getDocuments();
//
//    List<Idea> temp =
//        qShot.documents.map((data) => Idea.fromSnapshot(data)).toList();
//
//    return temp
//        .where((element) =>
//            element.isValidated ||
//            element.userUid == null ||
//            element.userUid == user.uid)
//        .toList();
//  }
//}

class IdeaRepository {
  final CollectionReference collection = Firestore.instance.collection('ideas');

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<List<Idea>> getIdeas(CreativeAction action) async {
    final user = await Auth().getCurrentUser();
    QuerySnapshot qShot = await collection
        .where('action', isEqualTo: action.reference)
        .getDocuments();

    List<Idea> temp =
        qShot.documents.map((data) => Idea.fromSnapshot(data)).toList();
    temp.shuffle();
    return temp
        .where((element) =>
            element.isValidated ||
            element.userUid == null ||
            element.userUid == user.uid)
        .toList();
  }

  Future<DocumentReference> createRecord(
      String text, CreativeAction action) async {
    final user = await Auth().getCurrentUser();
    Future<DocumentReference> idea = collection.add({
      'description': text,
      'imageSlug': "speakers",
      'action': action.reference,
      'isValidated': false,
      'userUid': user == null ? 'anonymous' : user.uid,
    });
    return idea;
  }
}
