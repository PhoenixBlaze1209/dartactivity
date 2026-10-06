import 'models/student.dart';
import 'package:flutter/material.dart';
import 'screens/add_student_page.dart';
import 'screens/student_details_page.dart';
import 'services/database_helper.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
  List<Student> students = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    refreshStudents();
  }

  // Load students from the database
  Future refreshStudents() async {
    setState(() => isLoading = true);

    try{
      students = await DatabaseHelper.instance.getAllStudents();
    } catch (e) {
      print("database error  ngani");
    } finally {
      setState(() => isLoading = false);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Information System')),
      body: isLoading 
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(student.name),
                  subtitle: Text('${student.course} - Year ${student.yearLevel}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      // Delete from DB, then refresh UI
                      await DatabaseHelper.instance.deleteStudent(student.id!);
                      refreshStudents();
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newStudent = await Navigator.push<Student>(
            context,
            MaterialPageRoute(builder: (context) => const AddStudentPage()),
          );
          if (newStudent != null) {
            // Save to DB, then refresh UI
            await DatabaseHelper.instance.insertStudent(newStudent);
            refreshStudents();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

