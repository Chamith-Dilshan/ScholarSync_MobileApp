import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scholarsync/common/sidebar_bloc.dart';
import 'package:scholarsync/common/sidebar_menu.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> with SingleTickerProviderStateMixin<SideBar>{
   late AnimationController _animationController;
   late StreamController<bool> isSidebarisOpendStreamController;
   late Stream<bool> isSidebarisOpendStream;
   late StreamSink<bool> isSidebarisOpendSink;
   

   final _animationDuration = const Duration(milliseconds: 500);
   
   @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration:  _animationDuration);
    isSidebarisOpendStreamController = PublishSubject<bool>();
    isSidebarisOpendStream = isSidebarisOpendStreamController.stream;
    isSidebarisOpendSink = isSidebarisOpendStreamController.sink;
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    isSidebarisOpendStreamController.close();
    isSidebarisOpendSink.close();
    super.dispose();
  }

  void onIconPressed(){
    final animationStatus = _animationController.status;
    final isAnimationComplete = animationStatus == AnimationStatus.completed;

    if (isAnimationComplete) {
      isSidebarisOpendSink.add(false);
      _animationController.reverse();
    } else {
      isSidebarisOpendSink.add(true);
      _animationController.forward();
    }
  }


  @override
  Widget build(BuildContext context) {
   final drawerWidth = MediaQuery.of(context).size.width;
   
    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebarisOpendStream,
      builder:  (context, isSidebarisOpendAsync){
        return AnimatedPositioned(
         duration: _animationDuration,
          top: 0,
          bottom: 0,
          left: isSidebarisOpendAsync.data ?? false ? 0: drawerWidth-75,
          right: isSidebarisOpendAsync.data ?? true ? 0 : -drawerWidth,
       
        child: SafeArea(
          child: Row(
            children: [
               Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: 75,
                  height: 55.9,
                  color: const Color.fromARGB(0, 76, 175, 79),
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      onIconPressed();
                    },
                    child: AnimatedIcon(
                      progress: _animationController.view,
                      icon: AnimatedIcons.menu_close,
                      color: Colors.green,
                      size: 35,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  color: const Color.fromARGB(255, 221, 221, 221),
                  child: Container(
                    color: Colors.white10,
                    child:  Column(
                      
                      children: [
                        const DrawerHeader(
                          
                          child: Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 50,
                            child: Icon(
                              Icons.perm_identity,
                              color: Colors.white,
                              size: 70,
                              ),
                              ),
                              SizedBox(height: 10,),
                              Text(
                                'DYPV Mendis',
                                style: TextStyle(
                                  fontSize: 15
                                ),
                                )
                            ],
                          ),
                        ),
                               const Divider(
                              color: Colors.black,
                              thickness: 0.5,
                              indent: 16,
                              endIndent: 16,
                            ),
                        GestureDetector(
                          onTap: (){onIconPressed();BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.myProfilePageClickedEvent);},
                          child: const MenuItems(icon: Icons.person, title:'My Profile')
                          ),
                        GestureDetector(
                          onTap: (){onIconPressed();BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.settingsPageClickedEvent);},
                          child: const MenuItems(icon: Icons.settings, title:'Settings')
                          ),
                        GestureDetector(
                          onTap: (){onIconPressed();BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.academicStaffPageClickedEvent);},
                          child: const MenuItems(icon: Icons.school, title:'Academic Staff',)
                          ),
                        GestureDetector(
                          onTap: (){onIconPressed();BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.giveFeedBackPageClickedEvent);},
                          child: const MenuItems(icon: Icons.feedback, title:'Give Feedback',)
                          ),
                        const MenuItems(icon: Icons.star, title:'Rate Us',),
                        const MenuItems(icon: Icons.logout, title:'Log out',),
                      ]
                      ),
                  ),
              ),
              ),
             
            ],
          ),
        ),
      );
      },
    );
  }
}