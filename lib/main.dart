import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickmorty/data/response/autentication.dart';
import 'package:rickmorty/domain/cubit/autentication_cubit.dart';
import 'package:rickmorty/screens/utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: "RickMorty",
      options: const FirebaseOptions(
          apiKey: "AIzaSyDIawhTnudqnMHFmEqFG5MrM6_ll20U4Ag",
          appId: "760843249410",
          messagingSenderId: "",
          projectId: "rickmorty-ed5c9"));
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) =>
                AutenticationCubit(autentication: Autentication()))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Rick and Morty',
        routes: routes,
        initialRoute: '/',
      ),
    );
  }
}
