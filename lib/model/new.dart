
import 'package:test_news/bloc/new/new_cubit.dart';

class NewModel {
  final int? id;
  final String title;
  bool isBookmark;
  String? url;
  String? author;
  String? content;
  String? imageUrl;
  String? description;
  DateTime? publishedDate;
  NewCubit stateManager;

  NewModel({
    required this.url, required this.title, required this.author,
    required this.content, required this.imageUrl, required this.description,
    required this.publishedDate, required this.stateManager,
    required this.isBookmark, this.id,
  });

  factory NewModel.fromJson(Map<String, dynamic> json, {bool? isBookmark, int? id}) {
    String? pubDate = json['publishedAt'];
    DateTime? publishedDate;
    if (pubDate != null) {
      publishedDate = DateTime.parse(pubDate).toLocal();
    }

    return NewModel(
      url: json['url'], title: json['title'], author: json['author'],
      content: json['content'], imageUrl: json['urlToImage'],
      description: json['description'], publishedDate: publishedDate,
      stateManager: NewCubit(), isBookmark: isBookmark ?? false, id: id ?? json['id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'title': title,
      'author': author,
      'content': content,
      'urlToImage': imageUrl,
      'description': description,
      'publishedAt': publishedDate?.toIso8601String(),
    };
  }
}
