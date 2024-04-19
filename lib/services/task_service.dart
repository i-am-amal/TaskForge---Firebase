import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taskforge/model/task_model.dart';

class TaskService {
  final CollectionReference _taskCollection =
      FirebaseFirestore.instance.collection('tasks');

//create task
  // Future<TaskModel?> createTask(TaskModel task) async {
  //   try {
  //     final taskMap = task.toMap();
  //     await _taskCollection.doc(task.id).set(taskMap);
  //     return task;
  //   } on FirebaseException catch (e) {
  //     throw(e.toString());
  //   }
  // }
  Future<TaskModel?> createTask(TaskModel task, String userId) async {
    try {
      final taskMap = task.toMap();
      await _taskCollection
          .doc(userId)
          .collection('user_tasks')
          .doc(task.id)
          .set(taskMap);
      return task;
    } on FirebaseException catch (e) {
      throw (e.toString());
    }
  }

//get all tasks
  // Stream<List<TaskModel>> getAllTasks() {
  //   try {
  //     return _taskCollection.snapshots().map((QuerySnapshot snapshot) {
  //       return snapshot.docs.map((DocumentSnapshot doc) {
  //         return TaskModel.fromJson(doc);
  //       }).toList();
  //     });
  //   } on FirebaseException catch (e) {
  //     throw(e.toString());
  //   }
  // }
  Stream<List<TaskModel>> getAllTasks(String userId) {
    try {
      return _taskCollection
          .doc(userId)
          .collection('user_tasks')
          .snapshots()
          .map((QuerySnapshot snapshot) {
        return snapshot.docs.map((DocumentSnapshot doc) {
          return TaskModel.fromJson(doc);
        }).toList();
      });
    } on FirebaseException catch (e) {
      throw (e.toString());
    }
  }

//update tasks
  Future<void> updateTasks(TaskModel task, String userId) async {
    try {
      final taskMap = task.toMap();

      // await _taskCollection.doc(task.id).update(taskMap);
      await _taskCollection
          .doc(userId)
          .collection('user_tasks')
          .doc(task.id)
          .update(taskMap);
    } on FirebaseException catch (e) {
      throw (e.toString());
    }
  }

//delete tasks
  Future<void> deleteTask(String? id, String userId) async {
    try {
      // await _taskCollection.doc(id).delete();
      await _taskCollection
          .doc(userId)
          .collection('user_tasks')
          .doc(id)
          .delete();
    } on FirebaseException catch (e) {
      throw (e.toString());
    }
  }
}
