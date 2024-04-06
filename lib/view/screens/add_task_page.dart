import 'package:flutter/material.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themedata = Theme.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Task",
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
                child: Container(
                  height: 48,
                  width: 250,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      "Add Task",
                      style: themedata.textTheme.displayMedium,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
