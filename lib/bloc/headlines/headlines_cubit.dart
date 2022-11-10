
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../config.dart';
import '../../model/new.dart';
import '../../model/new_equatable.dart';
import '../../utility/local_database.dart';
import '../../repository/news.dart';

class HeadlinesCubit extends Cubit<int> {
  final String? category;
  final LocalDatabase localDatabase;
  final NewsRepository newsRepository;
  final PagingController<int, NewModel> pagingController;

  HeadlinesCubit({
    required this.pagingController, required this.newsRepository, this.category,
    required this.localDatabase,
  }) : super(0) {
    pagingController.addPageRequestListener(_fetchPage);
    localDatabase.initialize();

    _refreshComponentsRepeat();
  }

  Future<void> _fetchPage(int pageKey) async {
    final Map<String, dynamic> response = await newsRepository
        .getHeadlinesModels(pageKey, category: category);

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

  Future<void> _refreshComponentsRepeat() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 5));
      final List<NewModel>? data = pagingController.itemList;
      if (data != null) {
        await _refreshData(data);
      }
    }
  }

  Future<void> _refreshData(List<NewModel> data) async {
    for (final NewModel model in data) {
      newsRepository.getNewByQuery(model.title).then((response) {
        if (!response['isError']) {
          final List<NewModel> models = response['data'];
          if (models.isNotEmpty) {
            final NewModel newModel = models[0];
            final NewModelEquatable modelEquatable = _getNewConstModel(model);
            final NewModelEquatable newModelEquatable = _getNewConstModel(newModel);
            if (modelEquatable != newModelEquatable) {
              model.url = newModel.url;
              model.author = newModel.author;
              model.content = newModel.content;
              model.imageUrl = newModel.imageUrl;
              model.description = newModel.description;
              model.publishedDate = newModel.publishedDate;
              if (!model.stateManager.isClosed) {
                model.stateManager.changeState();
              }
              if (model.isBookmark) {
                localDatabase.updateNew(model);
              }
            }
          }
        }
      });
    }
  }

  NewModelEquatable _getNewConstModel(NewModel model) {
    return NewModelEquatable(
      url: model.url, title: model.title, author: model.author,
      content: model.content, imageUrl: model.imageUrl,
      description: model.description, publishedDate: model.publishedDate,
    );
  }
}
