part of 'new_screen_bloc.dart';

abstract class NewScreenEvent extends Equatable {
  const NewScreenEvent();
}

class AddToBookmark extends NewScreenEvent {
  final NewModel newModel;

  const AddToBookmark({required this.newModel});

  @override
  List<Object?> get props => [newModel];
}

class RemoveFromBookmark extends NewScreenEvent {
  final NewModel newModel;

  const RemoveFromBookmark({required this.newModel});

  @override
  List<Object?> get props => [newModel];
}
