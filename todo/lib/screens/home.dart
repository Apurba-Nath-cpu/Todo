import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/models/task.dart';
import 'package:todo/widgets/item_tile.dart';

import '../providers/task.dart';
import '../providers/theme.dart';
import '../widgets/customSearchDelegate.dart';

late List<TaskModel> searchList = [];

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get all tasks
    final taskData = ref.watch(taskDataProvider);
    // Get current theme
    bool theme = ref.watch(themeProvider);

    // Declare necessary TextEditingControllers
    TextEditingController _addNewTaskController = TextEditingController();
    TextEditingController _searchController = TextEditingController();

    // Get Device's dimensions
    double Dheight = MediaQuery.of(context).size.height;
    double Dwidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        // To hide the keyboard when user taps on screen by un-focusing.
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      // TabController for TabBarView
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text(
                'Todo App',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            actions: <Widget>[
              // IconButton to change theme
              IconButton(
                  onPressed: () {
                    ref.read(themeProvider.notifier).state = !theme;
                  },
                  icon: theme ? const Icon(Icons.dark_mode_outlined) : const Icon(Icons.light_mode_outlined),
              ),
            ],

            // TabBar to show ["All", "Completed", "Incomplete"] below the AppBar
            bottom: const TabBar(
              isScrollable: true,
              tabs: [
                Tab(
                  text: "All",
                ),
                Tab(
                  text: "Completed",
                ),
                Tab(
                  text: "Incomplete",
                ),
              ],
            ),
          ),

          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  // Implementing SearchBar
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Don't like scrolling ? Use me :)",
                      hintStyle: TextStyle(fontSize: Dwidth.toInt() * 0.04),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      showSearch(context: context, delegate: CustomSearchDelegate());
                    },
                  ),
                ),
                SizedBox(
                  height: Dheight * 0.8,
                  child: Center(
                    child: taskData.when(
                        data: (data){
                          searchList = taskData.value!;

                          // TabBarView for all three categories of tasks
                          return TabBarView(
                            // All tasks
                            children: [
                              ListView.builder(
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return ItemTile(task: data[index]);
                                  }
                              ),
                              // Completed tasks
                              ListView.builder(
                                  itemCount: data.where((task) {
                                    return task.completed;
                                  }).length,
                                  itemBuilder: (context, index) {
                                    if(!data[index].completed) return Container();
                                    return ItemTile(task: data[index]);
                                  }
                              ),
                              // Incomplete tasks
                              ListView.builder(
                                  itemCount: data.where((task) {
                                    return !task.completed;
                                  }).length,
                                  itemBuilder: (context, index) {
                                    if(data[index].completed) return Container();
                                    return ItemTile(task: data[index]);
                                  }
                              ),
                            ],
                          );

                        },
                        // Error handling
                        error: ((error, stackTrace) => Text(stackTrace.toString())),
                        // Showing CircularProgressIndicator while the screen is loading
                        loading: () {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Add tasks by using FloatingActionButton
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // Creating a form for adding a new task
                  return AlertDialog(
                    title: const Text('Add your title'),
                    content: TextField(
                      textAlign: TextAlign.center,
                      controller: _addNewTaskController,
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
                      // Accept form and add task.
                      TextButton(
                        onPressed: () {
                          // Error handling on entering empty string
                          if(_addNewTaskController.text == ""){
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a title')));
                          }
                          else{
                            int? totalTasks = taskData.value?.length;
                            int? newUserId = taskData.value![totalTasks!-1].userId + 1;
                            TaskModel newTask = TaskModel(userId: newUserId, id: totalTasks!+1, title: _addNewTaskController.text, completed: false);

                            // Adding task
                            ref.read(taskDataProvider).value?.insert(0, newTask);
                            // Returning to main screen
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('ACCEPT', style: TextStyle(color: Colors.green),),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
