import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scholarsync/common/search_bar.dart';
import 'package:scholarsync/common/sidebar.dart';
import 'package:scholarsync/constants/icon_constants.dart';
import 'package:scholarsync/constants/image_constants.dart';
import 'package:scholarsync/features/widgets/drawer_menu.dart';
import 'package:scholarsync/main.dart';
import '../../common/text_container.dart';
import '../../theme/palette.dart';
import '../widgets/carousel.dart';
import '../widgets/image_row.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey(); // Create a global key for the Scaffold

  @override
  Widget build(BuildContext context) {
    return ref.watch(userStreamProvider).when(data: (userData) {
      return Scaffold(
        key: _scaffoldKey,
        endDrawer: const CustomDrawerMenu(),
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userData.username,
                style: const TextStyle(
                  color: PaletteLightMode.titleColor,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    IconConstants.graduationHatIcon,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      PaletteLightMode.secondaryGreenColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    'NSBM Green University',
                    style: TextStyle(
                      color: PaletteLightMode.secondaryGreenColor,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
          titleTextStyle: const TextStyle(
            color: PaletteLightMode.titleColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          centerTitle: false,
          actions: <Widget>[
            IconButton(
              icon: SvgPicture.asset(
                IconConstants.hamburgerMenuIcon,
                colorFilter: const ColorFilter.mode(
                  PaletteLightMode.secondaryGreenColor,
                  BlendMode.srcIn,
                ),
                width: 40,
                height: 40,
              ),
              tooltip: 'Menu',
              onPressed: () {
                _scaffoldKey.currentState!.openEndDrawer(); // Open the end drawer
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //searchbar
                CustomSearchBar(
                  hint: 'Search for students and clubs...',
                  onSearchSubmitted: (value) {
                    //Search funtion
                  },
                ),
                const SizedBox(
                  height: 5,
                ),

                //carousel
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    // Create a list to store the image URLs
                    List<String> imageUrlList = [];

                    final documents = snapshot.data!.docs;

                    // Extract postUrl from each document and add it to imageUrlList
                    for (final DocumentSnapshot<Map<String, dynamic>> document
                        in documents) {
                      final postUrl = document['postUrl'] as String;
                      imageUrlList.add(postUrl);
                    }

                    //return the widget containing postUrls from Firestore
                    return Carousel(
                      imageList: imageUrlList,
                    );
                  },
                ),
                const SizedBox(
                  height: 5,
                ),

                //text
                TextContainer(
                  fontText: 'Kuppi Sessions',
                  secondText: 'view all',
                  onTap: () {
                    //onTap funtion for the text
                  },
                ),
                const SizedBox(
                  height: 5,
                ),

                //imageRow
                // StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                //   stream: FirebaseFirestore.instance
                //       .collection('kuppiSessions')
                //       .snapshots(),
                //   builder: (context,
                //       AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                //           snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return const Center(
                //         child: CircularProgressIndicator(),
                //       );
                //     }

                //     if (snapshot.hasError) {
                //       return Center(
                //         child: Text('Error: ${snapshot.error}'),
                //       );
                //     }

                //     // Create a list to store the image URLs
                //     List<String> imageUrlList = [];

                //     final documents = snapshot.data!.docs;

                //     // Extract postUrl from each document and add it to imageUrlList
                //     for (final DocumentSnapshot<Map<String, dynamic>> document
                //         in documents) {
                //       final postUrl = document['imageUrl'] as String;
                //       imageUrlList.add(postUrl);
                //     }

                //     //return the widget containing postUrls from Firestore
                //     return ImageRow(
                //         containerSize: MediaQuery.of(context).size.width * 0.4,
                //         isCircle: false,
                //         imagePathList: imageUrlList);
                //   },
                // ),
                ImageRow(
                    containerSize: MediaQuery.of(context).size.width * 0.4,
                    isCircle: false,
                    imagePathList: const [
                      ImageConstants.aiesec1,
                      ImageConstants.aiesec2,
                      ImageConstants.aiesec3
                    ]),
                const SizedBox(
                  height: 5,
                ),

                //text
                TextContainer(
                  fontText: 'Clubs & Organizations',
                  secondText: 'view all',
                  onTap: () {
                    //onTap funtion for the text
                  },
                ),
                const SizedBox(
                  height: 5,
                ),

                //imageRow
                ImageRow(
                  containerSize: MediaQuery.of(context).size.width * 0.2,
                  isCircle: true,
                  imagePathList: const [
                    ImageConstants.loginBackgroundImage,
                    ImageConstants.loginBackgroundImage,
                    ImageConstants.loginBackgroundImage,
                    ImageConstants.loginBackgroundImage,
                    ImageConstants.loginBackgroundImage,
                  ],
                  textList: const [
                    'club0',
                    'club1',
                    'club2',
                    'club3',
                    'club4',
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      );
    }, error: (Object error, StackTrace stackTrace) {
      return const Scaffold(
        body: Center(
          child: Text('Error'),
        ),
      );
    }, loading: () {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }
}
