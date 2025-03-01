import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/auth/auth_screen.dart';
import 'screens/todo/todo_list_screen.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase with environment variables
  await Supabase.initialize(
    url: const String.fromEnvironment('SUPABASE_URL'),
    anonKey: const String.fromEnvironment('SUPABASE_ANON_KEY'),
    authOptions: FlutterAuthClientOptions(
      authFlowType: AuthFlowType.implicit,
    ),
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AppWrapper(),
    );
  }
}

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  late final SupabaseService _supabaseService;
  late final SupabaseClient _client;

  @override
  void initState() {
    super.initState();
    _client = Supabase.instance.client;
    _supabaseService = SupabaseService(_client);
    
    // Listen for auth state changes
    _client.auth.onAuthStateChange.listen((data) {
      if (!mounted) return;

      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      debugPrint('Auth event: $event');
      if (session != null) {
        debugPrint('User ID: ${session.user.id}');
        debugPrint('User Email: ${session.user.email}');
        debugPrint('Email confirmed: ${session.user.emailConfirmedAt != null}');
      }

      if (event == AuthChangeEvent.signedIn) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully signed in!'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (event == AuthChangeEvent.userUpdated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email verified successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (event == AuthChangeEvent.signedOut) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signed out'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: _client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final session = snapshot.data!.session;
        if (session == null) {
          return AuthScreen(supabaseService: _supabaseService);
        }

        return TodoListScreen(
          supabaseService: _supabaseService,
          userId: session.user.id,
        );
      },
    );
  }
}
