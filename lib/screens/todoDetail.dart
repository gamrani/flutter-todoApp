import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/utils/dbhelper.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/utils/constants.dart';

DbHelper helper = DbHelper();

class TodoDetail extends StatefulWidget {
  final Todo todo;
  TodoDetail(this.todo);

  @override
  State<StatefulWidget> createState() => TodoDetailState(todo);
}

class TodoDetailState extends State {
  Todo todo;
  String _priority = PRIORITIES[2];
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
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return ACTIONS_CHOICES.map((String choice) {
                  return PopupMenuItem<String>(
                      value: choice, child: Text(choice));
                }).toList();
              },
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 40.0, left: 10.0, right: 10.0),
          child: ListView(children: <Widget>[
            Column(
              children: <Widget>[
                getTextField(textStyle, titleController, "Title", 5.0, "title"),
                Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: getTextField(textStyle, descriptionController,
                        "Description", 5.0, "description")),
                ListTile(
                  title: DropdownButton<String>(
                    items: getPriorities(),
                    style: textStyle,
                    value: retrievePriority(todo.priority),
                    onChanged: (String value) {
                      updatePriority(value);
                    },
                  ),
                )
              ],
            )
          ]),
        ));
  }

  void _select(String value) async {
    int result;
    switch (value) {
      case menuSave:
        save();
        break;
      case menuDelete:
        Navigator.pop(context, true);
        if (todo.id == null) {
          return;
        }
        result = await helper.deleteTodo(todo.id);
        if (result != 0) {
          AlertDialog alertDialog = AlertDialog(
            title: Text("Delete Todo"),
            content: Text("The Todo has been deleted"),
          );
          showDialog(context: context, builder: (_) => alertDialog);
        }
        break;
      case menuBack:
        Navigator.pop(context, true);
        break;
      default:
    }
  }

  void updatePriority(String value) {
    switch (value) {
      case "High":
        todo.priority = 1;
        break;
      case "Medium":
        todo.priority = 2;
        break;
      case "Low":
        todo.priority = 3;
        break;
    }
    setState(() {
      _priority = value;
    });
  }

  void updateTitle() {
    todo.title = titleController.text;
  }

  void updateDescription() {
    todo.title = descriptionController.text;
  }

  String retrievePriority(int value) {
    return PRIORITIES[value - 1];
  }

  void save() {
    todo.date = new DateFormat.yMd().format(DateTime.now());
    if (todo.id != null) {
      helper.updateTodo(todo);
    } else {
      helper.insertTodo(todo);
    }
    Navigator.pop(context, true);
  }

  TextField getTextField(TextStyle textStyle, TextEditingController controller,
      String labelText, double borderRadius, String textField) {
    return TextField(
      controller: controller,
      style: textStyle,
      onChanged: (value) => this.updateTextField(textField),
      decoration: InputDecoration(
          labelText: labelText,
          labelStyle: textStyle,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius))),
    );
  }

  void updateTextField(String textField) {
    switch (textField) {
      case "title":
        this.updateTitle();
        break;
      case "description":
        this.updateDescription();
        break;
    }
  }

  List<DropdownMenuItem<String>> getPriorities() {
    return PRIORITIES.map((element) {
      return DropdownMenuItem<String>(
        value: element,
        child: Text(element),
      );
    }).toList();
  }
}
