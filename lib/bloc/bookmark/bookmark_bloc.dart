
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_news/bloc/new/new_cubit.dart';

import '../../model/new.dart';
import '../../utility/local_database.dart';

part 'bookmark_event.dart';
part 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  BookmarkBloc() : super(BookmarkInitialState()) {
    late List<NewModel> data;
    final LocalDatabase localDatabase = LocalDatabase();

    on<LoadBookmarks>((event, emit) async {
      emit(BookmarkLoadingState());

      await localDatabase.initialize();
      data = await localDatabase.getNewsInList();

      if (data.isEmpty) {
        emit(BookmarkEmptyState());
      } else {
        emit(BookmarkLoadedState(data: data));
      }
    });

    on<AddBookmark>((event, emit) async {
      emit(BookmarkLoadingState());

      final NewModel addModel = event.model;
      await localDatabase.insertNew(addModel);
      addModel.isBookmark = true;
      data.insert(0, addModel);

      emit(BookmarkLoadedState(data: data));
    });

    on<RemoveBookmark>((event, emit) async {
      emit(BookmarkLoadingState());

      final NewModel removeModel = event.model;
      data = data.where((model) => model.title != removeModel.title).toList();
      await localDatabase.deleteNew(removeModel);
      removeModel.isBookmark = false;

      if (data.isEmpty) {
        emit(BookmarkEmptyState());
      } else {
        emit(BookmarkLoadedState(data: data));
      }
    });
  }
}
