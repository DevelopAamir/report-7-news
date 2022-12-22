import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/utils/ui_helper.dart' as uiHelper
    show presentToast, buttonLoadingState;
import '../../../core/common/app_theme.dart';
import '../../../core/localization/transulation_constants.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/repositories/common_repository.dart';

class ContactScreen extends StatelessWidget {
  final CommonRepository _commonRepository = CommonRepository();

  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _message = TextEditingController();

  final FocusNode _nameFieldFocusNode = FocusNode();
  final FocusNode _emailFieldFocusNode = FocusNode();
  final FocusNode _messageFieldFocusNode = FocusNode();

  final ValueNotifier<bool> _loadingNotifier = ValueNotifier<bool>(false);

  /// Handle submitted contact us form
  Future<void> _onSubmitForm(BuildContext context) async {
    final appGeneralOption = Provider.of<AppProvider>(context, listen: false)
        .appConfigs
        .appGeneralOption;
    if (appGeneralOption != null && appGeneralOption.contactFormId != null) {
      if (_form.currentState.validate()) {
        FocusScope.of(context).unfocus();
        _loadingNotifier.value = true;
        final _res = await _commonRepository.sendContactMessage({
          'your-email': _email.text,
          'your-name': _name.text,
          'your-message': _message.text
        }, appGeneralOption.contactFormId);
        if (_res != null) {
          if (!_res.error && _res.data) {
            uiHelper.presentToast(
              message: transulate(context, 'message_sent'),
              success: true,
            );
            Navigator.of(context).pop();
          } else {
            uiHelper.presentToast(
              message:
                  _res.message ?? transulate(context, 'message_cannot_sent'),
              success: false,
            );
          }
        }
        _loadingNotifier.value = false;
      }
    } else {
      uiHelper.presentToast(
        message: transulate(context, 'invalid_contact_form_id'),
        success: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(transulate(context, 'contact_screen')),
        shape: appBarShape,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: TextFormField(
                        controller: _name,
                        focusNode: _nameFieldFocusNode,
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
                      padding: const EdgeInsets.only(bottom: 20.0),
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
                            .requestFocus(_messageFieldFocusNode),
                        validator: (value) {
                          return value.isEmpty
                              ? transulate(context, 'email_field_required')
                              : null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: TextFormField(
                        controller: _message,
                        focusNode: _messageFieldFocusNode,
                        decoration: InputDecoration(
                          labelText: transulate(context, 'message_field'),
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
                        maxLines: 7,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(_messageFieldFocusNode),
                        validator: (value) {
                          return value.isEmpty
                              ? transulate(context, 'message_field_required')
                              : null;
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _onSubmitForm(context),
                      child: ValueListenableBuilder<bool>(
                          valueListenable: _loadingNotifier,
                          child: Text(
                            transulate(context, 'send'),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          builder: (context, value, child) {
                            return value
                                ? uiHelper.buttonLoadingState()
                                : child;
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
