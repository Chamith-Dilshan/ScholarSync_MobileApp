import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scholarsync/common/nav_bar.dart';
import 'package:scholarsync/common/sidebar_bloc.dart';
import 'package:scholarsync/common/sidebar.dart';

class SidebarLayout extends StatelessWidget {
  const SidebarLayout({super.key, required Scaffold child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider <NavigationBloc>(
            create: (context) => NavigationBloc(),
            child:  Stack(
              children:  [
                BlocBuilder<NavigationBloc, NavigationStates>(
                  builder: (context, navigationState) {
                return navigationState as Widget;
              },
                ),
                const SideBar(),
              ],
            ),
          ),
         bottomNavigationBar: NavBar(
          onItemSelected: (int index) {
            // Handle navigation or actions based on the selected index
            // For example
          },
        ),
    );
  }
}