import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wallet/helper/logger.dart';
import 'package:wallet/scenes/core/view.navigatior.identifiers.dart';
import 'package:wallet/scenes/core/viewmodel.dart';
import 'package:wallet/scenes/discover/discover.coordinator.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

class ProtonFeedItem {
  String title;
  String pubDate;
  String link;
  String description;
  String category;
  String author;
  String coverImage;

  ProtonFeedItem({
    required this.title,
    required this.pubDate,
    required this.link,
    required this.description,
    required this.category,
    required this.author,
    this.coverImage = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'link': link,
      'description': description,
      'pubDate': pubDate,
      'author': author,
      'coverImage': coverImage,
      'category': category,
    };
  }

  factory ProtonFeedItem.fromJson(Map<String, dynamic> json) {
    return ProtonFeedItem(
      title: json['title'],
      link: json['link'],
      description: json['description'],
      pubDate: json['pubDate'],
      author: json['author'],
      coverImage: json['coverImage'],
      category: json['category'],
    );
  }

  static Future<List> loadJsonFromAsset() async {
    String jsonString = await rootBundle.loadString('assets/custom_discovers.json');
    return jsonDecode(jsonString);
  }
}

abstract class DiscoverViewModel extends ViewModel<DiscoverCoordinator> {
  DiscoverViewModel(super.coordinator);

  List<ProtonFeedItem> protonFeedItems = [];
}

class DiscoverViewModelImpl extends DiscoverViewModel {
  DiscoverViewModelImpl(super.coordinator);

  final datasourceChangedStreamController =
      StreamController<DiscoverViewModel>.broadcast();

  @override
  void dispose() {
    datasourceChangedStreamController.close();
  }

  @override
  Future<void> loadData() async {
    EasyLoading.show(
        status: "loading content..", maskType: EasyLoadingMaskType.black);
    List discoverJsonContents = await ProtonFeedItem.loadJsonFromAsset();
    for (Map<String, dynamic> discoverJsonContent in discoverJsonContents){
      protonFeedItems.add(ProtonFeedItem.fromJson(discoverJsonContent));
    }
    EasyLoading.dismiss();
    datasourceChangedStreamController.add(this);
  }

  @override
  Stream<ViewModel> get datasourceChanged =>
      datasourceChangedStreamController.stream;

  @override
  void move(NavigationIdentifier to) {}

  Future<void> loadFeed() async {
    try {
      final response = await http.get(Uri.parse('https://proton.me/blog/feed'));
      if (response.statusCode == 200) {
        parseFeed(response.body);
      } else {
        throw Exception('Failed to load RSS feed');
      }
    } catch (e) {
      logger.e(e.toString());
    }
  }

  void parseFeed(String responseBody) {
    final document = xml.XmlDocument.parse(responseBody);
    final items = document.findAllElements('item');
    for (var item in items) {
      protonFeedItems.add(ProtonFeedItem(
        title: _findElementOrDefault(item, 'title', "Default title"),
        pubDate: _findElementOrDefault(item, 'pubDate', "Default pubDate"),
        link: _findElementOrDefault(item, 'link', "Default link"),
        description:
            _findElementOrDefault(item, 'description', "Default description"),
        category: _findElementOrDefault(item, 'category', "Default category"),
        author: _findElementOrDefault(item, 'author', "Default author"),
      ));
    }
  }

  String _findElementOrDefault(
      xml.XmlElement item, String tagName, String defaultValue) {
    try {
      var element = item.findElements(tagName).single;
      return element.innerText.trim().isEmpty
          ? defaultValue
          : element.innerText;
    } catch (e) {
      logger.e(e.toString());
      return defaultValue;
    }
  }
}
