import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../models/todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool?> onToggleComplete;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleComplete,
  });

  Color _getPriorityColor() {
    switch (todo.priority) {
      case PriorityLevel.high:
        return Colors.red.shade100;
      case PriorityLevel.medium:
        return Colors.orange.shade100;
      case PriorityLevel.low:
        return Colors.green.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onEdit(),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
          ),
          SlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: _getPriorityColor(),
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor,
              width: 0.5,
            ),
          ),
        ),
        child: ListTile(
          leading: Checkbox(
            value: todo.isComplete,
            onChanged: onToggleComplete,
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              decoration: todo.isComplete ? TextDecoration.lineThrough : null,
              color: todo.isComplete ? Colors.grey : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (todo.description != null && todo.description!.isNotEmpty)
                Text(
                  todo.description!,
                  style: TextStyle(
                    decoration: todo.isComplete ? TextDecoration.lineThrough : null,
                    color: todo.isComplete ? Colors.grey : null,
                  ),
                ),
              if (todo.dueDate != null)
                Text(
                  'Due: ${DateFormat('MMM d, y').format(todo.dueDate!)}',
                  style: TextStyle(
                    color: todo.isComplete
                        ? Colors.grey
                        : todo.dueDate!.isBefore(DateTime.now())
                            ? Colors.red
                            : null,
                  ),
                ),
            ],
          ),
          trailing: Icon(
            Icons.circle,
            color: todo.priority == PriorityLevel.high
                ? Colors.red
                : todo.priority == PriorityLevel.medium
                    ? Colors.orange
                    : Colors.green,
            size: 12,
          ),
        ),
      ),
    );
  }
} 