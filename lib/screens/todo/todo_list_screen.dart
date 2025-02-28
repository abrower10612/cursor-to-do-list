import 'package:flutter/material.dart';
import 'dart:async';
import '../../models/todo.dart';
import '../../services/supabase_service.dart';
import '../../widgets/todo_item.dart';
import 'add_edit_todo_screen.dart';

class TodoListScreen extends StatefulWidget {
  final SupabaseService supabaseService;
  final String userId;

  const TodoListScreen({
    super.key,
    required this.supabaseService,
    required this.userId,
  });

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> _todos = [];
  bool _isLoading = true;
  String? _error;
  StreamSubscription<List<Todo>>? _todoSubscription;

  @override
  void initState() {
    super.initState();
    _subscribeToTodos();
  }

  @override
  void dispose() {
    _todoSubscription?.cancel();
    super.dispose();
  }

  void _subscribeToTodos() {
    debugPrint('Setting up todo subscription');
    _todoSubscription?.cancel();
    _todoSubscription = widget.supabaseService.streamTodos().listen(
      (todos) {
        debugPrint('Received ${todos.length} todos from subscription');
        if (mounted) {
          setState(() {
            _todos = todos;
            _isLoading = false;
            _error = null;
          });
        }
      },
      onError: (error) {
        debugPrint('Error in todo subscription: $error');
        if (mounted) {
          setState(() {
            _error = error.toString();
            _isLoading = false;
          });
          // Try to resubscribe after a delay
          Future.delayed(const Duration(seconds: 5), _subscribeToTodos);
        }
      },
    );
  }

  Future<void> _addTodo() async {
    try {
      final result = await Navigator.push<Todo>(
        context,
        MaterialPageRoute(
          builder: (context) => AddEditTodoScreen(
            userId: widget.userId,
            onSave: (todo) async {
              try {
                debugPrint('Attempting to create todo: ${todo.toJson()}');
                final createdTodo = await widget.supabaseService.createTodo(todo);
                debugPrint('Todo created successfully: ${createdTodo.toJson()}');
                
                if (!context.mounted) return;
                
                // First pop back to the todo list screen
                Navigator.pop(context, createdTodo);
                
                // Then show the success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Todo created successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                debugPrint('Error in onSave callback: $e');
                if (!context.mounted) return;
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error creating todo: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
                rethrow;
              }
            },
          ),
        ),
      );

      // No need to refresh subscription, the stream will handle updates
      if (result != null) {
        debugPrint('Todo created successfully');
      }
    } catch (e) {
      debugPrint('Error in _addTodo: $e');
      if (!context.mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _editTodo(Todo todo) async {
    final result = await Navigator.push<Todo>(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditTodoScreen(
          todo: todo,
          userId: widget.userId,
          onSave: (updatedTodo) async {
            try {
              await widget.supabaseService.updateTodo(updatedTodo);
              if (!context.mounted) return;
              Navigator.pop(context, updatedTodo);
            } catch (e) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
              rethrow;
            }
          },
        ),
      ),
    );

    // No need to refresh subscription, the stream will handle updates
    if (result != null) {
      debugPrint('Todo updated successfully');
    }
  }

  Future<void> _deleteTodo(String id) async {
    try {
      await widget.supabaseService.deleteTodo(id);
      // No need to refresh subscription, the stream will handle updates
      debugPrint('Todo deleted successfully');
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _toggleTodoComplete(Todo todo) async {
    try {
      final updatedTodo = todo.copyWith(isComplete: !todo.isComplete);
      await widget.supabaseService.updateTodo(updatedTodo);
      // No need to refresh subscription, the stream will handle updates
      debugPrint('Todo completion toggled successfully');
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(child: Text('Error: $_error'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => widget.supabaseService.signOut(),
          ),
        ],
      ),
      body: _todos.isEmpty
          ? const Center(
              child: Text(
                'No todos yet!\nTap the + button to add one.',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return TodoItem(
                  todo: todo,
                  onEdit: () => _editTodo(todo),
                  onDelete: () => _deleteTodo(todo.id),
                  onToggleComplete: (_) => _toggleTodoComplete(todo),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        child: const Icon(Icons.add),
      ),
    );
  }
} 