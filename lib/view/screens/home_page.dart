import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final TaskService _taskService = TaskService();
  String? name;

  getUserName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    name = pref.getString('name');
    setState(() {});
  }

  @override
  void initState() {
    getUserName();
    super.initState();
  }

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
        child: const Icon(Icons.add),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
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
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      name ?? 'User',
                      style: themedata.textTheme.displayMedium,
                    )
                  ],
                ),
                CircleAvatar(
                  child: IconButton(
                      onPressed: () {
                        SharedPreferences.getInstance().then((prefs) {
                          prefs.remove('token');
                          prefs.remove('name');
                          prefs.remove('email');
                          prefs.remove('uid');
                        });

                        // user.delete();

                        AuthService().logout().then((value) =>
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/', (route) => false));
                      },
                      icon: const Icon(Icons.logout_outlined)),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Your To-dos',
              style: themedata.textTheme.displayMedium,
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder<List<TaskModel>>(
                stream: _taskService
                    .getAllTasks(FirebaseAuth.instance.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasData && snapshot.data!.isEmpty) {
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

                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    List<TaskModel> tasks = snapshot.data ?? [];

                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];

                            return Card(
                              elevation: 5.0,
                              color: themedata.scaffoldBackgroundColor
                                  .withOpacity(0.8),
                              child: ListTile(
                                leading: const CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Icon(
                                    Icons.circle_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                                title: Text(
                                  '${task.title}',
                                  style: themedata.textTheme.displaySmall,
                                ),
                                subtitle: Text(
                                  '${task.body}',
                                  style: themedata.textTheme.displaySmall,
                                ),
                                trailing: SizedBox(
                                  width: 100,
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddTaskView(
                                                        task: task,
                                                      )));
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.teal,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          _taskService.deleteTask(
                                              task.id,
                                              FirebaseAuth
                                                  .instance.currentUser!.uid);
                                        },
                                        icon: const Icon(
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
          ],
        ),
      ),
    );
  }
}
