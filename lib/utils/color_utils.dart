
import 'package:flutter/material.dart';

class ColorUtils {
  static const backgroundBlack = Color(0xFF15131A);
  static const backgroundBlack1 = Color(0xFF101010);
  static const foregroundBlack = Color(0xFF27252C);
  static const foregroundBlack1 = Color(0xFF151515);
  static const foregroundBlack2 = Color(0xFF313131);
  static const foregroundBlack3 = Color(0xFF3C3C3C);
  static const foregroundBlack4 = Color(0xFF222033);
  static const primaryBlue = Color(0xFF4003AB);
  static const primaryDarkBlue = Color(0xFF3F02AA);
  static const secondaryBlue = Color(0xFF6A4BFC);
  static const textWhite = Color(0xFFFFFFFF);
  static const dutyCircle = Color(0xFFA673FF);
  static const leaveCircle = Color(0xFFD97474);
  static const offDayCircle = Color(0xFF868686);
  static const calenderDatesCircle = Color(0xFF8041EF);
  static const checkInBlue = Color(0xFF4205AE);
  static const resendSMS = Color(0xFF7C15FF);
  static const checkOutRed = Color(0xFFC20000);
  static const errorRedBorder = Color(0xFFD10000);
  static const errorRedText = Color(0xFFF54135);
  static const incorrectOTP = Color(0xFFFF6262);
  static const lateColorForAttDetail1 = Color(0xFFE13802);
  static const lateColorForAttDetail2 = Color(0xFFEF2B2B);
  static const otColorForAttDetail1 = Color(0xFF5F18E9);
  static const otColorForAttDetail2 = Color(0xFF8145F5);
  static const seeMore = Color(0xFFD1B7FF);
  static const workEntryHead = Color(0xFF000000);
  static const notiColor = Color(0xFFAB21FF);
  static const datePickColor = Color(0xFF171620);
  static const sheetBorder = Color(0xFF171620);
  static const toggleInactive = Color(0xFF39393D);
  static const offDayColor = Color(0xFFCCCCCD);
  static const absentColor = Color(0xFFD0453B);
  static const incompleteDayColor = Color(0xFFF49B3D);
  static const workingDayColor = Color(0xFF259662);
  static const holidayColor = Color(0xFFeb4d98);
  static const paidLeaveColor = Color(0xFF1c76fe);
  static const lf1 = Color(0xFF0E5484);
  static const lf2 = Color(0xFF2980BB);
  static const ot1 = Color(0xFF8B0FAE);
  static const ot2 = Color(0xFFB736DC);
  static const eb1 = Color(0xFFCB4B22);
  static const eb2 = Color(0xFFFC7146);
  static const ee1 = Color(0xFFC20000);
  static const ee2 = Color(0xFFF54646);
  static const mp1 = Color(0xFFB9AC21);
  static const mp2 = Color(0xFFD3D276);
  static const generalShift1 = Color(0xFF8372ED);
  static const generalShift2 = Color(0xFF6554D0);
  static const generalShift3 = Color(0xFF6352CD);
  static const generalShift4 = Color(0xFF5A48CB);
  static const generalShift5 = Color(0xFF6454C8);
  static const generalShift6 = Color(0xFF55AAEC);
  static const generalShift7 = Color(0xFF4290CC);
  static const generalShift8 = Color(0xFF2D8FDC);
  static const generalShift9 = Color(0xFF347FBA);
  static const generalShift10 = Color(0xFF3A88C5);
  static const generalNightShift1 = Color(0xFFFF967C);
  static const generalNightShift2 = Color(0xFFDB5E40);
  static const generalNightShift3 = Color(0xFFE56E51);
  static const generalNightShift4 = Color(0xFFC25237);
  static const generalNightShift5 = Color(0xFFBB4F33);
  static const filterFlag = Color(0xFFA895FF);
  static const offDayShift1 = Color(0xFFAFAFAF);
  static const offDayShift2 = Color(0xFF989898);
  static const offDayShift3 = Color(0xFF8D8D8D);
  static const offDayShift4 = Color(0xFF808080);
  static const divider = Color(0xFF3D3D3D);
  static const approved = Color(0xFF00CA7A);
  static const notUpdated = Color(0xFF323232);
  static const letterTypeUnselected = Color(0xFF1F1E23);
  static const attCheckIn = Color(0xFF2BD48E);
  static const attCheckOut = Color(0xFFE82D2D);
  static const attCheckOut1 = Color(0xFFCD1B1B);
  static const attBreakStr = Color(0xFF8D8D8D);
  static const breakGrad1 = Color(0xFF886BFF);
  static const breakGrad2 = Color(0xFF7D5EEE);
  static const navGrad1 = Color(0xFF111111);
  static const navGrad2 = Color(0xFF000000);
  static const googleGreen = Color(0xFF378262);
  static const lightGrey = Color(0xFFAAAAAA);
  static const jungleGreen = Color(0xFF238D63);
  static const mediumAquamarine = Color(0xFF7AE9BD);
  static Color border = const Color(0xFFDEDEDE).withValues(alpha: 0.12);

