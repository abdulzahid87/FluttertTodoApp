import 'package:android_todo_app/widgets/add_todo.dart';
import 'package:android_todo_app/widgets/edit_todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";

class TodoList extends StatefulWidget {
  TodoList({Key? key}) : super(key: key);

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final Stream<QuerySnapshot> todoStream = FirebaseFirestore.instance
      .collection('tasks')
      .orderBy('deadline', descending: true)
      .snapshots();

  CollectionReference todo = FirebaseFirestore.instance.collection('tasks');
  Future<void> deleteUser(id) {
    return todo
        .doc(id)
        .delete()
        .then((value) => print('User Deleted'))
        .catchError((error) => print('Failed to Delete user: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Todo App',
          style: TextStyle(
              color: Color(0xffebebeb),
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
            stream: todoStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                print('Something went Wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              final List storedocs = [];
              snapshot.data!.docs.map((DocumentSnapshot document) {
                Map a = document.data() as Map<String, dynamic>;
                storedocs.add(a);
                a['id'] = document.id;
              }).toList();

              return ListView(
                children: [
                  Container(
                    child: SingleChildScrollView(
                      child: Column(children: [
                        for (var i = 0; i < storedocs.length; i++) ...[
                          Card(
                            child: Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, top: 8),
                                      child: Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          storedocs[i]['title'],
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.yellowAccent,
                                              fontFamily: "STIX Two Text"),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 8.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                                storedocs[i]['description'],
                                                style: TextStyle(
                                                    fontSize: 15.0,
                                                    fontFamily: "STIX Two Text",
                                                    color: Color(0xffebebeb))),
                                          ),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                                storedocs[i]['deadline']
                                                    .toDate()
                                                    .toString()
                                                    .substring(0, 16),
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          child: IconButton(
                                            iconSize: 28,
                                            color: Colors.lightBlueAccent,
                                            onPressed: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => UpdateTodo(
                                                    id: storedocs[i]['id']),
                                              ),
                                            ),
                                            icon: Icon(Icons.edit),
                                          ),
                                        ),
                                        Container(
                                          child: IconButton(
                                            iconSize: 28,
                                            onPressed: () =>
                                                deleteUser(storedocs[i]['id']),
                                            color: Colors.redAccent,
                                            icon: Icon(Icons.delete),
                                          ),
                                        ),
                                      ]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ]),
                    ),
                  ),
                ],
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffebebeb),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddData(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
