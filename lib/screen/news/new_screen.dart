
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:test_news/bloc/new/new_cubit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../config.dart';
import '../../model/new.dart';
import '../../bloc/bookmark/bookmark_bloc.dart';
import '../../component/small_progress_indicator.dart';
import '../../component/center_progress_indicator.dart';

class NewScreen extends StatelessWidget {
  final String tag;
  final NewModel item;

  const NewScreen({
    Key? key,
    required this.tag,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Widget emptyWidget = SizedBox.shrink();
    const TextStyle textStyle = TextStyle(fontSize: 16);
    const Duration animDuration = Duration(milliseconds: 150);
    const EdgeInsets paddingTop = EdgeInsets.only(top: Config.padding);
    final BookmarkBloc bookmarkBloc = context.read<BookmarkBloc>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Нововсть'),
        leading: IconButton(
          icon: Icon(Icons.adaptive.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),

      body: Hero(
        tag: tag,
        child: Material(
          child: Scrollbar(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  item.imageUrl != null ? CachedNetworkImage(
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.fill,
                    imageUrl: item.imageUrl!,
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        const CenterProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ) : emptyWidget,

                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Config.padding, Config.padding, Config.padding, 0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          item.title.trim(),
                          style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold,
                          ),
                        ),

                        item.description != null ? Padding(
                          padding: paddingTop,
                          child: Text(
                            item.description!.trim(),
                            style: textStyle,
                            textAlign: TextAlign.justify,
                          ),
                        ) : emptyWidget,

                        item.content != null ? Padding(
                          padding: paddingTop,
                          child: Text(
                            item.content!.trim(),
                            style: textStyle,
                            textAlign: TextAlign.justify,
                          ),
                        ) : emptyWidget,

                        Padding(
                          padding: paddingTop,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: item.author != null ? RichText(
                                  text: TextSpan(
                                    text: 'Author ',
                                    style: const TextStyle(
                                      fontSize: 16, color: Colors.black,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: item.author!.trim(),
                                        style: const TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ]
                                  ),
                                ) : emptyWidget,
                              ),

                              Expanded(
                                child: item.publishedDate != null ? Text(
                                  DateFormat(Config.pattern).format(item.publishedDate!),
                                  textAlign: TextAlign.end,
                                ) : emptyWidget,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  item.url != null ? Padding(
                    padding: paddingTop,
                    child: TextButton(
                      child: Text(item.url!, style: textStyle,),
                      onPressed: () async {
                        if (!await launchUrl(Uri.parse(item.url!))) {
                          throw 'Could not launch ${item.url!}';
                        }
                      },
                    ),
                  ) : emptyWidget,

                  const SizedBox(height: Config.padding,),

                  BlocBuilder<BookmarkBloc, BookmarkState>(
                    builder: (context, state) {
                      return AnimatedSwitcher(
                        duration: animDuration,
                        child: item.isBookmark ? ElevatedButton(
                          key: const ValueKey('remove_button'),
                          onPressed: () {
                            bookmarkBloc.add(RemoveBookmark(model: item));
                          },
                          child: AnimatedSwitcher(
                            duration: animDuration,
                            child: state is BookmarkLoadingState
                                ? const SmallProgressIndicator(
                              key: ValueKey('indicator'),
                              size: 16,
                            )
                                : const Text(
                              key: ValueKey('remove_text'),
                              'Remove from bookmark',
                              style: textStyle,
                            ),
                          ),
                        ) : ElevatedButton(
                          key: const ValueKey('add_button'),
                          onPressed: () {
                            bookmarkBloc.add(AddBookmark(model: item));
                          },
                          child: AnimatedSwitcher(
                            duration: animDuration,
                            child: state is BookmarkLoadingState
                                ? const SmallProgressIndicator(
                              key: ValueKey('indicator'),
                              size: 16,
                            )
                                : const Text(
                              key: ValueKey('add_text'),
                              'Add to bookmark',
                              style: textStyle,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
