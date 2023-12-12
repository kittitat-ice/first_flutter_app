import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 192, 192, 255)),
        useMaterial3: true,
        // primaryColor: Colors.red,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Task>> todos = getTodos();

  static Future<List<Task>> getTodos() async {
    const link =
        "https://todo-list-api-mfchjooefq-as.a.run.app/todo-list?offset=0&limit=10&sortBy=createdAt";
    final url = Uri.parse(link);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      List<Task> list =
          body['tasks'].map<Task>((data) => Task.fromJson(data)).toList();
      return list;
    } else {
      debugPrint("error");
      return List<Task>.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        toolbarHeight: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TopCard(),
          FutureBuilder(
              future: todos,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final tasks = snapshot.data!;
                  return Flexible(flex: 1, child: buildTodos(tasks));
                } else {
                  return Text("No Data");
                }
              })
        ],
      ),
    );
  }
}

class TopCard extends StatelessWidget {
  final String title;
  final String greeting;
  const TopCard(
      {super.key,
      this.title = "Hi Super User",
      this.greeting = "let's have a great day!"});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18))),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.red)),
              ],
            ),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(greeting)
          ],
        ),
      ),
    );
  }
}

Widget buildTodos(List<Task> tasks) => ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                Text(
                  task.description,
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                ),
              ],
            ));
      },
    );

class Task {
  final String id;
  final String title;
  final String description;
  final String createdAt;
  final String status;

  const Task(
      {required this.id,
      required this.title,
      required this.description,
      required this.createdAt,
      required this.status});

  Task.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        title = json['title'] as String,
        description = json['description'] as String,
        createdAt = json['createdAt'] as String,
        status = json['status'] as String;
}
