import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../../../core/models/comment_model.dart';
import '../../../core/utils/tools.dart' as tools show cachedImageWidget;

class CommentItem extends StatelessWidget {

  final Comment comment;

  CommentItem({@required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: tools.cachedImageWidget(
                      src: comment.avatar,
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                      placeholder: Container(),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        comment.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        DateFormat().format(comment.date),
                        style: TextStyle(
                          color: Colors.black45,
                          fontSize: 14,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(comment.comment),
        ],
      ),
    );
  }
}
