import 'package:android_muzik/screens/profile_screen/providers/profile_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/styling.dart';
import '../../models/spotify_tracks_model.dart';
import '../../providers/music_provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileProvider profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final MusicProvider mp = Provider.of<MusicProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth(context) * 0.04,
              vertical: screenHeight(context) * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight(context) * 0.04,
              ),
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        const AssetImage('assets/images/jpgs/music_symbol.jpg'),
                    foregroundImage: CachedNetworkImageProvider(
                        profileProvider.profileModelMap.profileUrl),
                    radius: screenWidth(context) * 0.05,
                  ),
                  SizedBox(
                    width: screenWidth(context) * 0.06,
                  ),
                  Text(
                    'Search',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenHeight(context) * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenHeight(context) * 0.02,
              ),
              TextField(
                enableSuggestions: true,
                maxLines: 1,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {},
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  hintText: 'What do you want to listen to?',
                  hintStyle: const TextStyle(
                    color: Color(0xff535353),
                    fontWeight: FontWeight.bold,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_sharp,
                    color: Color(0xff535353),
                    size: 35,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide.none,
                  ),
                ),
                cursorColor: const Color(0xff535353),
              ),
              SizedBox(height: screenHeight(context) * 0.02),
              Text(
                'Start browsing',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenHeight(context) * 0.02,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight(context) * 0.02),
              GridView.builder(
                itemCount: 4,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // number of items per row
                    crossAxisSpacing: 20.0,
                    // horizontal space between items
                    mainAxisSpacing: 20.0,
                    // vertical space between items
                    childAspectRatio: 1.0,
                    mainAxisExtent: screenHeight(context) *
                        0.07 // aspect ratio of each item
                    ),
                itemBuilder: (context, index) {
                  final CardRepresentation cardRepresentation =
                      mp.browseStart!.sectionItems[index].cardRepresentation;
                  final hexColor = cardRepresentation.backgroundColorHex;
                  return Container(
                    decoration: BoxDecoration(
                      color: Color(
                          int.parse(hexColor.substring(1, 7), radix: 16) +
                              0xFF000000),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            cardRepresentation.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth(context) * 0.04,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -6,
                          right: -6,
                          child: Transform.rotate(
                            angle: 25 * 3.1415927 / 180,
                            child: Container(
                              height: screenWidth(context) * 0.135,
                              width: screenWidth(context) * 0.135,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      cardRepresentation.artworkSources[0].url),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: screenHeight(context) * 0.05),
              Text(
                'Explore your genres',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenHeight(context) * 0.02,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight(context) * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
