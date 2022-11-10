part of 'bookmark_bloc.dart';

abstract class BookmarkEvent extends Equatable {
  const BookmarkEvent();
}

class LoadBookmarks extends BookmarkEvent {
  @override
  List<Object?> get props => [];
}

class AddBookmark extends BookmarkEvent {
  final NewModel model;

  const AddBookmark({required this.model});

  @override
  List<Object?> get props => [model];
}

class RemoveBookmark extends BookmarkEvent {
  final NewModel model;

  const RemoveBookmark({required this.model});

  @override
  List<Object?> get props => [model];
}
