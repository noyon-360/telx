import 'package:flutter/material.dart';
import 'package:telx/config/routes/routes_names.dart';
import 'package:telx/repositories/authentication_repository.dart';
import 'package:telx/src/models/user.dart';

class HomeScreen extends StatelessWidget {
  final AuthenticationRepository authRepository;
  const HomeScreen({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel>(
      stream: authRepository.user,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        }
        final user = snapshot.data ?? UserModel.empty;

        if(user == UserModel.empty) {
          return const Center(child: Text('No data'),);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(user.fullName ?? "No Name"),
          ),
          body: Center(
            child: ElevatedButton(
                onPressed: () {
                  final authenticationRepository = AuthenticationRepository();
                  authenticationRepository.logOut();
                  Navigator.pushReplacementNamed(context, RoutesNames.splashScreen);
                },
                child: const Text("Logout")),
          ),
        );
      }
    );
  }
}
