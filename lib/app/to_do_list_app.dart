import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/app/app_theme.dart';
import 'package:to_do_list/pages/main_page.dart';
import 'package:to_do_list/provider/task_provider.dart';

class ToDoListApp extends StatelessWidget {
  const ToDoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider()..loadTasks(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light( Colors.purple),
        home: const MainPage(),
      ),
    );
  }
}