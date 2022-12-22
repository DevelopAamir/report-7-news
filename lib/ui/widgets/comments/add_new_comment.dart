import 'package:flutter/material.dart';
import '../../../core/utils/ui_helper.dart' as uiHelper
    show presentToast, buttonLoadingState;
import '../../../core/localization/transulation_constants.dart';
import '../../../core/repositories/comment_repository.dart';
import '../../../core/utils/tools.dart' as tools show isEmailValid;

class AddNewComment extends StatefulWidget {
  final int postId;

  AddNewComment(this.postId);

  @override
  _AddNewCommentState createState() => _AddNewCommentState();
}

class _AddNewCommentState extends State<AddNewComment> {
  final CommentRepository _commentRepository = CommentRepository();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _comment = TextEditingController();

  final FocusNode _emailFieldFocusNode = FocusNode();
  final FocusNode _commentFieldFocusNode = FocusNode();

  bool _isSubmitting = false;

  /// Handle add comment event
  Future<void> _onFormSubmitted() async {
    if (_form.currentState.validate()) {
      FocusScope.of(context).unfocus();
      setState(() => _isSubmitting = true);
      final _res = await _commentRepository.addPostComments({
        'author_email': _email.text,
        'author_name': _name.text,
        'content': _comment.text,
        'post': widget.postId.toString(),
      });
      if (_res != null) {
        if (!_res.error && _res.data != null) {
          uiHelper.presentToast(
            message: _res.data.status == 'hold'
                ? transulate(context, 'comment_submitted_review')
                : transulate(context, 'comment_submitted_successfully'),
            success: true,
          );
          Navigator.of(context).pop();
        } else {
          uiHelper.presentToast(
            message:
                _res.message ?? transulate(context, 'cannot_submit_comment'),
            success: false,
          );
        }
      }
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 15,
                      ),
                      child: Text(
                        transulate(context, 'add_your_comment'),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: TextFormField(
                        controller: _name,
                        decoration: InputDecoration(
                          labelText: transulate(context, 'name_field'),
                          labelStyle: TextStyle(fontSize: 15),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black12,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(15),
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_emailFieldFocusNode),
                        validator: (value) {
                          return value.isEmpty
                              ? transulate(context, 'name_field_required')
                              : null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: TextFormField(
                        controller: _email,
                        focusNode: _emailFieldFocusNode,
                        decoration: InputDecoration(
                          labelText: transulate(context, 'email_field'),
                          labelStyle: TextStyle(fontSize: 15),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black12,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(15),
                        ),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_emailFieldFocusNode),
                        validator: (value) {
                          if (value.isEmpty) {
                            return transulate(context, 'email_field_required');
                          } else {
                            return tools.isEmailValid(value)
                                ? null
                                : transulate(context, 'invalid_email_format');
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: TextFormField(
                        controller: _comment,
                        focusNode: _commentFieldFocusNode,
                        decoration: InputDecoration(
                          labelText: transulate(context, 'comment'),
                          labelStyle: TextStyle(fontSize: 15),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black12,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(15),
                          alignLabelWithHint: true,
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_emailFieldFocusNode),
                        validator: (value) {
                          return value.isEmpty
                              ? transulate(context, 'comment_required')
                              : null;
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _onFormSubmitted,
                      child: _isSubmitting
                          ? uiHelper.buttonLoadingState()
                          : Text(
                              transulate(context, 'send'),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
