import 'package:flutter/material.dart';
import '../models/student.dart';

class EditStudentPage extends StatefulWidget {
  final Student student;

  const EditStudentPage({super.key, required this.student});

  @override
  State<EditStudentPage> createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  late TextEditingController nameController;
  late TextEditingController courseController;
  late TextEditingController yearController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    // Pre-fill the text fields with the current student's data
    nameController = TextEditingController(text: widget.student.name);
    courseController = TextEditingController(text: widget.student.course);
    yearController = TextEditingController(text: widget.student.yearLevel.toString());
    emailController = TextEditingController(text: widget.student.email);
  }

  @override
  void dispose() {
    nameController.dispose();
    courseController.dispose();
    yearController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Student Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: courseController,
              decoration: const InputDecoration(labelText: 'Course', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: yearController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Year Level', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Create an updated Student object using the SAME ID
                final updatedStudent = Student(
                  id: widget.student.id, 
                  name: nameController.text,
                  course: courseController.text,
                  yearLevel: int.parse(yearController.text),
                  email: emailController.text,
                );
                
                // Return the updated data to the main page
                Navigator.pop(context, updatedStudent);
              },
              child: const Text('Update Student'),
            ),
          ],
        ),
      ),
    );
  }
}