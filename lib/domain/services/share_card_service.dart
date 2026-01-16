import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as img;

class ShareCardService {
  static Future<Uint8List> captureQuoteCard(GlobalKey key) async {
    final boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  static Future<img.Image> toImage(Uint8List bytes) async {
    return img.decodeImage(bytes)!;
  }
}
