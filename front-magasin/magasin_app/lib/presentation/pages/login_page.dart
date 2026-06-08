import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import 'home_page.dart';

class LoginPage extends StatelessWidget {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Login")),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: BlocConsumer<AuthBloc, AuthState>(

          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HomePage()),
              );
            }
          },

          builder: (context, state) {

            return Column(
              children: [

                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: "Email"),
                ),

                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),

                SizedBox(height: 20),

                if (state is AuthLoading)
                  CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        LoginEvent(
                          emailController.text,
                          passwordController.text,
                        ),
                      );
                    },
                    child: Text("Login"),
                  ),

                if (state is AuthFailure)
                  Text(state.message, style: TextStyle(color: Colors.red)),

              ],
            );
          },
        ),
      ),
    );
  }
}