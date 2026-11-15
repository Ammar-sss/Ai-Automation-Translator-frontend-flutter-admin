import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_translater_admin/feature/sitting/presentation/controller/sitting_cubit.dart';

class MyApp extends StatelessWidget {
  final GoRouter router;
  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SittingCubit, SittingState>(
      builder: (context, state) {
        final String? font = state.fontFamily == 'Default'
            ? null
            : state.fontFamily;

        return MaterialApp.router(
          title: "Smart Translator Admin",
          debugShowCheckedModeBanner: false,
          themeMode: state.themeMode,
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            fontFamily: font,
            colorSchemeSeed: Colors.blue,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            fontFamily: font,
            colorSchemeSeed: Colors.blue,
          ),
          routerConfig: router,
        );
      },
    );
  }
}
