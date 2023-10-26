import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodo extends StatefulWidget {
  const AddTodo({
    super.key,
    this.todo,
  });
  final Map? todo;

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController descEditingController = TextEditingController();
  bool isEdit = false;
  @override
  void initState() {
    super.initState();
    final todos = widget.todo;
    if (todos != null) {
      final title = todos['title'];
      final desc = todos['description'];
      titleEditingController.text = title;
      descEditingController.text = desc;
      isEdit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo' : 'Add Todo'),
      ),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        TextField(
          controller: titleEditingController,
          decoration: const InputDecoration(hintText: "Title"),
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          controller: descEditingController,
          decoration: const InputDecoration(hintText: "Discription"),
          keyboardType: TextInputType.multiline,
          minLines: 5,
          maxLines: 8,
        ),
        ElevatedButton(
          onPressed: isEdit ? udatebutton : submitbutton,
          child: Text(isEdit ? 'Udate' : 'Submit'),
        ),
      ]),
    );
  }

  Future<void> submitbutton() async {
    final title = titleEditingController.text;
    final desc = descEditingController.text;
    final body = {"title": title, "description": desc, "is_completed": false};
    const url = 'http://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 201) {
      titleEditingController.text = '';
      descEditingController.text = '';
      showSuccessMessage("Creation Success!");
    } else {
      showErrorMessage("Creation Faild!");
    }
  }

  Future<void> udatebutton() async {
    final title = titleEditingController.text;
    final desc = descEditingController.text;
    final todos = widget.todo;
    if (todos == null) {
      return;
    }
    final id = todos['_id'];

    final body = {"title": title, "description": desc, "is_completed": false};
    final url = 'http://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      showSuccessMessage("Update Success!");
    } else {
      showErrorMessage("Update Faild!");
    }
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