  static const List<Color> shiftColors1 = [
    Color(0xFF8372ED),
    Color(0xFF55AAEC),
    Color(0xFFFF967C),
    Color(0xFFAFAFAF),
  ];

  static const List<Color> shiftColors2 = [
    Color(0xFF6554D0),
    Color(0xFF4290CC),
    Color(0xFFDB5E40),
    Color(0xFF989898),
  ];

  static const List<Color> shiftColors3 = [
    Color(0xFF6352CD),
    Color(0xFF2D8FDC),
    Color(0xFFE56E51),
    Color(0xFF8D8D8D),
  ];

  static const List<Color> shiftColors4 = [
    Color(0xFF5A48CB),
    Color(0xFF347FBA),
    Color(0xFFC25237),
    Color(0xFF808080),
  ];

  static const List<Color> shiftColors5 = [
    Color(0xFF6454C8),
    Color(0xFF3A88C5),
    Color(0xFFBB4F33),
    Color(0xFF808080),
  ];

  List<LeaveTypeColor> leavePersColors = [
    const LeaveTypeColor(color1: Color(0xFFCB2E24), color2: Color(0xFFEC877A)),
    const LeaveTypeColor(color1: Color(0xFFFFEBCC), color2: Color(0xFFFFEBCC)),
    const LeaveTypeColor(color1: Color(0xFFFCE7FA), color2: Color(0xFFFCE7FA)),
    const LeaveTypeColor(color1: Color(0xFFF1E9FE), color2: Color(0xFFF1E9FE)),
  ];

