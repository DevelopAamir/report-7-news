import 'package:flutter/material.dart';
import '../../../core/common/app_color.dart';
import '../../../core/localization/transulation_constants.dart';

class SectionContainer extends StatelessWidget {
  /// The [title] of this section
  final String title;

  /// Handler function will be fired when clicking on [more] link
  ///
  /// If null then the [more] link will be hidden
  final Function moreNavigation;

  /// Empty space to inscribe inside the section head
  ///
  /// This only applied to section head but not its [child]
  ///
  /// [child] should specifiy its own padding if needed
  final EdgeInsets padding;

  /// Empty space to surround the section head
  ///
  /// This only applied to section head but not its [child]
  ///
  /// [child] should specifiy its own margin if needed
  final EdgeInsets margin;

  /// The [child] contained by the SectionContainer
  final Widget child;

  /// The space between section head and child
  ///
  /// Default value is set to 10
  final double heightAboveChild;

  /// Creates a section widget that will display section head with title
  /// and some navigation link for more details additional to body child of this section
  SectionContainer({
    @required this.title,
    @required this.child,
    this.moreNavigation,
    this.padding = const EdgeInsets.all(0),
    this.margin = const EdgeInsets.all(0),
    this.heightAboveChild = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          padding: padding,
          margin: margin,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              (moreNavigation != null)
                  ? GestureDetector(
                      child: Text(
                        transulate(context, 'more'),
                        style: TextStyle(color: AppColors.secondaryColor),
                      ),
                      onTap: moreNavigation,
                    )
                  : SizedBox(),
            ],
          ),
        ),
        SizedBox(
          height: heightAboveChild,
        ),
        child
      ],
    );
  }
}
