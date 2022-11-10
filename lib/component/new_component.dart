
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../config.dart';
import '../model/new.dart';
import '../bloc/new/new_cubit.dart';
import '../screen/news/new_screen.dart';

class NewComponent extends StatelessWidget {
  final int index;
  final String prefix;
  final NewModel item;

  const NewComponent({
    Key? key,
    required this.item,
    required this.index,
    required this.prefix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(bottom: Config.padding),
      elevation: 5,
      child: BlocBuilder<NewCubit, int>(
        builder: (context, state) {
          return Stack(
            children: <Widget>[
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Config.padding,
                ),
                title: Text(item.title),
                subtitle: item.publishedDate != null
                    ? Text(DateFormat(Config.pattern).format(item.publishedDate!))
                    : const Text(''),
                trailing: Hero(
                  tag: '${prefix}tag-$index',
                  child: const Icon(Icons.arrow_forward_ios),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NewScreen(
                      item: item, tag: '${prefix}tag-$index',
                    ),
                  ));
                },
              ),

              Positioned(
                right: 15,
                bottom: 5,
                child: item.isBookmark
                    ? const Icon(Icons.bookmark, size: 14,)
                    : const Text(''),
              ),
            ],
          );
        },
      ),
    );
  }
}
