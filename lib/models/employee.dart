enum EmployeeStatus { active, inactive }

class Employee {
  final String id;
  final String name;
  final String lastName;
  final String phone;
  final String email;
  final String shift;
  EmployeeStatus status;
  final String documentType;
  final String documentNumber;
  final String registrationDate;

  Employee({
    required this.id,
    required this.name,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.shift,
    required this.status,
    required this.documentType,
    required this.documentNumber,
    required this.registrationDate,
  });

  bool get isActive => status == EmployeeStatus.active;

  void toggleStatus() {
    status = status == EmployeeStatus.active 
        ? EmployeeStatus.inactive 
        : EmployeeStatus.active;
  }

  String get statusText => isActive ? 'Activo' : 'Inactivo';
}