import 'package:flutter/material.dart';
import 'package:frontend/view/auth/widgets/widgets.dart';
import 'package:frontend/view_model/auth_view_model.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthViewModel authViewModel = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In Page'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Sign In Page'),
              const SizedBox(height: 20),
              CustomTextField(
                  controller: authViewModel.emailController,
                  placeHolder: 'Email'),
              const SizedBox(height: 20),
              CustomTextField(
                  controller: authViewModel.passwordController,
                  placeHolder: 'Password'),
              // Forgot password button
              TextButton(
                onPressed: () {},
                child: const Text('Forgot Password'),
              ),
              // Go to register page button
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text('Sign Up'),
              ),
              ElevatedButton(
                onPressed: () {
                  authViewModel.signIn();
                },
                child: const Text('Sign In'),
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
