import 'package:flutter/material.dart';
import '../models/todo_model.dart';

class TodoInput extends StatefulWidget {
  final Function(Todo) addOrUpdateTodoFunction;
  final int userId;
  final Todo? todoToEdit;
  final VoidCallback onCancelEdit;

  const TodoInput({
    required this.addOrUpdateTodoFunction,
    required this.userId,
    this.todoToEdit,
    required this.onCancelEdit,
    Key? key,
  }) : super(key: key);

  @override
  _TodoInputState createState() => _TodoInputState();
}

class _TodoInputState extends State<TodoInput> {
  final _titleController = TextEditingController();
  final _tamountController = TextEditingController();
  final _pamountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Todo? todoToEdit;

  @override
  void initState() {
    super.initState();
    todoToEdit = widget.todoToEdit;
    if (todoToEdit != null) {
      _titleController.text = todoToEdit!.title;
      _tamountController.text = todoToEdit!.tamount.toString();
      _pamountController.text = todoToEdit!.pamount.toString();
    }
  }

  @override
  void didUpdateWidget(TodoInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.todoToEdit != oldWidget.todoToEdit) {
      setState(() {
        todoToEdit = widget.todoToEdit;
        if (todoToEdit != null) {
          _titleController.text = todoToEdit!.title;
          _tamountController.text = todoToEdit!.tamount.toString();
          _pamountController.text = todoToEdit!.pamount.toString();
        } else {
          _titleController.clear();
          _tamountController.clear();
          _pamountController.clear();
        }
      });
    }
  }

  String? _validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Title is required';
    } else if (value.length > 20) {
      return 'Title cannot be longer than 20 characters';
    }
    return null;
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    } else if (int.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  String? _validatePaidAmount(String? value) {
    final totalAmount = int.tryParse(_tamountController.text) ?? 0;
    if (value == null || value.isEmpty) {
      return 'Paid amount is required';
    } else if (int.tryParse(value) == null) {
      return 'Please enter a valid number';
    } else if (int.parse(value) > totalAmount) {
      return 'Paid amount cannot be more than total amount';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final totalAmount = int.parse(_tamountController.text);
      final paidAmount = int.parse(_pamountController.text);
      final leftAmount = totalAmount - paidAmount;

      final todo = Todo(
        id: todoToEdit?.id,
        title: _titleController.text,
        tamount: totalAmount,
        pamount: paidAmount,
        lamount: leftAmount,
        creationDate: DateTime.now(),
        userId: widget.userId,
      );
      widget.addOrUpdateTodoFunction(todo);
      _titleController.clear();
      _tamountController.clear();
      _pamountController.clear();
    }
  }

  void _cancelUpdate() {
    setState(() {
      todoToEdit = null;
      _titleController.clear();
      _tamountController.clear();
      _pamountController.clear();
    });
    widget.onCancelEdit();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: _validateTitle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _tamountController,
                  decoration: const InputDecoration(labelText: 'Total Amount'),
                  keyboardType: TextInputType.number,
                  validator: _validateAmount,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _pamountController,
                  decoration: const InputDecoration(labelText: 'Paid Amount'),
                  keyboardType: TextInputType.number,
                  validator: _validatePaidAmount,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 160,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(
                    todoToEdit == null ? 'Add Todo' : 'Update Todo',
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (todoToEdit != null) ...[
                SizedBox(
                  width: 50,
                  height: 50,
                  child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _cancelUpdate),
                ),
                const SizedBox(width: 8),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
