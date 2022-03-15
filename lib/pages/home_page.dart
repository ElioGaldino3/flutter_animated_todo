import 'package:flutter/material.dart';
import 'package:todo_animation/widgets/checkbox.dart';

import '../models/todo_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final todos = List.generate(30, (index) => TodoModel('Tarefa ${index++}', false));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Animated Todo'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, left: 24, right: 24),
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final todo = todos[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: CustomCheckbox(
                      value: todo.value,
                      title: todo.title,
                      onChanged: (value) => todos[index].value = value,
                    ),
                  );
                },
                childCount: todos.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
