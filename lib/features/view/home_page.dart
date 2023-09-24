import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scholarsync/common/search_bar.dart';
import 'package:scholarsync/constants/icon_constants.dart';
import 'package:scholarsync/features/view/club_profile_page.dart';
import 'package:scholarsync/features/view/kuppi_page.dart';
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
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('posts').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text('No images available.');
                    }
                    // Extract image URLs from Firestore documents
                    List<String> imageUrls = snapshot.data!.docs.map((doc) => doc['postUrl'] as String).toList();
                    
                    // Render the ImageRow widget with the real-time image URLs
                    return Carousel(
                      imageList: imageUrls,
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
                    Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const KuppiPage()));
                  },
                ),
                const SizedBox(
                  height: 5,
                ),

                //kuppi Section
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('kuppiSessions').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text('No images available.');
                    }
                    // Extract image URLs from Firestore documents
                    List<String> imageUrls = snapshot.data!.docs.map((doc) => doc['imageUrl'] as String).toList();
                    
                    // Render the ImageRow widget with the real-time image URLs
                    return ImageRow(
                      containerSize: MediaQuery.of(context).size.width * 0.4,
                      isCircle: false,
                      imagePathList: imageUrls, // Use the list of image URLs
                    );
                  },
                ),
                const SizedBox(
                  height: 5,
                ),

                //text
                TextContainer(
                  fontText: 'Clubs & Organizations',
                  secondText: 'view all',
                  onTap: () {
                    Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const ClubProfilePage()));
                  },
                ),
                const SizedBox(
                  height: 5,
                ),

                // Clubs
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('clubs').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text('No images available.');
                    }
                    // Extract image URLs from Firestore documents
                    List<String> imageUrls = snapshot.data!.docs.map((doc) => doc['profileImageURL'] as String).toList();
                    
                    // Render the ImageRow widget with the real-time image URLs
                    return ImageRow(
                      containerSize: MediaQuery.of(context).size.width * 0.2,
                      isCircle: true,
                      imagePathList: imageUrls, // Use the list of image URLs
                      textList: const [
                        'InnovaTech Club',
                        'HackShield Club',
                      ],
                    );
                  },
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
