import 'dart:convert';
import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'taskModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  FirebaseAuth auth = FirebaseAuth.instance;
  late User loggedInUser;
  late String email;

  void getCurrentUser() {
    try {
      final user = auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  final taskInputController = TextEditingController();
  List<Task> taskList = [];

  late final SharedPreferences pref;
  late String name;

  void loadSharedPreferencesAndData() async {
    pref = await SharedPreferences.getInstance();
    loadData();
  }

  void initState() {
    super.initState();
    getCurrentUser();
    loadSharedPreferencesAndData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueAccent,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                builder: (context) => Container(
                      padding: EdgeInsets.only(left: 40, right: 40, top: 30),
                      child: ListView(
                        children: [
                          Center(
                            child: Text(
                              "New task",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 25,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            autofocus: true,
                            controller: taskInputController,
                            decoration: InputDecoration(
                                hintText: "What are you Planning"),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                if (taskInputController.text.length != 0) {
                                  setState(() {
                                    taskList.add(Task(
                                        taskTitle: taskInputController.text));
                                  });
                                  saveData();

                                  taskInputController.clear();
                                }
                                Navigator.pop(context);
                              },
                              child: Text("Add"))
                        ],
                      ),
                    ));
          },
          child: Icon(
            Icons.add,
            size: 30,
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 50, right: 50, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      child: Icon(
                        Icons.list,
                        size: 30,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Hello$name",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "${taskList.length} Tasks",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding:
                      EdgeInsets.only(left: 40, right: 20, bottom: 20, top: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      color: Colors.white),
                  child: ListView.builder(
                    itemCount: taskList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onLongPress: () {
                          setState(() {
                            taskList.removeAt(index);
                            saveData();
                          });
                        },
                        title: Text(taskList[index].taskTitle!,
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 20,
                                decoration: taskList[index].isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                fontWeight: FontWeight.w400)),
                        trailing: Checkbox(
                          value: taskList[index].isDone,
                          onChanged: (value) {
                            setState(() {
                              taskList[index].done();
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ));
  }

  void loadData() {
    name = pref.getString("name")!;
    List<String>? listString = pref.getStringList('list');
    if (listString != null) {
      taskList =
          listString.map((item) => Task.fromMap(json.decode(item))).toList();

      setState(() {});
    }
  }

  void saveData() {
    List<String> stringList =
        taskList.map((item) => json.encode(item.toMap())).toList();
    pref.setStringList('list', stringList);
  }
}
