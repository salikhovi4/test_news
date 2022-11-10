
import 'package:equatable/equatable.dart';

class NewModelEquatable extends Equatable {
  final String title;
  final String? url;
  final String? author;
  final String? content;
  final String? imageUrl;
  final String? description;
  final DateTime? publishedDate;

  const NewModelEquatable({
    required this.url, required this.title, required this.author,
    required this.content, required this.imageUrl, required this.description,
    required this.publishedDate,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    title, url, author, content, content, imageUrl, description, publishedDate,
  ];
}