import 'package:cloud_firestore/cloud_firestore.dart';

class IdeaType {
  final String name;
  final String slug;
  final int votes;
  final DocumentReference reference;

  IdeaType.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['slug'] != null),
        assert(map['votes'] != null),
        name = map['name'],
        slug = map['slug'],
        votes = map['votes'];

  IdeaType.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "IdeaType<$name:$votes>";
}


class Idea {
  final String _description;
  final DocumentReference reference;

  String get description => _description;

  Idea.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['description'] != null),
        _description = map['description'];

  Idea.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Idea<description:$_description>";
}