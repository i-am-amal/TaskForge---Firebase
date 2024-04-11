import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String? id;
  String? title;
  String? body;
  int? status;
  DateTime? createdAt;

  TaskModel({
    this.body,
    this.createdAt,
    this.id,
    this.status,
    this.title,
  });

  factory TaskModel.fromJson(DocumentSnapshot json) {
    Timestamp? timestamp = json['createdAt'];
    return TaskModel(
        id: json['id'],
        title: json['title'],
        body: json['body'],
        createdAt: timestamp?.toDate(),
        status: json['status']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt,
      'body': body,
      'status': status,
    };
  }
}
