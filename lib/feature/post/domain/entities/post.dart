import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uat_project/feature/post/domain/entities/post_location.dart';

class Post {
  final String id;
  final String userId;
  final String userName;
  final String text;
  final String imageUrl;
  final DateTime timeStamp;
  final PostLocation? location;
  final List<String> likes;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.text,
    required this.imageUrl,
    required this.timeStamp,
    required this.location, required this.likes,
  });

  Post copyWith({String? imageUrl, String? text}) {
    return Post(
      id: id,
      userId: userId,
      userName: userName,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      timeStamp: timeStamp,
      location: location ?? this.location,
      likes: likes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': userName,
      'text': text,
      'imageUrl': imageUrl,
      'timeStamp': Timestamp.fromDate(timeStamp),
      'location': location?.toJson(),
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userId'],
      userName: json['name'],
      text: json['text'],
      imageUrl: json['imageUrl'],
      timeStamp: (json['timeStamp'] as Timestamp).toDate(),
      location: json['location'] != null
          ? PostLocation.fromJson(json['location'])
          : null,
      likes: List<String>.from(json['likes'] ?? [])
    );
  }
}
