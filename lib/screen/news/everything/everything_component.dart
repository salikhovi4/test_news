import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:test_news/bloc/new/new_cubit.dart';

import '../../../config.dart';
import '../../../model/new.dart';
import '../../../bloc/everything/everything_cubit.dart';
import '../../../component/new_component.dart';

class EverythingComponent extends StatelessWidget {
  const EverythingComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PagingController<int, NewModel> pagingController = context
        .read<EverythingCubit>()
        .pagingController;

    return Scrollbar(
      child: RefreshIndicator(
        onRefresh: () => Future.sync(() => pagingController.refresh()),
        child: PagedListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(Config.padding),
          pagingController: pagingController,
          builderDelegate: PagedChildBuilderDelegate<NewModel>(
            itemBuilder: (context, item, index) => BlocProvider<NewCubit>(
              create: (context) => item.stateManager,
              child: NewComponent(
                item: item, index: index, prefix: 'everything_',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
