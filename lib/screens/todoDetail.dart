import 'package:flutter/material.dart';
import 'package:todo_app/model/priority.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/utils/dbhelper.dart';
import 'package:intl/intl.dart';

class TodoDetail extends StatefulWidget {
  final Todo todo;
  TodoDetail(this.todo);

  @override
  State<StatefulWidget> createState() => TodoDetailState(todo);
}

class TodoDetailState extends State {
  Todo todo;
  String _priority = Priority.Low.toString();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  TodoDetailState(this.todo);

  @override
  Widget build(BuildContext context) {
    titleController.text = todo.title;
    descriptionController.text = todo.description;
    TextStyle textStyle = Theme.of(context).textTheme.headline6;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(todo.title),
      ),
      body: Column(
        children: <Widget>[
          getTextField(textStyle, titleController, "Title", 5.0),
          getTextField(textStyle, descriptionController, "Description", 5.0),
          DropdownButton<Priority>(
            items: Priority.values.map((element) {
              return DropdownMenuItem<Priority>(
                value: element,
                child: Text(element.toString()),
              );
            }).toList(),
            style: textStyle,
            value: Priority.Low,
            onChanged: null,
          )
        ],
      ),
    );
  }

  TextField getTextField(TextStyle textStyle, TextEditingController controller,
      String labelText, double borderRadius) {
    return TextField(
      controller: controller,
      style: textStyle,
      decoration: InputDecoration(
          labelText: labelText,
          labelStyle: textStyle,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius))),
    );
  }
}
