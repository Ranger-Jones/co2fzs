import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final String profImage;
  final String postUrl;
  final datePublished;
  final likes;

  const Post(
      {required this.username,
      required this.description,
      required this.postId,
      required this.postUrl,
      required this.uid,
      required this.datePublished,
      required this.likes,
      required this.profImage});

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "postId": postId,
        "description": description,
        "postUrl": postUrl,
        "likes": likes,
        "profImage": profImage,
        "datePublished": datePublished,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      username: snapshot["username"],
      postId: snapshot["postId"],
      description: snapshot["description"],
      postUrl: snapshot["postUrl"],
      likes: snapshot["likes"],
      profImage: snapshot["profImage"],
      uid: snapshot["uid"],
      datePublished: snapshot["datePublished"],
    );
  }
}
