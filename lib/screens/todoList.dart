import 'package:flutter/material.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/utils/dbhelper.dart';

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TodoListState();
}

class TodoListState extends State {
  DbHelper helper = DbHelper();
  List<Todo> todos;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (todos == null) {
      todos = List<Todo>();
      _getData();
    }

    return Scaffold(
      body: todoListItems(),
      floatingActionButton: FloatingActionButton(
          onPressed: null, tooltip: "Add new Todo", child: new Icon(Icons.add)),
    );
  }

  ListView todoListItems() {
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position) {
          return Card(
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getColor(this.todos[position].priority),
                  child: Text(this.todos[position].priority.toString()),
                ),
                title: Text(this.todos[position].title),
                subtitle: Text(this.todos[position].date),
                onTap: () {
                  print("### Tapped on " + this.todos[position].id.toString());
                },
              ));
        });
  }

  Color _getColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.orange;
        break;
      case 3:
        return Colors.green;
        break;
      default:
        return Colors.green;
    }
  }

  void _getData() {
    helper.initializeDb().then((value) {
      helper.getTodos().then((value) {
        _setTodoListState(value);
      });
    });
  }

  void _setTodoListState(List value) {
    List<Todo> todoList = List<Todo>();
    count = value.length;
    for (int element = 0; element < count; element++) {
      todoList.add(Todo.fromObject(value[element]));
    }
    _setToState(todoList, count);
  }

  void _setToState(List<Todo> todos, int count) {
    setState(() {
      this.todos = todos;
      this.count = count;
    });
  }
}
