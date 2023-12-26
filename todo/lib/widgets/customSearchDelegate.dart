import 'package:flutter/material.dart';

import '../models/task.dart';
import '../screens/home.dart';
import '../widgets/item_tile.dart';

class CustomSearchDelegate extends SearchDelegate {

  Future<List<TaskModel>> getSearchTerms() async {
    return searchList;
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<TaskModel>>(
      future: getSearchTerms(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<TaskModel> matchQuery = snapshot.data!
              .where((item) => item.title.toLowerCase().contains(query.toLowerCase()))
              .toList();
          return ListView.builder(
            itemCount: matchQuery.length,
            itemBuilder: (context, index) {
              var result = matchQuery[index];
              if(index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                child: ItemTile(task: result,),
              );
              } else {
                return ItemTile(task: result);
              }
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }
}
