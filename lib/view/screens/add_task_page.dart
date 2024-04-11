import 'package:flutter/material.dart';
import 'package:taskforge/model/task_model.dart';
import 'package:taskforge/services/task_service.dart';
import 'package:uuid/uuid.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key, this.task});

  final TaskModel? task;

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  TaskService _taskService = TaskService();

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  bool _edit = false;
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  loadData() {
    if (widget.task != null) {
      setState(() {
        _titleController.text = widget.task!.title!;
        _descriptionController.text = widget.task!.body!;
        _edit = true;
      });
    }
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  final _taskKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final themedata = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: Form(
            key: _taskKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _edit == true
                    ? Text(
                        "Update Task",
                        style: themedata.textTheme.displayMedium,
                      )
                    : Text(
                        "Add New Task",
                        style: themedata.textTheme.displayMedium,
                      ),
                SizedBox(
                  height: 45,
                ),
                TextFormField(
                  style: themedata.textTheme.displaySmall,
                  controller: _titleController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Title is mandatory";
                    }
                    return null;
                  },
                  cursorColor: Colors.teal,
                  decoration: InputDecoration(
                    hintText: "Enter Task Title",
                    hintStyle: themedata.textTheme.displaySmall,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  style: themedata.textTheme.displaySmall,
                  controller: _descriptionController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Description is needed";
                    }
                    return null;
                  },
                  cursorColor: Colors.teal,
                  decoration: InputDecoration(
                    hintText: "Enter Task Description",
                    hintStyle: themedata.textTheme.displaySmall,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      if (_taskKey.currentState!.validate()) {
                        if (_edit) {
                          TaskModel _taskmodel = TaskModel(
                              id: widget.task?.id,
                              title: _titleController.text,
                              body: _descriptionController.text,status: widget.task?.status,createdAt: widget.task?.createdAt);

                          _taskService
                              .updateTasks(_taskmodel)
                              .then((value) => Navigator.pop(context));
                        } else {
                          _addTask();
                        }
                      }
                    },
                    child: Container(
                      height: 48,
                      width: 250,
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: _edit == true
                            ? Text(
                                "Update Task",
                                style: themedata.textTheme.displayMedium,
                              )
                            : Text(
                                "Add Task",
                                style: themedata.textTheme.displayMedium,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  _addTask() async {
    var id = Uuid().v1();

    TaskModel _taskModel = TaskModel(
        title: _titleController.text,
        body: _descriptionController.text,
        createdAt: DateTime.now(),
        id: id,
        status: 1);

    final task = await _taskService.createTask(_taskModel);

    if (task != null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Task Created')));
    }
  }
}
