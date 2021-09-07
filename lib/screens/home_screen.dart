import 'dart:async';

import 'package:android_todo_app/screens/add_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StreamController<QuerySnapshot> documentStream =
      StreamController<QuerySnapshot>();

  @override
  void initState() {
    super.initState();
    documentStream.addStream(FirebaseFirestore.instance
        .collection('tasks')
        .orderBy(
          'deadline',
          descending: false,
        )
        .snapshots());
  }

  @override
  void dispose() {
    documentStream.close();
    super.dispose();
  }

  void _goToAddScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(

        title: Text('Todo App'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: documentStream.stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "failed to fetch data ${snapshot.error.toString()}",
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          List<QueryDocumentSnapshot> list = snapshot.data!.docs;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int position) {
              QueryDocumentSnapshot document = list[position];
              return Container(
                alignment: Alignment.topLeft,
                child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    Text("${document["title"]},",textAlign: TextAlign.left,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                      SizedBox(height: 5,),
                    Text("${document["description"]}",textAlign: TextAlign.left,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w500),),
                      SizedBox(height: 5,),
                    Text("${(document["deadline"] as Timestamp).toDate().toString().substring(0,10)}",textAlign: TextAlign.left,style: TextStyle(fontSize: 10),),
                      SizedBox(height: 15,),
                  ],),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:_goToAddScreen,
        child: Icon(Icons.add),
      ),
    );
  }
}
