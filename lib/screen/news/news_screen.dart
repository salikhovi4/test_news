
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'everything/everything_component.dart';
import 'top_headlines/top_headlines_component.dart';
import '../../model/new.dart';
import '../../repository/news.dart';
import '../../bloc/headlines/headlines_cubit.dart';
import '../../bloc/everything/everything_cubit.dart';
import '../../utility/local_database.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final LocalDatabase _localDatabase = LocalDatabase();
  final NewsRepository _newsRepository = NewsRepository();
  final PagingController<int, NewModel> _headlinesController = PagingController(
    firstPageKey: 1,
  );
  final PagingController<int, NewModel> _everythingController =
    PagingController(firstPageKey: 1,);

  @override
  void initState() {
    _localDatabase.initialize();

    super.initState();
  }

  @override
  void dispose() {
    _headlinesController.dispose();
    _everythingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Top news'),
          bottom: const TabBar(
            tabs: <Tab>[
              Tab(
                icon: Icon(Icons.list_alt),
              ),
              Tab(
                icon: Icon(Icons.view_list),
              ),
            ],
          ),
        ),
        body: MultiBlocProvider(
          providers: <BlocProvider>[
            BlocProvider<HeadlinesCubit>(
              create: (context) => HeadlinesCubit(
                localDatabase: _localDatabase,
                newsRepository: _newsRepository,
                pagingController: _headlinesController,
              ),
            ),
            BlocProvider<EverythingCubit>(
              create: (context) => EverythingCubit(
                newsRepository: _newsRepository,
                pagingController: _everythingController,
              ),
            ),
          ],
          child: const TabBarView(
            children: <Widget>[
              TopHeadlinesComponent(),

              EverythingComponent(),
            ],
          ),
        ),
      ),
    );
  }
}
