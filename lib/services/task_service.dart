import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskforge/model/task_model.dart';

class TaskService {
  final CollectionReference _taskCollection =
      FirebaseFirestore.instance.collection('tasks');

  Future<TaskModel?> createTask(TaskModel task) async {
    try {
      final taskMap = task.toMap();
      await _taskCollection.doc(task.id).set(taskMap);

      return task;
    } on FirebaseException catch (e) {
      print(e.toString());
    }
  }

  Stream<List<TaskModel>> getAllTasks() {
    try {
      return _taskCollection.snapshots().map((QuerySnapshot snapshot) {
        return snapshot.docs.map((DocumentSnapshot doc) {
          return TaskModel.fromJson(doc);
        }).toList();
      });
    } on FirebaseException catch (e) {
      print(e.toString());
      throw (e);
    }
  }

  Future<void> updateTasks(TaskModel task) async {
    try {
      final taskMap = task.toMap();

      await _taskCollection.doc(task.id).update(taskMap);
    } on FirebaseException catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteTask(String? id) async {
    try {
      await _taskCollection.doc(id).delete();
    } on FirebaseException catch (e) {
      print(e.toString());
    }
  }
}
