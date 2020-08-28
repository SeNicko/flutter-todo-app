import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Todo.dart';

class TodoListView extends StatefulWidget {
  @override
  _TodoListViewState createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  List<Todo> todos = [];

  List<Todo> doneTodos = [];

  int screenIndex = 0;

  void getTodosFromLocalFile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      todos = (prefs.getStringList('todos') ?? []).fold([],
          (List<Todo> prev, String todoName) {
        prev.add(Todo(name: todoName, id: UniqueKey().toString()));
        return prev;
      });

      doneTodos = (prefs.getStringList('doneTodos') ?? []).fold([],
          (List<Todo> prev, String todoName) {
        prev.add(Todo(name: todoName, id: UniqueKey().toString()));
        return prev;
      });
    });
  }

  void saveTodosToLocalFile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> todosAsString =
        todos.fold([], (List<String> prev, Todo element) {
      prev.add(element.name);
      return prev;
    });

    List<String> doneTodosAsString =
        doneTodos.fold([], (List<String> prev, Todo element) {
      prev.add(element.name);
      return prev;
    });

    print(doneTodosAsString);

    prefs.setStringList('todos', todosAsString);
    prefs.setStringList('doneTodos', doneTodosAsString);
  }

  @override
  void initState() {
    super.initState();
    getTodosFromLocalFile();
  }

  @override
  Widget build(BuildContext context) {
    int todosListLength = screenIndex == 0 ? todos.length : doneTodos.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(screenIndex == 0
            ? "Things you have to do"
            : "Things you have done"),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: todosListLength,
        itemBuilder: (BuildContext context, int index) =>
            buildTodos(context, index),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.done), label: "All todos"),
          BottomNavigationBarItem(
              icon: Icon(Icons.done_all), label: "Completed")
        ],
        currentIndex: screenIndex,
        onTap: (int index) {
          setState(() {
            screenIndex = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          dynamic result = await Navigator.pushNamed(context, '/create');
          if (result != null) {
            setState(() {
              todos.add(result);
            });
            saveTodosToLocalFile();
          }
        },
        child: Icon(Icons.add),
        elevation: 0,
      ),
    );
  }

  Widget buildTodos(BuildContext context, int index) {
    Todo todo = screenIndex == 0 ? todos[index] : doneTodos[index];

    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Dismissible(
          background: Container(
            color: screenIndex == 0 ? Colors.green : Colors.red,
          ),
          secondaryBackground: Container(
            color: Colors.red,
          ),
          key: Key(todo.id),
          onDismissed: (direction) {
            if (screenIndex == 1)
              setState(() {
                doneTodos.remove(todo);
              });
            else if (direction == DismissDirection.endToStart)
              setState(() {
                todos.removeWhere((Todo item) => item.id == todo.id);
              });
            else if (direction == DismissDirection.startToEnd)
              setState(() {
                doneTodos.add(todo);
                todos.remove(todo);
              });

            saveTodosToLocalFile();
          },
          child: ListTile(
            title: Text(
              todo.name,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[900],
              ),
            ),
            contentPadding:
                EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            tileColor: Colors.grey[200],
          )),
    );
  }
}
