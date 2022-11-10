import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_news/bloc/new/new_cubit.dart';

import '../../config.dart';
import '../../model/new.dart';
import '../../bloc/bookmark/bookmark_bloc.dart';
import '../../component/new_component.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Закладки'),
      ),
      body: BlocBuilder<BookmarkBloc, BookmarkState>(
        builder: (context, state) {
          if (state is BookmarkLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is BookmarkLoadedState) {
            final List<NewModel> data = state.data;

            return ListView.builder(
              padding: const EdgeInsets.all(Config.padding),
              itemCount: data.length,
              itemBuilder: (context, index) => BlocProvider<NewCubit>(
                create: (context) => data[index].stateManager,
                child: NewComponent(
                  item: data[index],
                  index: index,
                  prefix: 'bookmark_',
                ),
              ),
            );
          } else if (state is BookmarkEmptyState) {
            return const Center(
              child: Text('Bookmarks is empty. You can add new here'),
            );
          }

          return const Center(
            child: Text('Bookmarks'),
          );
        },
      ),
    );
  }
}
