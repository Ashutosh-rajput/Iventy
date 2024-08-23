import 'package:flutter/material.dart';
import '../models/db_model.dart';
import '../models/todo_model.dart';
import '../models/user_model.dart';
import '../widgets/todo_list.dart';
import '../widgets/todo_input.dart';

class UserTodosPage extends StatefulWidget {
  final User user;
  final VoidCallback onTodosUpdated;

  const UserTodosPage(
      {required this.user, required this.onTodosUpdated, Key? key})
      : super(key: key);

  @override
  UserTodosPageState createState() => UserTodosPageState();
}

class UserTodosPageState extends State<UserTodosPage> {
  List<Todo> todoList = [];
  late DatabaseConnect db;
  Todo? todoToEdit;

  @override
  void initState() {
    super.initState();
    db = DatabaseConnect();
    fetchTodos();
  }

  void fetchTodos() async {
    todoList = await db.getUserTodos(widget.user.id!);
    setState(() {});
  }

  void addOrUpdateTodo(Todo todo) async {
    if (todo.id == null) {
      await db.insertTodo(todo);
    } else {
      await db.updateTodo(todo);
    }
    fetchTodos();
    widget.onTodosUpdated();
    setState(() {
      todoToEdit = null;
    });
  }

  void editTodoFunction(Todo todo) {
    setState(() {
      todoToEdit = todo;
    });
  }

  void cancelEdit() {
    setState(() {
      todoToEdit = null;
    });
  }

  void deleteTodoFunction(Todo todo) async {
    await db.deleteTodo(todo);
    fetchTodos();
    widget.onTodosUpdated();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions of ${widget.user.name}'),
      ),
      body: Column(
        children: [
          // Card(
          //   child: Padding(
          //     padding: const EdgeInsets.all(10.0),
          //     child: Row(
          //       children: [
          //         ...[
          //           'Name',
          //           'Total Amount',
          //           'Paid Amount',
          //           'Left Amount',
          //           'Date'
          //         ].map((e) => Expanded(
          //               child: Text(
          //                 e,
          //                 style: const TextStyle(fontSize: 18),
          //               ),
          //             )),
          //       ],
          //     ),
          //   ),
          // ),
          Expanded(
            child: Todolist(
              todos: todoList,
              editFunction: editTodoFunction,
              deleteFunction: deleteTodoFunction,
            ),
          ),
          TodoInput(
            addOrUpdateTodoFunction: addOrUpdateTodo,
            userId: widget.user.id!,
            todoToEdit: todoToEdit,
            onCancelEdit: cancelEdit,
          ),
        ],
      ),
    );
  }
}
