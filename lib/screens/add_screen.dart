import 'dart:io';

import 'package:android_todo_app/widgets/task_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  AddScreen({Key? key}) : super(key: key);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  bool _loading = false;
  final CollectionReference tasks = FirebaseFirestore.instance
      .collection('tasks');
  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit(DateTime deadline) async {
    if (!_loading && _formKey.currentState!.validate()) {
      try {
        setState(() {
          _loading = true;
        });
        await tasks.add({
          "title": _titleController.text,
          "description": _descController.text,
          "deadline": Timestamp.fromDate(deadline),
        });
        Navigator.of(context).pop();
      } catch (error) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: SingleChildScrollView(
        child: TaskForm(
          formKey: _formKey,
          titleController: _titleController,
          descController: _descController,
          onSubmit: _onSubmit,
          loading: _loading,
          btnText: 'Add', deadline: DateTime.now(),
        ),
      ),
    );
  }
}
