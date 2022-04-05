import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  final String id;
  final String photoUrl;
  final tags;
  final String text;
  final String title;
  final String author;
  final String authorId;
  final datePublished;
  final dateUpdated;

  Article({
    required this.id,
    required this.photoUrl,
    required this.tags,
    required this.author,
    required this.text,
    required this.title,
    required this.authorId,
    required this.datePublished,
    required this.dateUpdated,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "tags": tags,
        "author": author,
        "authorId": authorId,
        "id": id,
        "photoUrl": photoUrl,
        "text": text,
        "datePublished": datePublished,
        "dateUpdated": dateUpdated,
              
      };

  static Article fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Article(
      title: snapshot["title"],
      datePublished: snapshot["datePublished"],
      dateUpdated: snapshot["dateUpdated"],
      tags: snapshot["tags"],
      id: snapshot["id"],
      photoUrl: snapshot["photoUrl"],
      author: snapshot["author"],
      authorId: snapshot["authorId"],
      text: snapshot["text"],
    );
  }
}
