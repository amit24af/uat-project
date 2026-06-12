import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:uat_project/feature/auth/data/firebase_auth_repo.dart';
import 'package:uat_project/feature/auth/presentation/components/loading.dart';
import 'package:uat_project/feature/auth/presentation/cubits/auth_states.dart';
import 'package:uat_project/feature/search/data/firebase_search_repo.dart';

import 'package:uat_project/feature/themes/theme_cubit.dart';
import 'package:uat_project/firebase_options.dart';

import 'feature/auth/presentation/cubits/auth_cubit.dart';
import 'feature/auth/presentation/pages/auth_page.dart';
import 'feature/home/presentation/pages/home_page.dart';
import 'feature/post/data/firebase_repository.dart';
import 'feature/post/presentation/cubits/post_cubit.dart';
import 'feature/profile/data/firebase_profile_repo.dart';
import 'feature/profile/presentation/cubits/profile_cubit.dart';
import 'feature/search/presentation/cubits/search_cubit.dart';
import 'feature/storage/data/firebase_storage_repo.dart';


void main() async{
  await dotenv.load(fileName: ".env");
  //firebase setup
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //run app
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  MyApp({super.key});
  final firebaseAuthRepo = FirebaseAuthRepo();
  final firebaseProfileRepo = FirebaseProfileRepo();
  final firebaseStorageRepo = FirebaseStorageRepo();
  final firebasePostRepo = FirebasePostRepo();
  final firebaseSearchRepo = FirebaseSearchRepo();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
        ),
        BlocProvider(
          create: (context) => ProfileCubit(profileRepo: firebaseProfileRepo, storageRepo: firebaseStorageRepo),
        ),
        BlocProvider(
          create: (context) => PostCubit(postRepo: firebasePostRepo, storageRepo: firebaseStorageRepo),
        ),
        BlocProvider(
          create: (context) => SearchCubit(searchRepo: firebaseSearchRepo),
        ),
        BlocProvider(
          create: (context) => ThemeCubit()
        )
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, currentTheme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: currentTheme,
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
      )
    );
  }
}

