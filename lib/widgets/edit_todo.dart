import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateTodo extends StatefulWidget {
  final String id;
  UpdateTodo({Key? key, required this.id}) : super(key: key);

  @override
  _UpdateTodoState createState() => _UpdateTodoState();
}

class _UpdateTodoState extends State<UpdateTodo> {
  final _formKey = GlobalKey<FormState>();

  var title = "";
  var description = "";

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  clearText() {
    titleController.clear();
    descriptionController.clear();
  }

  CollectionReference tasks = FirebaseFirestore.instance.collection('tasks');

  Future<void> updateUser(id, title, description) {
    return tasks
        .doc(id)
        .update({'title': title, 'description': description,"deadline":DateTime.now()})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Task",style: TextStyle(color: Color(0xffebebeb),fontWeight: FontWeight.bold,fontSize: 25),),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
              key: _formKey,
              // Getting Specific Data by ID
              child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance
                    .collection('tasks')
                    .doc(widget.id)
                    .get(),
                builder: (_, snapshot) {
                  if (snapshot.hasError) {
                    print('Something Went Wrong');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var data = snapshot.data!.data();
                  var title = data!['title'];
                  var description = data['description'];
                  return ListView(
                    children: [
                      Container(
                        child: TextFormField(
                          initialValue: title,
                          autofocus: false,
                          onChanged: (value) => title = value,
                          decoration: InputDecoration(
                            labelText: 'Title: ',
                            labelStyle: TextStyle(fontSize: 18.0),
                            border: OutlineInputBorder(),
                            errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 18),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Title';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          initialValue: description,
                          autofocus: false,
                          onChanged: (value) => description = value,
                          decoration: InputDecoration(
                            labelText: 'Description: ',
                            labelStyle: TextStyle(fontSize: 12.0),
                            border: OutlineInputBorder(),
                            errorStyle:
                            TextStyle(color: Colors.redAccent, fontSize: 10),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Description';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all( Color(0xffebebeb),),
                          ),
                          onPressed: () {
                            // Validate returns true if the form is valid, otherwise false.
                            if (_formKey.currentState!.validate()) {
                              updateUser(widget.id, title, description);
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            'Update',
                            style: TextStyle(fontSize: 18.0,color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  );
                },
              )),
        ),
      ),
    );
  }
}