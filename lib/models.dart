import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class IdeaType {
  final String name;
  final DocumentReference reference;
  final List<Idea> ideas;

  IdeaType.fromMap(
      Map<String, dynamic> map, List<DocumentSnapshot> ideasSnapshots,
      {this.reference})
      : assert(map['name'] != null),
        //assert(map['votes'] != null),
        name = map['name'],
        ideas = ideasSnapshots.map((idea) => Idea.fromSnapshot(idea)).toList();
  //votes = map['votes'];

  IdeaType.fromSnapshot(
      DocumentSnapshot snapshot, List<DocumentSnapshot> ideasSnapshots)
      : this.fromMap(snapshot.data, ideasSnapshots,
            reference: snapshot.reference);

  @override
  String toString() => "IdeaType<$name:$name>";
}

class Idea {
  final String _description;
  final DocumentReference reference;
  final String _image_slug;

  String get description => _description;
  Image get image => Image.asset("assets/images/$_image_slug");

  Idea.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['field_1576669235972'] != null),
        _description = map['field_1576669235972'],
        _image_slug = map['image'];

  Idea.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Idea<description:$_description>";
}
