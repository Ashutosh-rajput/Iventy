class Todo {
  int? id;
  final int userId;
  final String title;
  final int tamount;
  final int pamount;
  final int lamount;
  final DateTime creationDate;

  Todo({
    this.id,
    required this.userId,
    required this.title,
    required this.tamount,
    required this.pamount,
    required this.lamount,
    required this.creationDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'tamount': tamount,
      'pamount': pamount,
      'lamount': lamount,
      'creationDate': creationDate.toString(),
    };
  }

  @override
  String toString() {
    return 'Todo(id: $id, userId: $userId, title: $title, tamount: $tamount, pamount: $pamount, lamount: $lamount, creationDate: $creationDate)';
  }
}
