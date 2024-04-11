import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskforge/model/task_model.dart';
import 'package:taskforge/services/auth_services.dart';
import 'package:taskforge/services/task_service.dart';
import 'package:taskforge/view/screens/add_task_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TaskService _taskService = TaskService();

  @override
  Widget build(BuildContext context) {
    final themedata = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.pushNamed(context, '/addtask');
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Hi',
                      style: themedata.textTheme.displayMedium,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Amal',
                      style: themedata.textTheme.displayMedium,
                    )
                  ],
                ),
                CircleAvatar(
                  child: IconButton(
                      onPressed: () {
                        final user = FirebaseAuth.instance.currentUser;

                        AuthService().logout().then((value) =>
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/', (route) => false));
                      },
                      icon: Icon(Icons.logout_outlined)),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Your To-dos',
              style: themedata.textTheme.displayMedium,
            ),
            SizedBox(
              height: 20,
            ),

            StreamBuilder<List<TaskModel>>(
                stream: _taskService.getAllTasks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasData && snapshot.data!.length == 0) {
                    return Center(
                      child: Text(
                        'No task added',
                        style: themedata.textTheme.displaySmall,
                      ),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Some error occured',
                        style: themedata.textTheme.displaySmall,
                      ),
                    );
                  }

                  if (snapshot.hasData && snapshot.data!.length != 0) {
                    List<TaskModel> tasks = snapshot.data ?? [];

                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final _task = tasks[index];

                            return Card(
                              elevation: 5.0,
                              color: themedata.scaffoldBackgroundColor
                                  .withOpacity(0.8),
                              // color: themedata.scaffoldBackgroundColor,
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Icon(
                                    Icons.circle_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  '${_task.title}',
                                  style: themedata.textTheme.displaySmall,
                                ),
                                subtitle: Text(
                                  '${_task.body}',
                                  style: themedata.textTheme.displaySmall,
                                ),
                                trailing: Container(
                                  width: 100,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddTaskView(task: _task,)));
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.teal,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _taskService.deleteTask(_task.id);
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    );
                  }
                  return Center(
                    child: Text(
                      'unknown error occured',
                      style: themedata.textTheme.displaySmall,
                    ),
                  );
                })

            // Expanded(
            //   child: ListView.builder(
            //       itemCount: 5,
            //       itemBuilder: (context, index) {
            //         return Card(
            //           elevation: 5.0,
            //           color: themedata.scaffoldBackgroundColor.withOpacity(0.8),
            //           // color: themedata.scaffoldBackgroundColor,
            //           child: ListTile(
            //             leading: CircleAvatar(
            //               backgroundColor: Colors.transparent,
            //               child: Icon(
            //                 Icons.circle_outlined,
            //                 color: Colors.white,
            //               ),
            //             ),
            //             title: Text(
            //               'to do',
            //               style: themedata.textTheme.displaySmall,
            //             ),
            //             subtitle: Text(
            //               'this is a dummy text ',
            //               style: themedata.textTheme.displaySmall,
            //             ),
            //             trailing: Container(
            //               width: 100,
            //               child: Row(
            //                 children: [
            //                   IconButton(
            //                     onPressed: () {},
            //                     icon: Icon(
            //                       Icons.edit,
            //                       color: Colors.teal,
            //                     ),
            //                   ),
            //                   IconButton(
            //                     onPressed: () {},
            //                     icon: Icon(
            //                       Icons.delete,
            //                       color: Colors.red,
            //                     ),
            //                   )
            //                 ],
            //               ),
            //             ),
            //           ),
            //         );
            //       }),
            // )
          ],
        ),
      ),
    );
  }
}
