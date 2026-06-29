import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('TASK LIST'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Color(0xFFA50044)),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .where('userId', isEqualTo: user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator(color: Color(0xFFEDBB00)));

          final tasks = snapshot.data!.docs;

          if (tasks.isEmpty) {
            return const Center(
              child: Text(
                'No tasks found. Add a new task!',
                style: TextStyle(color: Colors.white60, fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              var task = tasks[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                // Futuristic Cyber Task Card
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2433),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
                  border: Border.all(color: const Color(0xFF004D98), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEDBB00).withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        // Left strip toggles alternate colors (Blue & Crimson Red)
                        Container(width: 8, color: index % 2 == 0 ? const Color(0xFFA50044) : const Color(0xFF004D98)),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(task['title'], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: Colors.white)),
                                const SizedBox(height: 6),
                                Text(task['description'], style: const TextStyle(color: Colors.white70, fontSize: 14)),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_note_rounded, color: Color(0xFFEDBB00)),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => EditTaskScreen(
                                    taskId: task.id,
                                    currentTitle: task['title'],
                                    currentDesc: task['description'],
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFA50044)),
                              onPressed: () => FirebaseFirestore.instance.collection('tasks').doc(task.id).delete(),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTaskScreen())),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEDBB00),
          foregroundColor: const Color(0xFF141822),
          elevation: 6,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        icon: const Icon(Icons.add_circle_outline),
        label: const Text('ADD TASK', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
      ),
    );
  }
}