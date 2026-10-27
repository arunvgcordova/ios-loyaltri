enum CustomImageType {svg, webm, png}

class CheckType {
  final int typeId;
  final String icon;
  final CustomImageType iconType;
  final String title;
  final String subTitle;

  const CheckType(
      {required this.icon,
        required this.typeId,
      required this.iconType,
      required this.title,
      required this.subTitle});
}

List<CheckType> checkInMethods = [
  const CheckType(typeId: 5, icon: "assets/images/finger_print.svg", iconType: CustomImageType.svg, title: "Button Punch", subTitle: "Tap to check in."),
  // const CheckType(typeId: 4, icon: "assets/images/qr_checkIn.webp", iconType: CustomImageType.webm, title: "QR Code", subTitle: "Scan the QR code to check in."),
  const CheckType(typeId: 3, icon: "assets/images/Selfie-3d.webp", iconType: CustomImageType.webm, title: "Selfie", subTitle: "Verify your check in with a selfie."),
];

List<CheckType> checkOutMethods = [
  const CheckType(typeId: 5, icon: "assets/images/finger_print.svg", iconType: CustomImageType.svg, title: "Button Punch", subTitle: "Tap to check out."),
  // const CheckType(typeId: 4, icon: "assets/images/qr_checkIn.webp", iconType: CustomImageType.webm, title: "QR Code", subTitle: "Scan the QR code to check out."),
  const CheckType(typeId: 3, icon: "assets/images/Selfie-3d.webp", iconType: CustomImageType.webm, title: "Selfie", subTitle: "Verify your check out with a selfie."),
];