  // Manager View
  static const lavenderPurple = Color(0xFFB69FF6);
  static const lavenderMist = Color(0xFFE3D9F9);
  static const snowWhite = Color(0xFFFAFAFA);
  static const pastelPurple = Color(0xFFF6F2FF);
  static const shadowGrey = Color(0xFF262626);
  static const stormySlate = Color(0xFF707486);
  static const whiteSmoke = Color(0xFFF7F7F7);
  static const paleLavenderMist = Color(0xFFF4F1F9);
  static const lightLavender = Color(0xFFE2D9F8);
  static const lavenderWhisper = Color(0xFFF4F3FF);
  static const cloudySilver = Color(0xFFC3C3C3);
  static const mediumPurple = Color(0xFF8243F1);
  static const silverGrey = Color(0xFFC5C5C5);
  static const softGrey = Color(0xFFDBDBDB);
  static const gunMetalGrey = Color(0xFF3F3F46);
  static const royalPurple = Color(0xFF5925DC);
  static const roseMist = Color(0xFFFFF3F3);
  static const crimsonRed = Color(0xFFDC2528);
  static const creamyPeach = Color(0xFFF9F0E6);
  static const burntOrange = Color(0xFFC97800);
  static const aquaGreen = Color(0xFF00C9B2);
  static const electricAqua = Color(0xFF36DCD9);
  static const paleSilver = Color(0xFFDADADA);
  static const deepViolet = Color(0xFF6633E7);
  static const charcoalBlue = Color(0xFF3F4450);
  static const softPearl = Color(0xFFF3F3F3);
  static const steelBlue = Color(0xFF667085);
  static const amethystPurple = Color(0xFF6941C6);
  static const neonViolet = Color(0xFF7A5AF8);
  static const darkGrey = Color(0xFF666666);
  static const fieryRed = Color(0xFFE43A3A);
  static const pureRed = Color(0xFFE30000);
  static const fieryScarlet = Color(0xFFDF0000);
  static const cloudGrey = Color(0xFFDEDEDE);
  static const stoneGrey = Color(0xFF8C8C8C);
  static const whisperGrey = Color(0xFFF5F5F5);
  static const lightSilver = Color(0xFFE9E9E9);
  static const iceGrey = Color(0xFFF2F4F7);
  static const deepSlate = Color(0xFF344054);
  static const jetBlack = Color(0xFF2B2B2B);
  static const lavenderIndigo = Color(0xFF7F56D9);
  static const paleLilac = Color(0xFFF9F5FF);
  static const ashGrey = Color(0xFFBEBEBE);
  static const snowGrey = Color(0xFFEFEFEF);
  static const flameOrange = Color(0xFFE46919);
  static const electricMagenta = Color(0xFFEE74FB);
  static const pureSnow = Color(0xFFF9F9F9);
  static const mistGrey = Color(0xFFE7E9EB);
  static const cloudWhite = Color(0xFFF8FAFC);
  static const pearlGrey = Color(0xFFF1F1F1);
  static const warmGrey = Color(0xFFE3DEDE);
  static const softCold = Color(0xFFF8F7F7);
  static const goldenAmber = Color(0xFFCB8E12);
  static const dimGrey = Color(0xFF696969);
  static const warmIvory = Color(0xFFF8EFE2);
  static const peachBeige = Color(0xFFF4D19E);
  static const blushPink = Color(0xFFFFE7E7);
  static const peachBlush = Color(0xFFFAC5C5);
  static const royalBlue = Color(0xFF0B65FF);
  static const iceBlue = Color(0xFFE9F4FC);
  static const babyBlue = Color(0xFFA8D7FA);
  static const mindWhisper = Color(0xFFF0F8F2);
  static const paleSage = Color(0xFFDBE1DE);
  static const forestGreen = Color(0xFF398552);
  static const charcoalGrey = Color(0xFF504F4F);
  static const silverMist = Color(0xFFE2E2E2);
  static const frostWhite = Color(0xFFF3F4F4);
  static const emeraldGreen = Color(0xFF00C852);
  static const softSilver = Color(0xFFDFDFDF);
  static const cherryRed = Color(0xFFDC474C);
  static const goldenOrange = Color(0xFFFFA629);
  static const steelGrey = Color(0xFF9C9C9C);
  static const roseMint = Color(0xFFFFE9E9);
  static const fireRed = Color(0xFFCA1B1B);
  static const frostGrey = Color(0xFFF3F5F7);
  static const tigerOrange = Color(0xFFF1871E);
  static const sapphireBlue = Color(0xFF1746C5);
  static const peachCream = Color(0xFFFFF6ED);
  static const rustRed = Color(0xFFC4320A);
  static const tangerineOrange = Color(0xFFFB6514);
  static const lavenderBlue = Color(0xFFBEB1FF);
  static const lilacHaze = Color(0xFFEAE4F5);
  static const sunsetOrange = Color(0xFFF98532);
  static const crimsonBlaze = Color(0xFFE33A3A);
  static const obsidianGrey = Color(0xFF3A3A3A);
  static const frostedPearl = Color(0xFFD9D9D9);
  static const bone = Color(0xFFE0D9CC);
  static const eerieBlack = Color(0xFF1E1E1E);
  static const gunMetal = Color(0xFF464C52);
  static const lightApricot = Color(0xFFFFCD82);
  static const spanishGrey = Color(0xFF9A9A9A);
  static const jetGrey = Color(0xFF2A2A2A);

