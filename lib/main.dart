import 'models/student.dart';
import 'package:flutter/material.dart';
import 'screens/add_student_page.dart';
import 'screens/student_details_page.dart';


void main() {
  runApp(const StudentInformationSystem());
}

class StudentInformationSystem extends StatelessWidget {
  const StudentInformationSystem({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Information System',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Student> students = [
  Student(
    id: 1,
    name: 'Juan Dela Cruz',
    course: 'BS Information Technology',
    yearLevel: 2,
    email: 'juan@example.com',
  ),
  Student(
    id: 2,
    name: 'Maria Santos',
    course: 'BS Information Technology',
    yearLevel: 1,
    email: 'maria@example.com',
  ),
];

final searchController = TextEditingController();
List<Student> filteredStudents = [];

@override
void initState() {
  super.initState();
  filteredStudents = students;
}


void searchStudents(String query) {
  setState(() {
    filteredStudents = students.where((student) {
      return student.name
          .toLowerCase()
          .contains(query.toLowerCase());
    }).toList();
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Information System'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              onChanged: searchStudents,
              decoration: const InputDecoration(
                labelText: 'Search Student',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: filteredStudents.length,
              itemBuilder: (context, index) {
                final student = filteredStudents[index];

                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(student.name),
                  subtitle: Text(student.course),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newStudent = await Navigator.push<Student>(
            context,
            MaterialPageRoute(
              builder: (context) => const AddStudentPage(),
            ),
          );

          if (newStudent != null) {
            setState(() {
              students.add(newStudent);
              filteredStudents = students;
            });
          }
        },
        child: const Icon(Icons.add),
      ),


    ); 
  }
}