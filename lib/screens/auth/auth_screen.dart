import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class AuthScreen extends StatefulWidget {
  final SupabaseService supabaseService;

  const AuthScreen({
    super.key,
    required this.supabaseService,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _showLogin = true;

  void _toggleView() {
    setState(() {
      _showLogin = !_showLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showLogin) {
      return LoginScreen(
        supabaseService: widget.supabaseService,
        onSignUpTap: _toggleView,
      );
    } else {
      return SignUpScreen(
        supabaseService: widget.supabaseService,
        onLoginTap: _toggleView,
      );
    }
  }
} 