

class NotificationModel {
  final String title;
  final String hoursAgo;
  final String image;
  const NotificationModel({required this.hoursAgo, required this.image, required this.title});
}

List<NotificationModel> notificationResentList = [
  const NotificationModel(title: "Clara Kim requested a  - Casual Leave for 2 days", hoursAgo: '12m', image: 'assets/images/logo.svg'),
  const NotificationModel(title: "Alan Sam requested an asset  - Monitor required", hoursAgo: '20m', image: 'assets/images/logo.svg'),
];

List<NotificationModel> notificationEarlierList = [
  const NotificationModel(title: "Clara Kim requested a  - Casual Leave for 2 days", hoursAgo: '12h', image: 'assets/images/logo.svg'),
  const NotificationModel(title: "Alan Sam requested a  - Casual Leave for 1 day", hoursAgo: '15h', image: 'assets/images/logo.svg'),
  const NotificationModel(title: "Alan Sam requested a  - Casual Leave for 1 day", hoursAgo: '20h', image: 'assets/images/logo.svg'),
  const NotificationModel(title: "Alan Sam requested a  - Casual Leave for 1 day", hoursAgo: '15h', image: 'assets/images/logo.svg'),
  const NotificationModel(title: "Alan Sam requested a  - Casual Leave for 1 day", hoursAgo: '15h', image: 'assets/images/logo.svg'),
  const NotificationModel(title: "Alan Sam requested a  - Casual Leave for 1 day", hoursAgo: '15h', image: 'assets/images/logo.svg'),
];