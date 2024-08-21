import 'package:android_muzik/models/spotify_tracks_model.dart';
import 'package:android_muzik/widgets/loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/styling.dart';
import '../../providers/music_provider.dart';
import '../all_categories/all_categories.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final MusicProvider mp = Provider.of<MusicProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mp.browseStart == null) {
        mp.loadData();
      }
    });

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.black,
        title:
            Consumer<MusicProvider>(builder: (context, musicProvider, child) {
          if (musicProvider.browseStart == null) {
            return Text(
              'Loading...',
              style: appBarTitleStyle(context),
            );
          }
          return Text(
            musicProvider.browseStart!.title,
            style: appBarTitleStyle(context),
          );
        }),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth(context) * 0.04,
              vertical: screenHeight(context) * 0.02),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: appBarTitleStyle(context)
                        .copyWith(color: textHeadingColor),
                  ),
                  GestureDetector(
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AllCategories(
                                  sectionItem: mp.browseStart!.sectionItems)));
                    },
                    child: const Text(
                      'See More',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Color(0xFFC6C6C6),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              _categories(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categories() {
    return Consumer<MusicProvider>(builder: (context, musicProvider, child) {
      if (musicProvider.browseStart == null) {
        return Center(
          child: LoadingWidget(color: yellowColor),
        );
      }
      return GridView.builder(
        itemCount: 4,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final CardRepresentation cardRepresentation =
              musicProvider.browseStart!.sectionItems[index].cardRepresentation;
          final hexColor = cardRepresentation.backgroundColorHex;

          return GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                color: Color(int.parse(hexColor.substring(1, 7), radix: 16) +
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
                  ),
                ],
              ),
            ),
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // number of items per row
          crossAxisSpacing: 20.0, // horizontal space between items
          mainAxisSpacing: 20.0, // vertical space between items
          childAspectRatio: 1.0, // aspect ratio of each item
        ),
      );
    });
  }
}
