part of 'bookmark_bloc.dart';

abstract class BookmarkState extends Equatable {
  const BookmarkState();
}

class BookmarkInitialState extends BookmarkState {
  @override
  List<Object> get props => [];
}

class BookmarkLoadingState extends BookmarkState {
  @override
  List<Object> get props => [];
}

class BookmarkLoadedState extends BookmarkState {
  final List<NewModel> data;

  const BookmarkLoadedState({required this.data});

  @override
  List<Object> get props => [data];
}

class BookmarkEmptyState extends BookmarkState {
  @override
  List<Object> get props => [];
}
