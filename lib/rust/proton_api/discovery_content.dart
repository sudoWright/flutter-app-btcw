// This file is automatically generated, so please do not edit it.
// Generated by `flutter_rust_bridge`@ 2.1.0.

// ignore_for_file: invalid_use_of_internal_member, unused_import, unnecessary_import

import '../frb_generated.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

class Content {
  final String title;
  final String link;
  final String description;
  final PlatformInt64 pubDate;
  final String author;
  final String category;

  const Content({
    required this.title,
    required this.link,
    required this.description,
    required this.pubDate,
    required this.author,
    required this.category,
  });

  @override
  int get hashCode =>
      title.hashCode ^
      link.hashCode ^
      description.hashCode ^
      pubDate.hashCode ^
      author.hashCode ^
      category.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Content &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          link == other.link &&
          description == other.description &&
          pubDate == other.pubDate &&
          author == other.author &&
          category == other.category;
}
