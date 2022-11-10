
import 'package:flutter_bloc/flutter_bloc.dart';

class NewCubit extends Cubit<int> {
  NewCubit() : super(0);

  void changeState() => emit(state + 1);
}
