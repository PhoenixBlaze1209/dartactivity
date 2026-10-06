class Student {
  int? id; 
  String name;
  String course;
  int yearLevel;
  String email;

  Student({
    this.id,
    required this.name,
    required this.course,
    required this.yearLevel,
    required this.email,
  });

  // Convert a Student into a Map for the database
  Map<String, dynamic> toMap() {
    return {
      if(id != id)'id': id,
      'name': name,
      'course': course,
      'yearLevel': yearLevel,
      'email': email,
    };
  }

  // Convert a Map from the database back into a Student
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      course: map['course'],
      yearLevel: map['yearLevel'],
      email: map['email'],
    );
  }
}