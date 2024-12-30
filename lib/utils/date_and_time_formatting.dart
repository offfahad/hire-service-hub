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

String formatDate(String time) {
  try {
    DateTime parserdTime = DateTime.parse(time);
    String formattedTime = DateFormat('MMMM d, yyyy').format(parserdTime);
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

String getFormattedTime12Hour(String dateTimeString) {
  // Parse the input string into a DateTime object
  DateTime dateTime = DateTime.parse(dateTimeString);

  // Determine whether it's AM or PM
  String period = dateTime.hour >= 12 ? 'PM' : 'AM';

  // Convert hour to 12-hour format
  int hour12 = dateTime.hour % 12;
  hour12 = hour12 == 0
      ? 12
      : hour12; // If hour is 0, set it to 12 (for 12 AM or 12 PM)

  // Format the time as hh:mm AM/PM
  String formattedTime =
      "${hour12.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} $period";

  return formattedTime;
}

String _getMonthName(int month) {
  // Convert month number to month name
  const List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  return months[month - 1];
}

String formatDateWithTime(String date) {
  DateTime parsedDate = DateTime.parse(date);
  // Check if time is included by verifying if the string contains 'T' (common in ISO 8601 format)
  String format;
  if (date.contains('T')) {
    // Format with date and time if the time component is present
    format = 'MMMM d, y - h:mm a'; // Example: October 18, 2024 - 5:30 PM
  } else {
    // Format with just date if no time component
    format = 'MMMM d, y'; // Example: October 18, 2024
  }
  return DateFormat(format).format(parsedDate);
}

String formatDateAndTime(DateTime dateTime) {
  // Define date and time formats
  String formattedDate =
      "${_getMonthName(dateTime.month)} ${dateTime.day}, ${dateTime.year}";
  String formattedTime = _formatTime(dateTime);

  return "$formattedDate - $formattedTime";
}

String _formatTime(DateTime dateTime) {
  // Format time in 12-hour format with AM/PM
  int hour = dateTime.hour;
  int minute = dateTime.minute;
  String period = hour >= 12 ? "PM" : "AM";
  hour = hour % 12;
  hour = hour == 0 ? 12 : hour;
  String formattedMinute = minute < 10 ? "0$minute" : "$minute";
  return "$hour:$formattedMinute $period";
}
