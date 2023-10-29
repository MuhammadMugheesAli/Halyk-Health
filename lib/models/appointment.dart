class Appointment {
  final String firstName;
  final String secondName;
  final String address;
  final String iinNumber;
  final DateTime date;
  final String doctorNumber;
  final String doctorName;
  final String patientNumber;
  final String patientName;

  Appointment({required this.firstName, required this.secondName, required this.address, required this.iinNumber, required this.date,required this.doctorNumber, required this.doctorName, required this.patientNumber, required this.patientName,});

  Map<String, dynamic> toMap() {
    return {
      'firstName': this.firstName,
      'secondName': this.secondName,
      'address': this.address,
      'iinNumber': this.iinNumber,
      'date': this.date,
      'doctorNumber': this.doctorNumber,
      'doctorName': this.doctorName,
      'patientNumber': this.patientNumber,
      'patientName': this.patientName,
    };
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      firstName: map['firstName'] as String,
      secondName: map['secondName'] as String,
      address: map['address'] as String,
      iinNumber: map['iinNumber'] as String,
      date: map['date'].toDate() as DateTime,
      doctorNumber: map['doctorNumber'] as String,
      doctorName: map['doctorName'] as String,
      patientNumber: map['patientNumber'] as String,
      patientName: map['patientName'] as String,
    );
  }
}
