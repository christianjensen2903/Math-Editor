import 'package:flutter/material.dart';
import 'package:frontend/view_model/auth_view_model.dart';
import 'package:provider/provider.dart';
import 'package:frontend/view/auth/widgets/widgets.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up Page'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Sign Up Page'),
              const SizedBox(height: 20),
              CustomTextField(
                  controller: authViewModel.emailController,
                  placeHolder: 'Email'),
              const SizedBox(height: 20),
              CustomTextField(
                  controller: authViewModel.passwordController,
                  placeHolder: 'Password'),
              const SizedBox(height: 20),
              CustomTextField(
                  controller: authViewModel.confirmPasswordController,
                  placeHolder: 'Confirm Password'),
              // Go to Sign Up page button
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
                child: const Text('Sign In'),
              ),
              ElevatedButton(
                onPressed: () {
                  authViewModel.register();
                },
                child: const Text('Sign Up'),
              ),
              if (authViewModel.isError)
                Text(
                  authViewModel.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
