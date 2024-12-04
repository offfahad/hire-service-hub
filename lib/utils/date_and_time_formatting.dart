import 'package:intl/intl.dart';

String formatTime(String time) {
  try {
    DateTime parserdTime = DateTime.parse(time);
    String formattedTime =
        DateFormat('MMMM d, yyyy, h:mm a').format(parserdTime);
    return formattedTime;
  } catch (e) {
    return "Invalid Date";
  }
}
