import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'idea.dart';

class Favorite {
  DocumentReference reference;
  DocumentReference idea;
  String description;
  String userUid;

  Favorite.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['idea'] != null),
        assert(map['description'] != null),
        description = map['description'],
        idea = map['idea'];

  Favorite.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  Future<Idea> getIdea() async {
    return Idea.fromSnapshot(await idea.get());
  }

  Future<Image> getImage() async {
    final idea = await getIdea();
    return idea.image;
  }
}

class FavoriteRepository {
  final Auth _auth = Auth();
  final CollectionReference collection =
      Firestore.instance.collection('favorites');

  void addFavorite(String description, [DocumentReference idea]) async {
    FirebaseUser _user = await _auth.getCurrentUser();
    collection.add({
      'description': description,
      'idea': idea == null ? '' : idea,
      'userUid': _user == null ? 'anonymous' : _user.uid
    });
  }

  Future<void> removeFavorite(Favorite favorite) async {
    return collection.document(favorite.reference.documentID).delete();
  }

  Future<QuerySnapshot> getFavorites() async {
    print("getFavorites");
    FirebaseUser _user = await _auth.getCurrentUser();
    if (_user == null) {
      return null;
    }
    return collection.where('userUid', isEqualTo: _user.uid).getDocuments();
  }

  Future<void> removeFavorites() async {
    FirebaseUser _user = await _auth.getCurrentUser();
    if (_user == null) {
      return null;
    }
    return collection
        .where('userUid', isEqualTo: _user.uid)
        .getDocuments()
        .then((snapshot) => snapshot.documents
            .forEach((document) => document.reference.delete()));
  }
}
