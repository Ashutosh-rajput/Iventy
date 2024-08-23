import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserInput extends StatefulWidget {
  final Function addUserFunction;
  final Function updateUserFunction;
  final User? userToEdit;
  final VoidCallback clearEditMode;

  const UserInput({
    required this.addUserFunction,
    required this.updateUserFunction,
    required this.clearEditMode,
    this.userToEdit,
    Key? key,
  }) : super(key: key);

  @override
  _UserInputState createState() => _UserInputState();
}

class _UserInputState extends State<UserInput> {
  final _nameController = TextEditingController();
  final _mobController = TextEditingController();
  final _addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.userToEdit != null) {
      _nameController.text = widget.userToEdit!.name;
      _mobController.text = widget.userToEdit!.mob.toString();
      _addressController.text = widget.userToEdit!.address;
    }
  }

  @override
  void didUpdateWidget(covariant UserInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.userToEdit != null) {
      _nameController.text = widget.userToEdit!.name;
      _mobController.text = widget.userToEdit!.mob.toString();
      _addressController.text = widget.userToEdit!.address;
    } else {
      _nameController.clear();
      _mobController.clear();
      _addressController.clear();
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    } else if (value.length > 20) {
      return 'Name cannot be longer than 20 characters';
    }
    return null;
  }

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    } else if (value.length != 10) {
      return 'Mobile number must be 10 digits';
    } else if (int.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address is required';
    } else if (value.length > 20) {
      return 'Address cannot be longer than 20 characters';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (widget.userToEdit != null) {
        final updatedUser = User(
          id: widget.userToEdit!.id,
          name: _nameController.text,
          mob: int.parse(_mobController.text),
          address: _addressController.text,
        );
        widget.updateUserFunction(updatedUser);
      } else {
        final newUser = User(
          name: _nameController.text,
          mob: int.parse(_mobController.text),
          address: _addressController.text,
        );
        widget.addUserFunction(newUser);
      }
      _nameController.clear();
      _mobController.clear();
      _addressController.clear();
      widget.clearEditMode();
    }
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
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: _validateName,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _mobController,
                  decoration: const InputDecoration(labelText: 'Mobile Number'),
                  keyboardType: TextInputType.number,
                  validator: _validateMobile,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  validator: _validateAddress,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(
                    widget.userToEdit != null ? 'Update User' : 'Add User',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (widget.userToEdit != null)
                SizedBox(
                  width: 50,
                  height: 50,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: widget.clearEditMode,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
