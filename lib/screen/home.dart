
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'news/news_screen.dart';
import 'bookmarks/bookmarks_screen.dart';
import '../bloc/home/home_cubit.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeCubit homeCubit = context.read<HomeCubit>();

    return Scaffold(
      body: BlocBuilder<HomeCubit, int>(
        builder: (context, state) {
          return IndexedStack(
            index: state,
            children: const <Widget>[
              NewsScreen(),

              BookmarksScreen(),
            ],
          );
        },
      ),

      bottomNavigationBar: BlocBuilder<HomeCubit, int>(
        builder: (context, state) {
          return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt),
                label: 'Новости',
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_outline),
                label: 'Закладки',
              ),
            ],
            currentIndex: state,
            onTap: (int index) {
              homeCubit.changeIndex(index);
            },
          );
        },
      ),
    );
  }
}
