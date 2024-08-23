import 'package:flutter/material.dart';
import '../models/todo_model.dart';

class Todocard extends StatelessWidget {
  final int id;
  final String title;
  final int tamount;
  final int pamount;
  final int lamount;
  final DateTime creationDate;
  final Function(Todo) editFunction;
  final Function(Todo) deleteFunction;

  const Todocard({
    Key? key,
    required this.id,
    required this.title,
    required this.tamount,
    required this.pamount,
    required this.lamount,
    required this.creationDate,
    required this.editFunction,
    required this.deleteFunction,
  }) : super(key: key);

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Listing'),
          content: const Text('Are you sure you want to delete this listing?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                deleteFunction(Todo(
                  id: id,
                  title: title,
                  tamount: tamount,
                  pamount: pamount,
                  lamount: lamount,
                  creationDate: creationDate,
                  userId: id,
                ));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis),
            ),
            Expanded(
              child: Text(
                'Total: ₹${tamount.toString()}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: Text(
                'Paid: ₹${pamount.toString()}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: Text(
                'Left: ₹${lamount.toString()}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              child: Text(
                'Date: ${creationDate.toLocal().toString().split(' ')[0]}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => editFunction(
                Todo(
                  id: id,
                  title: title,
                  tamount: tamount,
                  pamount: pamount,
                  lamount: lamount,
                  creationDate: creationDate,
                  userId: id,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}
