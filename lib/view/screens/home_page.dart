import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:taskforge/services/auth_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            Expanded(
              child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5.0,
                      color: themedata.scaffoldBackgroundColor.withOpacity(0.8),
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
                          'to do',
                          style: themedata.textTheme.displaySmall,
                        ),
                        subtitle: Text(
                          'this is a dummy text ',
                          style: themedata.textTheme.displaySmall,
                        ),
                        trailing: Container(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.teal,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
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
            )
          ],
        ),
      ),
    );
  }
}
