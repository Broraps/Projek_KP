import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

BoxDecoration kHeaderDecoration = BoxDecoration(
  color: CustomColor.backgroundPrimary,
  borderRadius: BorderRadius.circular(100),
);

const TextStyle kTitleTextStyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: CustomColor.backgroundPrimary,
  fontFamily: 'Roboto',
);

const TextStyle kSubtitleTextStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w500,
  color: Colors.black87,
  fontFamily: 'Roboto',
);

const TextStyle kBodyTextStyle = TextStyle(
  fontSize: 16,
  height: 1.5,
  color: Colors.black54,
  fontFamily: 'Roboto',
);
