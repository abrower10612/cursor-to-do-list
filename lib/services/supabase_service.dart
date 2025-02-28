import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/todo.dart';
import 'package:flutter/foundation.dart';

class SupabaseService {
  final SupabaseClient _client;

  SupabaseService(this._client);

  // Authentication methods
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // Todo CRUD operations
  Future<List<Todo>> getTodos() async {
    try {
      final response = await _client
          .from('todos')
          .select()
          .eq('user_id', _client.auth.currentUser!.id)
          .order('created_at', ascending: false);
      
      return (response as List)
          .map((json) => Todo.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error fetching todos: $e');
      rethrow;
    }
  }

  Future<Todo> createTodo(Todo todo) async {
    try {
      debugPrint('Creating todo: ${todo.toJson()}');
      final response = await _client
          .from('todos')
          .insert(todo.toJson())
          .select()
          .single();
      
      debugPrint('Todo created successfully: $response');
      return Todo.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error creating todo: $e');
      rethrow;
    }
  }

  Future<Todo> updateTodo(Todo todo) async {
    final response = await _client
        .from('todos')
        .update(todo.toJson())
        .eq('id', todo.id)
        .select()
        .single();
    
    return Todo.fromJson(response as Map<String, dynamic>);
  }

  Future<void> deleteTodo(String id) async {
    await _client.from('todos').delete().eq('id', id);
  }

  // Stream todos for real-time updates
  Stream<List<Todo>> streamTodos() {
    debugPrint('Setting up todo stream for user: ${_client.auth.currentUser!.id}');
    return _client
        .from('todos')
        .stream(primaryKey: ['id'])
        .eq('user_id', _client.auth.currentUser!.id)
        .order('created_at', ascending: false)
        .map((response) {
          debugPrint('Received ${response.length} todos from stream');
          final todos = response
              .map((json) => Todo.fromJson(json as Map<String, dynamic>))
              .toList();
          // Sort by created_at in descending order (newest first)
          todos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return todos;
        })
        .handleError((error) {
          debugPrint('Error in stream: $error');
          // If we get an error with the stream, fall back to regular fetch
          return getTodos();
        });
  }
} 