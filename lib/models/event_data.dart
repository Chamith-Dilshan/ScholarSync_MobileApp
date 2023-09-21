import 'package:calendar_view/calendar_view.dart';
import 'package:scholarsync/theme/palette.dart';


final List<CalendarEventData> caleventdata = [
    CalendarEventData(
      date: DateTime.now(),
      event: "Event 1",
      title: "ADBMS",
      description: "Mrs. Sophia Williams\n9.00am - 3.00pm @ L1-109",
      startTime: DateTime(2023, 9, 1, 9, 30),
      endTime: DateTime(2023, 9, 1, 3),
    ),
    CalendarEventData(
      date: DateTime.now().add(const Duration(days: 1)),
      event: "Event 2",
      title: "IAS",
      description: "Mrs. Sophia Williams\n2.30pm - 5.00pm @ L3-107",
      color: PaletteLightMode.primaryGreenColor,
      startTime: DateTime(2023, 9, 2, 2, 30),
      endTime: DateTime(2023, 9, 2, 5),
    ),
    CalendarEventData(
      date: DateTime.now().subtract(const Duration(days: 1)),
      event: "Event 3",
      title: "MAD",
      description: "Mrs. Sophia Williams\n2.30pm - 5.00pm @ L2-105",
      color: PaletteLightMode.primaryGreenColor,
      startTime: DateTime(2023, 9, 2, 2, 30),
      endTime: DateTime(2023, 9, 2, 5),
    ),
  ];