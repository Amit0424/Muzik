import 'package:android_muzik/constants/styling.dart';
import 'package:android_muzik/models/spotify_tracks_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AllCategories extends StatelessWidget {
  const AllCategories({super.key, required this.sectionItem});

  final List<SectionItem> sectionItem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: blackColor,
        surfaceTintColor: blackColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          'All Categories',
          style: appBarTitleStyle(context),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth(context) * 0.04,
            vertical: screenHeight(context) * 0.02),
        child: GridView.builder(
            itemCount: sectionItem.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // number of items per row
              crossAxisSpacing: 20.0, // horizontal space between items
              mainAxisSpacing: 20.0, // vertical space between items
              childAspectRatio: 1.0, // aspect ratio of each item
            ),
            itemBuilder: (context, index) {
              final hexColor =
                  sectionItem[index].cardRepresentation.backgroundColorHex;
              CardRepresentation cardRepresentation =
                  sectionItem[index].cardRepresentation;
              return GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(
                            int.parse(hexColor.substring(1, 7), radix: 16) +
                                0xFF000000)
                        .withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    children: [
                      Container(
                        height: screenHeight(context) * 0.15,
                        width: screenWidth(context) * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                cardRepresentation.artworkSources[0].url),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight(context) * 0.01,
                      ),
                      Text(
                        cardRepresentation.title,
                        style: TextStyle(
                          color: textHeadingColor,
                          fontSize: screenWidth(context) * 0.04,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
