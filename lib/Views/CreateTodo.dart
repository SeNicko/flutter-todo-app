import 'package:flutter/material.dart';
import '../models/Todo.dart';

class CreateTodoView extends StatefulWidget {
  @override
  _CreateTodoViewState createState() => _CreateTodoViewState();
}

class _CreateTodoViewState extends State<CreateTodoView> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create todo'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Enter todo name'),
            ),
            SizedBox(
              height: 10.0,
            ),
            FlatButton(
                onPressed: () {
                  Navigator.pop(context,
                      Todo(name: controller.text, id: UniqueKey().toString()));
                },
                color: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                child: Text(
                  'submit',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}
