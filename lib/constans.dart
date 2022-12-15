import 'package:flutter/material.dart';


Color textColor = Colors.white;
Color infoBoxColor = const Color(0xff1f0754);
List<Color> gradientColors =  [
            const Color(0xff602a93),
            const Color(0xff4b2382),
            const Color(0xff351b70),
          ];

int returnImage(int code) {
    if (code == 1000) {
      return 26;
    } else if (code == 1003) {
      return 27;
    } else if (code == 1006 ||
        code == 1009 ||
        code == 1030 ||
        code == 1072 ||
        code == 1135 ||
        code == 1147) {
      return 35;
    } else if (code == 1063 ||
        code == 1180 ||
        code == 1186 ||
        code == 1192 ||
        code == 1240 ||
        code == 1243 ||
        code == 1246) {
      return 8;
    } else if (code == 1066 ||
        code == 1213 ||
        code == 1219 ||
        code == 1225 ||
        code == 1237) {
      return 18;
    } else if (code == 1069 ||
        code == 1168 ||
        code == 1171 ||
        code == 1204 ||
        code == 1207) {
      return 22;
    } else if (code == 1087 || code == 1273 || code == 1276) {
      return 12;
    } else if (code == 1114 ||
        code == 1117 ||
        code == 1198 ||
        code == 1201 ||
        code == 1261 ||
        code == 1264) {
      return 23;
    } else if (code == 1150 || code == 1153 || code == 1183 || code == 1189) {
      return 7;
    } else if (code == 1195) {
      return 17;
    } else if (code == 1210 ||
        code == 1216 ||
        code == 1222 ||
        code == 1255 ||
        code == 1258 ||
        code == 1282) {
      return 28;
    } else if (code == 1249 || code == 1252) {
      return 24;
    } else if (code == 1279) {
      return 25;
    }
    return 30;
  }