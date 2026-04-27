import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uat_project/feature/auth/data/firebase_auth_repo.dart';
import 'package:uat_project/feature/auth/presentation/components/loading.dart';
import 'package:uat_project/feature/auth/presentation/cubits/auth_states.dart';
import 'package:uat_project/feature/auth/presentation/pages/login_page.dart';
import 'package:uat_project/firebase_options.dart';

import 'feature/auth/presentation/cubits/auth_cubit.dart';
import 'feature/auth/presentation/pages/auth_page.dart';
import 'feature/auth/presentation/pages/register_page.dart';
import 'feature/home/presentation/pages/home_page.dart';

void main() async{
  //firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //run app
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  MyApp({super.key});
  final firebaseAuthRepo = FirebaseAuthRepo();


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => AuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: BlocConsumer<AuthCubit, AuthState>(
              builder: (context, state){
                print(state);

                if(state is Unauthenticated){
                  return const AuthPage();
                }
                if(state is Authenticated){
                  return const HomePage();
                } else {
                  return LoadingScreen();
                }

              }, listener: (context, state){
                if(state is AuthError){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message),));
                }
          }),
        ),
    );
  }
}


