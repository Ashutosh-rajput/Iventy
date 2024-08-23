import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/todo_model.dart';

class UserCard extends StatelessWidget {
  final User user;
  final List<Todo> todos;
  final Function deleteFunction;
  final Function onEdit;
  final Function onViewTodos;
  final int index;

  const UserCard({
    required this.user,
    required this.todos,
    required this.deleteFunction,
    required this.onEdit,
    required this.onViewTodos,
    required this.index,
    Key? key,
  }) : super(key: key);

  int get totalAmount => todos.fold(0, (sum, todo) => sum + todo.tamount);
  int get leftAmount => todos.fold(0, (sum, todo) => sum + todo.lamount);

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete User'),
          content: Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                deleteFunction(user);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String displayAddress = user.address;
    if (user.address.length > 15) {
      displayAddress = user.address.substring(0, 15) + '...';
    }

    return GestureDetector(
      onTap: () => onViewTodos(),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  '${index + 1}', // Display serial number
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  user.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  user.mob.toString(),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 4,
                child: Tooltip(
                  message: user.address,
                  child: Text(
                    displayAddress,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Total: ₹$totalAmount',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  'Left: ₹$leftAmount',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => onEdit(user),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _showDeleteDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
