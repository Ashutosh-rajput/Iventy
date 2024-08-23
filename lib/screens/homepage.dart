import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart' as fsb;
import 'package:fuzzy/fuzzy.dart';
import '../models/db_model.dart';
import '../models/user_model.dart';
import '../models/todo_model.dart';
import '../widgets/user_input.dart';
import '../widgets/user_card.dart';
import '../screens/UserTodosPage.dart';
import '../widgets/dashboard.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  List<User> userList = [];
  List<Todo> todoList = [];
  List<User> filteredUserList = [];
  late DatabaseConnect db;
  late fsb.SearchBar searchBar;
  User? userToEdit;

  HomepageState() {
    searchBar = fsb.SearchBar(
      inBar: false,
      setState: setState,
      onChanged: _onSearchChanged,
      buildDefaultAppBar: _buildAppBar,
      clearOnSubmit: false,
      closeOnSubmit: false,
      hintText: 'Search by name or address',
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('User List'),
      actions: [
        searchBar.getSearchAction(context),
        IconButton(
          icon: const Icon(Icons.backup),
          onPressed: () {
            _backupDatabase(context);
          },
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    db = DatabaseConnect();
    fetchUsers();
    fetchTodos();
  }

  void fetchUsers() async {
    userList = await db.getUsers();
    filteredUserList = userList;
    setState(() {});
  }

  void fetchTodos() async {
    todoList = await db.getTodos();
    setState(() {});
  }

  void addUser(User user) async {
    await db.insertUser(user);
    fetchUsers();
  }

  void deleteUser(User user) async {
    await db.deleteUserTodos(user.id!); // Delete user's todos first
    await db.deleteUser(user);
    fetchUsers();
    fetchTodos();
  }

  void updateUser(User user) async {
    await db.updateUser(user);
    fetchUsers();
    setState(() {
      userToEdit = null; // Clear edit mode
    });
  }

  List<Todo> getUserTodos(int? userId) {
    if (userId == null) return [];
    final userTodos = todoList.where((todo) => todo.userId == userId).toList();
    return userTodos;
  }

  void _onSearchChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        filteredUserList = userList;
      });
    } else {
      final fuse = Fuzzy<User>(
        userList,
        options: FuzzyOptions<User>(
          keys: [
            WeightedKey(
              name: 'name',
              getter: (User user) => user.name,
              weight: 1.0,
            ),
            WeightedKey(
              name: 'address',
              getter: (User user) => user.address,
              weight: 1.0,
            ),
          ],
          findAllMatches: true,
        ),
      );
      final result = fuse.search(value);
      setState(() {
        filteredUserList = result.map((r) => r.item).toList();
      });
    }
  }

  double calculateTotalAmount() {
    final double totalAmount =
        todoList.fold(0, (sum, todo) => sum + todo.tamount);
    return totalAmount;
  }

  double calculatePaidAmount() {
    final double paidAmount =
        todoList.fold(0, (sum, todo) => sum + todo.pamount);
    return paidAmount;
  }

  double calculateLeftAmount() {
    final double leftAmount =
        todoList.fold(0, (sum, todo) => sum + (todo.tamount - todo.pamount));
    return leftAmount;
  }

  void _onTodosUpdated() {
    fetchTodos();
  }

  Future<void> _backupDatabase(BuildContext context) async {
    await db.backupDatabase();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Database backup completed!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchBar.build(context),
      body: Column(
        children: [
          Dashboard(
            totalAmount: calculateTotalAmount(),
            paidAmount: calculatePaidAmount(),
            leftAmount: calculateLeftAmount(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredUserList.length,
              itemBuilder: (context, index) {
                final user = filteredUserList[index];
                final userTodos = getUserTodos(user.id);
                return UserCard(
                  user: user,
                  todos: userTodos,
                  deleteFunction: deleteUser,
                  onEdit: (user) {
                    setState(() {
                      userToEdit = user;
                    });
                  },
                  onViewTodos: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserTodosPage(
                          user: user,
                          onTodosUpdated: _onTodosUpdated,
                        ),
                      ),
                    );
                  },
                  index: index,
                );
              },
            ),
          ),
          UserInput(
            addUserFunction: addUser,
            updateUserFunction: updateUser,
            userToEdit: userToEdit,
            clearEditMode: () {
              setState(() {
                userToEdit = null;
              });
            },
          ),
        ],
      ),
    );
  }
}
