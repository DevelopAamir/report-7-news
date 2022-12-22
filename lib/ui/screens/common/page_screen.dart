import 'package:flutter/material.dart' hide Page;
import '../../../core/common/app_theme.dart';
import '../../../core/models/page_model.dart';
import '../../../core/repositories/common_repository.dart';
import '../../../core/utils/api_response.dart';
import '../../widgets/common/data_loading.dart';
import '../../widgets/common/error_message.dart';
import '../../widgets/common/index.dart';

class PageScreen extends StatelessWidget {
  final CommonRepository _commonRepository = CommonRepository();

  /// The [pageId] to be rendered to this screen
  final int pageId;
  final String pageTitle;

  PageScreen({@required this.pageId, @required this.pageTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        shape: appBarShape,
      ),
      body: FutureBuilder(
        future: _commonRepository.getPage(pageId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return DataLoading();
          } else {
            if (snapshot.error != null) {
              return ErrorMessage();
            } else {
              ApiResponse<Page> _response = snapshot.data as ApiResponse<Page>;
              if (_response.error) {
                return ErrorMessage(
                  message: _response.message,
                );
              } else {
                return SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: HtmlDetailsData(
                          postContent: _response.data.content,
                        ),
                  ),
                );
              }
            }
          }
        },
      ),
    );
  }
}
