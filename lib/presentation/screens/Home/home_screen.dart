import 'package:flutter/material.dart';
import 'package:telx/config/routes/routes_names.dart';
import 'package:telx/repositories/authentication_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: ElevatedButton(onPressed: (){
       final authenticationRepository = AuthenticationRepository();
        authenticationRepository.logOut();
        Navigator.pushReplacementNamed(context, RoutesNames.authScreen);
      }, child: const Text("Logout")),),
    );
  }
}
