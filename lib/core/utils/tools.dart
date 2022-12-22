import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as htmlparser;
import 'package:url_launcher/url_launcher.dart' show launch;
import '../constants/config.dart' show imagePlaceholder;

/// Converting hex string color code to Color object
Color convertHexToColor(String code) {
  if (code == null || code.isEmpty) return null;
  return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

ImageProvider cachedDecorationImage(String image) {
  if (image != null && image.isNotEmpty) {
    return CachedNetworkImageProvider(image);
  } else {
    return AssetImage(imagePlaceholder);
  }
}

/// This will take the image url and return cahched Image Widget
///
/// It will keep it in the cache directory
Widget cachedImageWidget({
  @required String src,
  double width,
  double height,
  BoxFit fit,
  Widget placeholder,
  Widget error,
}) {
  if (src != null && src.isNotEmpty) {
    return CachedNetworkImage(
      imageUrl: src,
      fit: fit,
      width: width,
      height: height,
      placeholder: (context, url) =>
          placeholder ??
          Image.asset(
            imagePlaceholder,
            fit: fit,
          ),
      errorWidget: (context, url, error) => error ?? Icon(Icons.error),
    );
  } else {
    return Image.asset(
      imagePlaceholder,
      fit: fit,
    );
  }
}

/// Filter string from HTML tags
String parseHtmlString(String stringHtml) {
  if (stringHtml != null && stringHtml.isNotEmpty) {
    final dom.Document _document = htmlparser.parse(stringHtml);
    final String _parsed =
        htmlparser.parse(_document.body.text).documentElement.text;
    return _parsed;
  } else {
    return '';
  }
}

/// Validate email address
bool isEmailValid(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

Future<void> openURL(String url) async {
  if (url != null && url.isNotEmpty) {
    await launch(
      url,
    );
  }
}
