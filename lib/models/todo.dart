import 'package:uuid/uuid.dart';

enum PriorityLevel { low, medium, high }

class Todo {
  final String id;
  final String userId;
  String title;
  String? description;
  bool isComplete;
  PriorityLevel priority;
  DateTime? dueDate;
  final DateTime createdAt;
  DateTime updatedAt;

  Todo({
    String? id,
    required this.userId,
    required this.title,
    this.description,
    this.isComplete = false,
    this.priority = PriorityLevel.medium,
    this.dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      isComplete: json['is_complete'] as bool,
      priority: PriorityLevel.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => PriorityLevel.medium,
      ),
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'is_complete': isComplete,
      'priority': priority.name,
      'due_date': dueDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Todo copyWith({
    String? title,
    String? description,
    bool? isComplete,
    PriorityLevel? priority,
    DateTime? dueDate,
  }) {
    return Todo(
      id: id,
      userId: userId,
      title: title ?? this.title,
      description: description ?? this.description,
      isComplete: isComplete ?? this.isComplete,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
} 