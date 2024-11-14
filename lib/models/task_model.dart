class Task {
  String id;
  String title;
  String description;
  DateTime dueDate;
  String category;
  bool isCompleted;

  Task({
    this.isCompleted = false,
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.category,
  }
  );

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'category': category,
      'isCompleted': isCompleted
    };
  }

  static Task fromJson(String id, Map<String, dynamic> json) {
    return Task(
      id: id,
      title: json['title'],
      description: json['description'],
      dueDate: DateTime.parse(json['dueDate']),
      category: json['category'],
      isCompleted: json['isCompleted']
    );
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    String? category,
    bool isCompleted = false,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      category: category ?? this.category,
      isCompleted: isCompleted,
    );
  }
}
