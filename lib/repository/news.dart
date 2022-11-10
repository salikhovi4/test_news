
import 'dart:developer';

import 'package:test_news/model/new.dart';

import '../api.dart';
import '../config.dart';
import '../utility/local_database.dart';

class NewsRepository {
  final LocalDatabase localDatabase = LocalDatabase();

  Future<Map<String, dynamic>> getHeadlinesModels(int pageKey, {
    String? category, int? pageSize,
  }) async {
    return await _fetchData(Api.getHeadlines(
      page: pageKey,
      category: category,
      pageSize: pageSize ?? Config.pageSize,
    ));
  }

  Future<Map<String, dynamic>> getEverything(int pageKey, {
    String? query, int? pageSize,
  }) async {
    return _fetchData(Api.getEverything(
      page: pageKey,
      query: query,
      pageSize: pageSize ?? Config.pageSize,
    ));
  }

  Future<Map<String, dynamic>> getNewByQuery(String query, {
    String? category,
  }) async {
    return _fetchData(Api.getNewByQuery(
      query: query,
      category: category,
    ));
  }

  Future<Map<String, dynamic>> _fetchData(Future<Map<dynamic, dynamic>> fetchFunction) async {
    await localDatabase.initialize();
    final Map<String, NewModel> bookmarks = await localDatabase.getNewsInMap();
    late bool isError;
    String error = '';
    Iterable<NewModel> data = [];

    try {
      final Map<dynamic, dynamic> response = await fetchFunction;

      if (response['status'] == 'ok') {
        isError = false;
        final List<dynamic> articles = response['articles'];
        if (articles.isNotEmpty) {
          data = articles.map((json) {
            final String title = json['title'];
            if (bookmarks.containsKey(title)) {
              return NewModel.fromJson(
                json, isBookmark: true, id: bookmarks[title]!.id,
              );
            }

            return NewModel.fromJson(json);
          });
        }
      } else {
        isError = true;
        error = response['message'];
        log(
          'HeadlinesRepository.getHeadlinesModels: code {${response['code']}}, '
              'message {${response['message']}}',
          name: Config.appName,
        );
      }

    } catch (err) {
      isError = true;
      error = err.toString();
      log(
        'HeadlinesRepository.getHeadlinesModels: {$err}',
        name: Config.appName,
      );
    }

    return {
      'data': data.toList(),
      'error': error,
      'isError': isError,
    };
  }
}
