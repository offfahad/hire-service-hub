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

String calculateTimeForChatMessage(String createdAt) {
  final DateTime createdDate = DateTime.parse(createdAt);
  final DateTime now = DateTime.now();

  // Calculate the difference in days
  final int differenceInDays = now.difference(createdDate).inDays;

  if (differenceInDays == 0) {
    // Message was sent today
    return DateFormat('hh:mm a').format(createdDate);
  } else if (differenceInDays == 1) {
    // Message was sent yesterday
    return 'Yesterday';
  } else {
    // Message is older than yesterday, show date and time
    return DateFormat('MMMM d, yyyy, hh:mm a').format(createdDate);
  }
}