  // Growth
  static const darkIndigo = Color(0xFF2D2553);
  static const nearBlack = Color(0xFF06050E);
  static const deepIndigo = Color(0xFF352C62);
  static const charcoalBlack = Color(0xFF131315);
  static const darkSlatePurple = Color(0xFF3D3A4C);
  static const darkIndigoGrey = Color(0xFF343048);
  static const darkEspresso = Color(0xFF332D2A);
  static const warmBeige = Color(0xFFEED0AE);
  static const softCream = Color(0xFFF1E3D2);
  static const vividIndigo = Color(0xFF7255DF);
  static const softLavender = Color(0xFFAF9AFD);
  static const offWhite = Color(0xFFF9F7FF);
  static const bronzeBrown = Color(0xFF6E502C);
  static const darkCharcoal = Color(0xFF2A2A2A);
  static const softBlack = Color(0xFF1F1F1F);
  static const veryDarkGrey = Color(0xFF1B1B1B);
  static const royalIndigo = Color(0xFF42396E);
  static const darkBlueViolet = Color(0xFF3E366A);
  static const slateIndigo = Color(0xFF34304A);
  static const platinumGrey = Color(0xFFE5E5E5);
  static const midnightViolet = Color(0xFF402E82);
  static const midnightIndigo = Color(0xFF1B182E);
  static const carbonGrey = Color(0xFF2C2C2C);
  static const powderBlue = Color(0xFFBDE9F1);
  static const deepForestGreen = Color(0xFF106132);
  static const lightPeriwinkle = Color(0xFFB4A4FF);
  static const softPeriwinkle = Color(0xFFAE9DFF);
  static const graphite = Color(0xFF333333);
  static const mediumViolet = Color(0xFF6D4EDE);
  static const deepMidnightPurple = Color(0xFF110E1D);
  static const mutedIndigo = Color(0xFF5E538F);
  static const midnightBluePurple = Color(0xFF251A5B);
  static const electricIndigo = Color(0xFF4F2AFF);
  static const electricPeriwinkle = Color(0xFF7051FF);
  static const lightIndigo = Color(0xFF8C74FF);
  static const brightBlueViolet = Color(0xFF6E5BFC);
  static const brightIndigo = Color(0xFF6F64FD);
  static const midnightSlatePurple = Color(0xFF322B58);
  static const accentPurple = Color(0xFFAD46FF);
  static const accentOrange = Color(0xFFFF8904);
  static const vermilionOrange = Color(0xFFFF6900);
  static const coralRed = Color(0xFFFF6467);
  static const dangerRed = Color(0xFFFF1010);
  static const darkSurface = Color(0xFF373737);
  static const successGreen = Color(0xFF00BC7D);
  static const appBackground = Color(0xFF141414);
  static const deepBackground = Color(0xFF0D0D0D);
  static const alertRed = Color(0xFFFB2C36);
  static const skyBlue = Color(0xFF51A2FF);
  static const neonGreen = Color(0xFF07D029);
  static const veryDarkNaturalDGrey = Color(0xFF1A1A1A);
  static const goldenYellow = Color(0xFFFFB900);
  static const charcoalPurple = Color(0xFF25242F);
  static const high = Color(0xFFFF4D4F);
  static const medium = Color(0xFFFFB900);
  static const low = Color(0xFF07D029);

  // Shift Scheduler
  static const platinum = Color(0xFFE6E6E6);
  static const softLavenderBlue = Color(0xFFB9B8FF);
  static const softLilac = Color(0xFFE7E2FF);
}

class LeaveTypeColor {
  final Color color1;
  final Color color2;
  const LeaveTypeColor({required this.color1, required this.color2});
}

const String darkModeMapStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [
      { "color": "#212121" }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      { "color": "#757575" }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      { "color": "#212121" }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [
      { "color": "#757575" }
    ]
  },
  {
    "featureType": "administrative.country",
    "elementType": "labels.text.fill",
    "stylers": [
      { "color": "#9e9e9e" }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "stylers": [
      { "visibility": "off" }
    ]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [
      { "color": "#bdbdbd" }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      { "color": "#757575" }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      { "color": "#181818" }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      { "color": "#616161" }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.stroke",
    "stylers": [
      { "color": "#1b1b1b" }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.fill",
    "stylers": [
      { "color": "#2c2c2c" }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      { "color": "#8a8a8a" }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [
      { "color": "#373737" }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      { "color": "#3c3c3c" }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry",
    "stylers": [
      { "color": "#4e4e4e" }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      { "color": "#616161" }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.fill",
    "stylers": [
      { "color": "#757575" }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      { "color": "#000000" }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      { "color": "#3d3d3d" }
    ]
  }
]
''';