import 'models/student.dart';
import 'package:flutter/material.dart';
import 'screens/add_student_page.dart';
import 'screens/student_details_page.dart';
import 'services/database_helper.dart';
import 'screens/edit_student_page.dart';


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
  final searchController = TextEditingController();
  List<Student> students = [];
  List<Student> filteredStudents = [];
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
      filteredStudents = students;
    } catch (e) {
      print("database error  ngani $e");
    } finally {
      setState(() => isLoading = false);
    }
    
  }

  void searchStudents(String query) {
  setState(() {
    filteredStudents = students.where((student) {
      return student.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Information System')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
  subtitle: Text('${student.course} - Year ${student.yearLevel}'),
  trailing: Row(
    mainAxisSize: MainAxisSize.min, 
    children: [
    
      IconButton(
        icon: const Icon(Icons.edit, color: Colors.blue),
        onPressed: () async {
          
          final updatedStudent = await Navigator.push<Student>(
            context,
            MaterialPageRoute(
              builder: (context) => EditStudentPage(student: student),
            ),
          );

         
          if (updatedStudent != null) {
            await DatabaseHelper.instance.updateStudent(updatedStudent);
            refreshStudents();
          }
        },
      ),

      IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () async {
          await DatabaseHelper.instance.deleteStudent(student.id!);
          refreshStudents();
        },
      ),
    ],
  ),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentDetailsPage(student: student),
      ),
    );
  },
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
            MaterialPageRoute(builder: (context) => const AddStudentPage()),
          );
          if (newStudent != null) {
            
            await DatabaseHelper.instance.insertStudent(newStudent);
            refreshStudents();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

