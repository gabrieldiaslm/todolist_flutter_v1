import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../provider/task_provider.dart';

class TaskForm extends StatefulWidget {
  final Task? task;

  const TaskForm({super.key, this.task});

  @override
  State<TaskForm> createState() => _TaskState();
}

class _TaskState extends State<TaskForm> {
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();
  final TextEditingController _taskCategoryController = TextEditingController();
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _taskTitleController.text = widget.task!.title;
      _taskDescriptionController.text = widget.task!.description;
      _taskCategoryController.text = widget.task!.category;
      _dueDate = widget.task!.dueDate;
    }
  }

  @override
  void dispose() {
    _taskTitleController.dispose();
    _taskDescriptionController.dispose();
    _taskCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.task == null ? 'Nova Tarefa' : 'Editar Tarefa',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _taskTitleController,
              decoration: InputDecoration(
                labelText: 'Título',
                labelStyle: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 18.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _taskDescriptionController,
              decoration: InputDecoration(
                labelText: 'Descrição',
                labelStyle: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 18.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            TextField(
              controller: _taskCategoryController,
              decoration: InputDecoration(
                labelText: 'Categoria',
                labelStyle: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 18.0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _dueDate ?? DateTime.now(),
                  firstDate: DateTime.fromMillisecondsSinceEpoch(
                      1641031200000),
                  lastDate: DateTime(2100),
                );
                if (picked != null && picked != _dueDate) {
                  setState(() {
                    _dueDate = picked;
                  });
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Data de Vencimento',
                  labelStyle: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 18.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      _dueDate != null
                          ? DateFormat('dd/MM/yyyy').format(_dueDate!)
                          : 'Selecione a Data',
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 16.0,
                      ),
                    ),
                    Icon(
                      Icons.calendar_today,
                      color: theme.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white),
              onPressed: () {
                Task newTask = Task(
                  id: widget.task?.id ??
                      DateTime.now().millisecondsSinceEpoch.toString(),
                  title: _taskTitleController.text,
                  description: _taskDescriptionController.text,
                  dueDate: _dueDate ?? DateTime.now(),
                  category: _taskCategoryController.text,
                );
                if (widget.task == null) {
                  Provider.of<TaskProvider>(context, listen: false)
                      .addTask(newTask);
                } else {
                  Provider.of<TaskProvider>(context, listen: false)
                      .editTask(newTask);
                }
                Navigator.pop(context);
              },
              child: Text(widget.task == null ? 'Adicionar Tarefa' : 'Salvar',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      tileColor: task.isCompleted
      ? Colors.green.shade100
      : task.dueDate.isAfter(DateTime.now())
          ? Colors.blue.shade100
          : Colors.red.shade100,
leading: Checkbox(
  value: task.isCompleted,
  onChanged: (bool? newValue) async {
    await Provider.of<TaskProvider>(context, listen: false)
        .completeTask(task.id, newValue ?? false);
  },
  shape: const CircleBorder(),
  checkColor: Colors.white,
  fillColor: WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.selected)) {
      return theme.primaryColor; 
    }
    return Colors.purple; 
  }),
),

      title: Text(task.title),
      subtitle: Text(task.category),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DateFormat('dd/MM/yyyy').format(task.dueDate),
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false)
                  .deleteTask(task.id);
            },
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TaskForm(task: task)),
        );
      },
    );
  }
}
