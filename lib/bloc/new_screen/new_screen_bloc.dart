
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/new.dart';
import '../../utility/local_database.dart';

part 'new_screen_event.dart';
part 'new_screen_state.dart';

class NewScreenBloc extends Bloc<NewScreenEvent, NewScreenState> {
  final LocalDatabase localDatabase;

  NewScreenBloc({required this.localDatabase}) : super(NewScreenInitialState()) {
    on<AddToBookmark>((event, emit) async {
      emit(NewScreenLoadingState());

      final NewModel model = event.newModel;
      await localDatabase.insertNew(model);
      model.isBookmark = true;

      emit(NewScreenSuccessState());
    });

    on<RemoveFromBookmark>((event, emit) async {
      emit(NewScreenLoadingState());

      final NewModel model = event.newModel;
      await localDatabase.deleteNew(model);
      model.isBookmark = false;

      emit(NewScreenSuccessState());
    });
  }
}
