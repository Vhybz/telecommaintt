enum UserRole {
  administrator(1, 'Administrator'),
  networkEngineer(2, 'Network Engineer'),
  technician(3, 'Technician');

  final int id;
  final String name;
  const UserRole(this.id, this.name);

  static UserRole fromId(int id) {
    return UserRole.values.firstWhere((e) => e.id == id, orElse: () => UserRole.technician);
  }
}
