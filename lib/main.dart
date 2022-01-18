import 'package:flutter/material.dart';
import 'bloc/todo_bloc.dart';
import 'models/todo.dart';
import 'screens/todo_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todoozy',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'Todoozy'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TodoBloc? todoBloc;
  List<Todo>? todos;

  @override
  void initState() {
    todoBloc = TodoBloc();
    super.initState();
  }

  @override
  void dispose() {
    todoBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Todo todo = Todo('', '', '', 0);
    todos = todoBloc?.todoList;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<List<Todo>>(
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return ListView.builder(
            itemCount: (snapshot.hasData) ? snapshot.data.length : 0,
            itemBuilder: (context, index) {
              return Dismissible(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).highlightColor,
                      child: Text("${snapshot.data[index].priority}"),
                    ),
                    title: Text("${snapshot.data[index].name}"),
                    subtitle: Text("${snapshot.data[index].description}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TodoScreen(snapshot.data[index], false),
                          ),
                        );
                      },
                    ),
                  ),
                  key: Key(snapshot.data[index].id.toString()),
                  onDismissed: (_) =>
                      todoBloc?.todoDeleteSink.add(snapshot.data[index]));
            },
          );
        },
        stream: todoBloc?.todos,
        initialData: todos,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TodoScreen(todo, true)),
          );
        },
        tooltip: 'Add Todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
