import 'package:flutter/material.dart';
import 'package:purrfect_pedia/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:purrfect_pedia/services/onboarding_service.dart'; // Import OnboardingService

class AuthScreen extends StatefulWidget { // Changed to StatefulWidget
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> { // Created State class
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final AuthService _authService = AuthService(); // Instantiate AuthService here or locally in methods

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login / Sign Up'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Sign in with Google Button
              ElevatedButton.icon(
                icon: const Icon(Icons.login_rounded, size: 24.0), // Replaced Image.asset with Icon
                label: const Text('Sign in with Google'),
                onPressed: () async {
                  // _authService is already available in the state class
                  try {
                    final Map<String, dynamic>? result = await _authService.signInWithGoogle();

                    if (result != null) {
                      final UserCredential? userCredential = result['userCredential'] as UserCredential?;
                      final bool isNewUser = result['isNewUser'] as bool;

                      if (userCredential != null && userCredential.user != null) {
                        print('Signed in as: ${userCredential.user!.displayName}');
                        print('Email: ${userCredential.user!.email}');
                        print('Is new user: $isNewUser');

                        if (!context.mounted) return; // Check context before navigation

                        if (isNewUser) {
                          final OnboardingService onboardingService = OnboardingService();
                          final bool hasCompletedOnboarding = await onboardingService.isOnboardingComplete();
                          if (!hasCompletedOnboarding) {
                            Navigator.pushReplacementNamed(context, '/onboarding1');
                          } else {
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        } else {
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      } else {
                        print('Google Sign-In failed: UserCredential or user is null.');
                        // TODO: Show error message to user
                      }
                    } else {
                      // Error is already printed in AuthService for most cases
                      print('Google Sign-In failed: Result from AuthService is null.');
                      // TODO: Show error message to user
                    }
                  } catch (e) {
                    print('An error occurred during Google Sign-In flow in AuthScreen: $e');
                    // TODO: Show error message to user
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.white, // Text color
                  minimumSize: const Size(double.infinity, 50), // Full width button
                ),
              ),
              const SizedBox(height: 20),

              // Or Divider
              const Row(
                children: <Widget>[
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('OR'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20),

              // Email TextField
              TextFormField(
                controller: _emailController, // Added controller
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),

              // Password TextField
              TextFormField(
                controller: _passwordController, // Added controller
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),

              // Login Button
              ElevatedButton(
                child: const Text('Login'),
                onPressed: () async { // Made onPressed async
                  final String email = _emailController.text.trim();
                  final String password = _passwordController.text.trim();

                  if (email.isEmpty || password.isEmpty) {
                    print('Email or Password field is empty.');
                    // Optionally, show a SnackBar or dialog to the user
                    return;
                  }

                  try {
                    final UserCredential? userCredential = await _authService.signInWithMasterCredentials(email, password);
                    if (userCredential != null && userCredential.user != null) {
                      print('Master user signed in: ${userCredential.user!.email}');
                      if (!context.mounted) return; // Check context before navigation
                      Navigator.pushReplacementNamed(context, '/home'); // Navigate to home
                    } else {
                      // Error is already printed in AuthService
                      print('Master login failed in AuthScreen.');
                      // TODO: Show error message to user (e.g., via SnackBar)
                    }
                  } catch (e) {
                    print('An error occurred during Master Login in AuthScreen: $e');
                    // TODO: Show error message to user
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50), // Full width button
                ),
              ),
              const SizedBox(height: 12),

              // Sign Up TextButton
              TextButton(
                child: const Text('Don\'t have an account? Sign Up'),
                onPressed: () {
                  // TODO: Navigate to Sign Up screen or show Sign Up dialog
                  print('Sign Up button pressed');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
