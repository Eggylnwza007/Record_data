import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  // ฟังก์ชันสำหรับเพิ่มงานใหม่
  void addTodoHandle(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add new task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Task Title"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Task Description"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('tasks').add({
                  'title': _titleController.text,
                  'description': _descriptionController.text,
                  'status': 'incomplete', // สถานะของงาน
                  'created_at': Timestamp.now(),
                });
                _titleController.text = "";
                _descriptionController.text = "";
                Navigator.pop(context);
              },
              child: const Text("Save"),
            )
          ],
        );
      },
    );
  }

  // ฟังก์ชันสำหรับแก้ไขงานที่มีอยู่
  void editTodoHandle(BuildContext context, DocumentSnapshot task) {
    // ตั้งค่า TextController ให้เป็นค่าที่มีอยู่แล้ว
    _titleController.text = task['title'];
    _descriptionController.text = task['description'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit task"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Task Title"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Task Description"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                task.reference.update({
                  'title': _titleController.text,
                  'description': _descriptionController.text,
                });
                _titleController.text = "";
                _descriptionController.text = "";
                Navigator.pop(context);
              },
              child: const Text("Save"),
            )
          ],
        );
      },
    );
  }

  // ฟังก์ชันสำหรับลบงาน
  void onDelete(DocumentSnapshot task) {
    task.reference.delete(); // ลบข้อมูล
  }

  // ฟังก์ชันสำหรับเปลี่ยนสถานะงาน
  void onTap(DocumentSnapshot task) {
    task.reference.update({
      'status': task['status'] == 'incomplete' ? 'complete' : 'incomplete',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var tasks = snapshot.data!.docs;
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              var task = tasks[index];
              return ListTile(
                title: Text(task['title']),
                subtitle: Text(task['description']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        editTodoHandle(context, task); // เรียกฟังก์ชันแก้ไขงาน
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        onDelete(task); // เรียกฟังก์ชันลบงาน
                      },
                    ),
                  ],
                ),
                onTap: () {
                  onTap(task); // เรียกฟังก์ชันเปลี่ยนสถานะงาน
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTodoHandle(context); // เรียกฟังก์ชันเพิ่มงานใหม่
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
