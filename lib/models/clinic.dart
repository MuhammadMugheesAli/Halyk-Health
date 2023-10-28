class Clinic{
  final String name;
  final String address;
  final List numbers;
  final bool paid;
  final String workingHours;


  Clinic({required this.name, required this.address, required this.numbers, required this.paid, required this.workingHours});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'numbers': numbers,
      'paid': paid,
      'workingHours': workingHours,
    };
  }

  factory Clinic.fromMap(Map<String, dynamic> map) {
    return Clinic(
      name: map['Name'] as String,
      address: map['Address'] as String,
      numbers: map['Contact Numbers'] as List,
      paid: map['Paid'] as bool,
      workingHours: map['Working Hours'] as String,
    );
  }
}
