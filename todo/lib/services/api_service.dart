import 'dart:convert';

import 'package:http/http.dart';
import 'package:todo/models/task.dart';

class ApiService {
  String endpoint = 'https://jsonplaceholder.typicode.com/todos';

  // Function to fetch data from API endpoint
  Future<List<TaskModel>> getUser() async {
    // Error handling with try-catch block
    try{
      // Making a GET request
      Response response = await get(Uri.parse(endpoint));
      if(response.statusCode == 200) {
        final List result = jsonDecode(response.body);

        // Converting the response into a List of TaskModel objects
        return result.map(((e) => TaskModel.fromJson(e))).toList();
      }
      else {
        // Throw exception in case of error
        throw Exception(response.reasonPhrase);
      }
    }
    catch(err){
      // Throw exception in case of error
      rethrow;
    }
  }
}