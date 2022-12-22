import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import '../../../core/utils/tools.dart' as tools show openURL;

class HtmlDetailsData extends StatelessWidget {
  final String postContent;

  HtmlDetailsData({@required this.postContent});

  @override
  Widget build(BuildContext context) {
    return Html(
      data: postContent ?? '',
      shrinkWrap: false,
      style: {
        'body': Style(margin: EdgeInsets.zero),
      },
      onLinkTap: (url, _, __, ___) {
        tools.openURL(url);
      },
    );
  }
}
