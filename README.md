# Todo App

This App has the functionality to:
1. Fetch data from API endpoint and display them in tabulated manner.
2. Categorise tasks as completed or Incomplete.
3. Edit the completion status of each task.
4. Edit the title of a task.
5. Add new tasks.
6. Search for a task.
7. Toggle theme (Light/Dark).

Riverpod has been used for state management.

4 Providers have been used:
1. Theme(to get current theme).
2. Api(To get instance of ApiService class).
3. TaskData(to get current tasks).
4. FutureUpdater(To assist FutureProvider in rebuilding widget).

External packages used:
1. http: ^1.1.0 - For fetching data from API
2. flutter_riverpod: ^2.4.9 - For state management
