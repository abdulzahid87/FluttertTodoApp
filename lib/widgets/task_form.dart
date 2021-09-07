import 'dart:io';

import 'package:flutter/material.dart';


class TaskForm extends StatefulWidget {
  final bool loading;
  final Function(DateTime deadline) onSubmit;
  final GlobalKey<FormState> formKey;
  final String btnText;
  final TextEditingController descController;
  final TextEditingController titleController;
  final DateTime deadline;

  const TaskForm({
    Key? key,
    required this.formKey,
    required this.titleController,
    required this.descController,
    required this.onSubmit,
    required this.loading,
    required this.btnText,
    required this.deadline,
  }) : super(key: key);

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  DateTime _deadline = DateTime.now();

  @override
  void initState() {
    super.initState();
    _deadline = widget.deadline;
  }

  void _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deadline,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 3600)),
    );
    if (picked != null) {
      setState(() {
        _deadline = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _deadline.hour,
          _deadline.minute,
        );
      });
    }
  }

  void _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_deadline),
    );
    if (picked != null) {
      setState(() {
        _deadline = DateTime(
          _deadline.year,
          _deadline.month,
          _deadline.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: widget.titleController,
              decoration: InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value!.isEmpty) return 'Add Title';
                return null;
              },
            ),
            TextFormField(
              controller: widget.descController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
              validator: (value) {
                if (value!.isEmpty) return 'Add Description';
                return null;
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 12, bottom: 4),
              child: Text(
                'Date',
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            InkWell(
              onTap: _selectDate,
              child: Text(
                '${_deadline.day}/${_deadline.month}/${_deadline.year}',
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12, bottom: 4),
              child: Text(
                "O'clock",
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            InkWell(
              onTap: _selectTime,
              child: Text('${_deadline.hour}:${_deadline.minute}'),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: RawMaterialButton(
                fillColor: Colors.greenAccent,
                onPressed: widget.loading
                    ? null
                    : () => widget.onSubmit(_deadline),
                child: widget.loading
                    ? CircularProgressIndicator()
                    : Text(widget.btnText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
