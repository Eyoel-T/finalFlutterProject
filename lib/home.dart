import 'dart:convert';
import 'package:flutter/material.dart';

import 'taskModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:dio/dio.dart";
import 'package:uuid/uuid.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  late final SharedPreferences pref;
  late String userId;
  Dio dio = Dio();
  String name = "";
  final uuid = Uuid();

  final taskInputController = TextEditingController();
  List<Task> taskList = [];

  void initState() {
    super.initState();
    loadSharedPreferencesAndData();
  }

  void loadSharedPreferencesAndData() async {
    try {
      pref = await SharedPreferences.getInstance();
      userId = pref.getString("userId")!;
      name = pref.getString("username")!;
      var response = await dio
          .get("https://fluttertaskapp.herokuapp.com/api/task/$userId");
      for (var task in response.data) {
        taskList
            .add(Task(taskTitle: task["taskTitle"], taskId: task["taskId"]));
      }
      setState(() {});
    } catch (err) {}
  }

  void addTask(taskId) async {
    try {
      var response = await dio
          .post("https://fluttertaskapp.herokuapp.com/api/task", data: {
        "userId": userId,
        "taskTitle": taskInputController.text,
        "taskId": taskId,
        "isDone": true,
      });
    } catch (err) {}
  }

  void deleteTask(taskId) async {
    try {
      print("taskId==$taskId");
      var response = await dio
          .delete("https://fluttertaskapp.herokuapp.com/api/task/$taskId");
      print(response.data);
    } catch (err) {}
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
                                  var uniqueTaskId = uuid.v4();
                                  setState(() {
                                    taskList.add(Task(
                                        taskTitle: taskInputController.text,
                                        taskId: uniqueTaskId));
                                  });
                                  addTask(uniqueTaskId);

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
                      "Hello $name",
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
                          var uniqueTaskId = taskList[index].taskId;
                          setState(() {
                            taskList.removeAt(index);
                          });
                          print(uniqueTaskId);
                          deleteTask(uniqueTaskId);
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
}
