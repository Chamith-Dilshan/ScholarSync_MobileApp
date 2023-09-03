// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
//import 'package:mod_customized_sidebar/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:scholarsync/features/view/home_page.dart';
import 'package:scholarsync/features/view/my_profile_page.dart';
import 'package:scholarsync/features/view/settings_page.dart';
import 'package:scholarsync/features/view/academic_staff_page.dart';
import 'package:scholarsync/features/view/give_feedback.dart';

enum NavigationEvents {
  myProfilePageClickedEvent,
  settingsPageClickedEvent,
  academicStaffPageClickedEvent,
  giveFeedBackPageClickedEvent,
  
}

abstract class NavigationStates {}



class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  NavigationBloc() : super(const HomePage()) {
    on<NavigationEvents>((event, emit) {
      switch (event) {
        case NavigationEvents.myProfilePageClickedEvent:
          emit(const MyProfilePage());
          break;
        case NavigationEvents.settingsPageClickedEvent:
          emit(const SettingsPage());
          break;
        case NavigationEvents.academicStaffPageClickedEvent:
          emit(const AcademicStaffPage());
          break;
        case NavigationEvents.giveFeedBackPageClickedEvent:
          emit(const FeedbackForm());
          break;
      }
    });
  }
}


