class BrowseStart {
  final String typename;
  final String uri;
  final List<SectionItem> sectionItems;
  final String title;

  BrowseStart({
    required this.typename,
    required this.uri,
    required this.sectionItems,
    required this.title,
  });

  factory BrowseStart.fromJson(Map<String, dynamic> json) {
    var itemsJsonArray =
        json['sections']['items'][0]['sectionItems']['items'] as List;
    var sectionItems =
        itemsJsonArray.map((item) => SectionItem.fromJson(item)).toList();

    return BrowseStart(
      typename: json['__typename'],
      uri: json['uri'],
      title: json['sections']['items'][0]['data']['title']['transformedLabel'],
      sectionItems: sectionItems,
    );
  }
}

class SectionItem {
  final String uri;
  final CardRepresentation cardRepresentation;

  SectionItem({
    required this.uri,
    required this.cardRepresentation,
  });

  factory SectionItem.fromJson(Map<String, dynamic> json) {
    return SectionItem(
      uri: json['uri'],
      cardRepresentation:
          CardRepresentation.fromJson(json['content']['data']['data']),
    );
  }
}

class CardRepresentation {
  final String title;
  final List<ArtworkSource> artworkSources;
  final String backgroundColorHex;

  CardRepresentation({
    required this.title,
    required this.artworkSources,
    required this.backgroundColorHex,
  });

  factory CardRepresentation.fromJson(Map<String, dynamic> json) {
    var artworkJsonArray =
        json['cardRepresentation']['artwork']['sources'] as List;
    var artworkSources =
        artworkJsonArray.map((item) => ArtworkSource.fromJson(item)).toList();

    return CardRepresentation(
      title: json['cardRepresentation']['title']['transformedLabel'],
      artworkSources: artworkSources,
      backgroundColorHex: json['cardRepresentation']['backgroundColor']['hex'],
    );
  }
}

class ArtworkSource {
  final String url;
  final int width;
  final int height;

  ArtworkSource({required this.url, required this.width, required this.height});

  factory ArtworkSource.fromJson(Map<String, dynamic> json) {
    return ArtworkSource(
      url: json['url'],
      width: json['width'],
      height: json['height'],
    );
  }
}

BrowseStart parseBrowseStart(Map<String, dynamic> json) {
  return BrowseStart.fromJson(json['data']['browseStart']);
}
