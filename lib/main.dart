import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:foto_share/content/mis_fotos/bloc/my_content_bloc.dart';
import 'package:foto_share/home/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'content/agregar/bloc/create_bloc.dart';
import 'content/espera/bloc/pending_bloc.dart';
import 'login/bloc/auth_bloc.dart';
import 'login/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()..add(VerifyAuthEvent())),
        BlocProvider(
            create: (context) =>
                PendingBloc()..add(GetAllMyDisabledFotosEvent())),
        BlocProvider(
            create: (context) => MyContentBloc()..add(GetAllMyFotosEvent())),
        BlocProvider(create: (context) => CreateBloc())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Intente autenticarse..."),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthSuccessState) {
            return HomePage();
          } else if (state is AuthErrorState || state is SignOutSuccessState) {
            return LoginPage();
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
