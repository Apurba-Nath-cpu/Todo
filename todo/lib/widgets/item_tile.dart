import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/task.dart';

import '../providers/futureUpdater.dart';
import '../providers/task.dart';
import '../providers/theme.dart';

class ItemTile extends ConsumerWidget {
  final TaskModel task;
  const ItemTile({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get all tasks
    final taskData = ref.watch(taskDataProvider);
    // Get future updater
    int futureUpdater = ref.watch(futureUpdaterProvider);
    // Get current theme
    bool theme = ref.watch(themeProvider);

    // Declare necessary TextEditingControllers
    TextEditingController _nameController = TextEditingController();
    // Get Device's dimensions
    double Dheight = MediaQuery.of(context).size.height;
    double Dwidth = MediaQuery.of(context).size.width;

    // final
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: Dwidth * 0.03),
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: Dwidth * 0.01),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5,),
            color: theme ? Colors.grey.shade700 : Colors.grey.shade300,
          ),
          child: Row(
            // CheckBox to mark/unmark task as completed
            children: [
              Checkbox(value: taskData.value?.where((element) => element.id == task.id).toList()[0].completed, onChanged: (value) {
                ref.read(taskDataProvider).value?.where((element) => element.id == task.id).toList()[0].completed = value!;
                if(task.completed == value) {
                  _nameController.dispose();
                  ref.read(futureUpdaterProvider.notifier).state = (futureUpdater+1)%10;
                }
              }),
              // Displaying task.title
              SizedBox(
                width: Dwidth * 0.5,
                child: SingleChildScrollView(
                  child: Text(
                      task.title,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),

              Expanded(child: Container()),

              // Edit tasks
              IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        // Creating a form for editing a task
                        return AlertDialog(
                          title: const Text(
                              'Give your new title',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          content: TextField(
                            textAlign: TextAlign.center,
                            controller: _nameController,
                              decoration: InputDecoration(
                                hintText: "Title",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                filled: true,
                                prefixIcon: const Icon(Icons.title),
                              ),
                          ),
                          actions: [
                            // Cancel form(dialogbox)
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('CANCEL', style: TextStyle(color: Colors.black),),
                            ),

                            // Accept form and update task data.
                            TextButton(
                              onPressed: () {
                                // Error handling on entering empty string
                                if(task.title != _nameController.text) {
                                  if(_nameController.text == "") {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Please enter a title'),
                                      ),
                                    );
                                  }
                                  // Updating task
                                  else{
                                    ref.read(taskDataProvider).value?.where((element) => element.id == task.id).toList()[0].title  = _nameController.text!;
                                    ref.read(futureUpdaterProvider.notifier).state = (futureUpdater+1)%10;
                                    // Returning to main screen
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              child: const Text('ACCEPT', style: TextStyle(color: Colors.green),),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: CircleAvatar(
                    backgroundColor: theme ? Colors.grey.shade800 : Colors.grey.shade100,
                    maxRadius: 18,
                    child: const Icon(Icons.edit),
                  ),
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 2,
        ),
      ],
    );
  }
}
