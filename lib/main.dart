import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screen/home.dart';
import 'bloc/home/home_cubit.dart';
import 'bloc/bookmark/bookmark_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookmarkBloc>(
      create: (context) => BookmarkBloc()..add(LoadBookmarks()),
      child: MaterialApp(
        title: 'Test news',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider<HomeCubit>(
          create: (_) => HomeCubit(),
          child: const Home(),
        ),
      ),
    );
  }
}
