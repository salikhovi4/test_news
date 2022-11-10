
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../config.dart';
import '../../../model/new.dart';
import '../../../bloc/new/new_cubit.dart';
import '../../../bloc/headlines/headlines_cubit.dart';
import '../../../component/new_component.dart';

class TopHeadlinesComponent extends StatelessWidget {
  const TopHeadlinesComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HeadlinesCubit headlinesCubit = context.read<HeadlinesCubit>();

    return Scrollbar(
      child: PagedListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(Config.padding),
        pagingController: headlinesCubit.pagingController,
        builderDelegate: PagedChildBuilderDelegate<NewModel>(
          itemBuilder: (context, item, index) => BlocProvider<NewCubit>(
            create: (context) => item.stateManager,
            child: NewComponent(item: item, index: index, prefix: 'headlines_',),
          ),
        ),
      ),
    );
  }
}
