import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;
  final String currentTitle;
  final String currentDesc;

  const EditTaskScreen({
    Key? key,
    required this.taskId,
    required this.currentTitle,
    required this.currentDesc,
  }) : super(key: key);

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.currentTitle);
    _descController = TextEditingController(text: widget.currentDesc);
  }

  void _updateTask() async {
    if (_titleController.text.isNotEmpty && _descController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('tasks').doc(widget.taskId).update({
        'title': _titleController.text.trim(),
        'description': _descController.text.trim(),
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EDIT TASK')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Title', prefixIcon: Icon(Icons.edit)),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _descController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(labelText: 'Description', prefixIcon: Icon(Icons.edit_note)),
              maxLines: 4,
            ),
            const SizedBox(height: 35),
            ElevatedButton(
              onPressed: _updateTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEDBB00),
                foregroundColor: const Color(0xFF141822),
                elevation: 6,
                minimumSize: const Size(double.infinity, 55),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
                ),
              ),
              child: const Text('UPDATE TASK', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
            )
          ],
        ),
      ),
    );
  }
}