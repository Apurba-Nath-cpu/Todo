class TaskModel {
  late int userId;
  late int id;
  late dynamic title;
  late bool completed;

  TaskModel(
      {
        required this.userId,
        required this.id,
        required this.title,
        required this.completed,
      }
  );

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        completed: json["completed"],
    );
  }
}