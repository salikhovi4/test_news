
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../config.dart';
import '../../model/new.dart';
import '../../repository/news.dart';

class EverythingCubit extends Cubit<int> {
  final String? query;
  final NewsRepository newsRepository;
  final PagingController<int, NewModel> pagingController;

  EverythingCubit({
    required this.newsRepository, required this.pagingController, this.query,
  }) : super(0) {
    pagingController.addPageRequestListener(_fetchPage);
  }

  Future<void> _fetchPage(int pageKey) async {
    final Map<String, dynamic> response = await newsRepository
        .getEverything(pageKey, query: query);

    if (response['isError']) {
      pagingController.error = response['error'];
    } else {
      final List<NewModel> data = response['data'];
      final bool isLastPage = data.length < Config.pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(data);
      } else {
        pagingController.appendPage(data, pageKey + 1);
      }
    }
  }
}
