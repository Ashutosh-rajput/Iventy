class User {
  int? id;
  final String name;
  // final String email;
  final String address;
  final int mob;

  User({
    this.id,
    required this.name,
    // required this.email,
    required this.address,
    required this.mob,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      // 'email': email,
      'address': address,
      'mob': mob,
    };
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, address: $address, mob: $mob)';
  }
}
