import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AddData extends StatefulWidget {
  AddData({Key? key}) : super(key: key);

  @override
  _AddDataState createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  final _formKey = GlobalKey<FormState>();

  var title = "";
  var description = "";
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
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

  // Adding Student
  CollectionReference todo =
  FirebaseFirestore.instance.collection('tasks');

  Future<void> addUser() {
    return todo
        .add({'title': title, 'description': description,"deadline":DateTime.now()})
        .then((value) => print('Task Added'))
        .catchError((error) => print('Failed to Add task: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Task",style: TextStyle(color: Color(0xffebebeb),fontWeight: FontWeight.bold,fontSize: 24),),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(
                      labelText: 'title: ',
                      labelStyle: TextStyle(fontSize: 18.0),
                      border: OutlineInputBorder(),
                      errorStyle:
                      TextStyle(color: Colors.redAccent, fontSize: 15),
                    ),
                    controller: titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter title';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(
                      labelText: 'description: ',
                      labelStyle: TextStyle(fontSize: 18.0),
                      border: OutlineInputBorder(),
                      errorStyle:
                      TextStyle(color: Colors.redAccent, fontSize: 15),
                    ),
                    controller: descriptionController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter description';
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
                        setState(() {
                          title = titleController.text;
                          description = descriptionController.text;
                          DateTime.now();
                          addUser();
                          clearText();
                        });
                      }
                    },
                    child: Text(
                      'Add',
                      style: TextStyle(fontSize: 18.0,color: Colors.black),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}