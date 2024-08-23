import 'package:flutter/material.dart';
import '../models/todo_model.dart';
import './todo_card.dart';

class Todolist extends StatelessWidget {
  final List<Todo> todos;
  final Function(Todo) editFunction;
  final Function(Todo) deleteFunction;

  const Todolist({
    required this.editFunction,
    required this.deleteFunction,
    required this.todos,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return todos.isEmpty
        ? const Center(
            child: Text('No data found'),
          )
        : ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, i) => Todocard(
              id: todos[i].id!,
              title: todos[i].title,
              tamount: todos[i].tamount,
              pamount: todos[i].pamount,
              lamount: todos[i].lamount,
              creationDate: todos[i].creationDate,
              editFunction: editFunction,
              deleteFunction: deleteFunction,
            ),
          );
  }
}
