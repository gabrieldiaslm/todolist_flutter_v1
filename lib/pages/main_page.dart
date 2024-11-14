import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/pages/task.dart';
import "../models/task_model.dart";
import '../provider/task_provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    List<Task> tasks = taskProvider.tasks.toList();

    tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Tarefas',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: tasks.isEmpty
          ? Center(child: CircularProgressIndicator(
            color: theme.primaryColor,
          ))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TaskTile(task: tasks[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(backgroundColor: theme.primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TaskForm()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
