import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wallet/scenes/components/discover/proton.feeditem.dart';
import 'package:wallet/helper/extension/stream.controller.dart';
import 'package:wallet/helper/logger.dart';
import 'package:wallet/scenes/core/view.navigatior.identifiers.dart';
import 'package:wallet/scenes/core/viewmodel.dart';
import 'package:wallet/scenes/discover/discover.coordinator.dart';
import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' as http;

abstract class DiscoverViewModel extends ViewModel<DiscoverCoordinator> {
  DiscoverViewModel(super.coordinator);
  late List<ProtonFeedItem> protonFeedItems = [];
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
    protonFeedItems = await ProtonFeedItem.loadJsonFromAsset();

    EasyLoading.dismiss();
    datasourceChangedStreamController.addSafe(this);
  }

  @override
  Stream<ViewModel> get datasourceChanged =>
      datasourceChangedStreamController.stream;

  @override
  Future<void> move(NavID to) async {}

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
