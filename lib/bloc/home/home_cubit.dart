
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<int> {
  final int? initialIndex;

  HomeCubit({this.initialIndex}) : super(initialIndex ?? 0);

  void changeIndex(int index) => emit(index);
}
