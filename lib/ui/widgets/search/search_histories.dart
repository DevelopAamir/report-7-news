import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import '../../../core/common/app_color.dart';
import '../../../core/localization/transulation_constants.dart';

typedef OnSearch<T> = void Function(String);
typedef OnRemoveItem<T> = void Function(int);

class SearchHistories extends StatelessWidget {
  final OnSearch<String> onSearch;
  final OnRemoveItem<int> onRemove;
  final List<String> history;

  SearchHistories(
      {@required this.onSearch,
      @required this.onRemove,
      @required this.history});

  @override
  Widget build(BuildContext context) {
    if (history == null || history.isEmpty) return SizedBox();
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              transulate(context, 'search_history'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: history.asMap().entries.map((entry) {
                String _term = entry.value;
                int _index = entry.key;
                return GestureDetector(
                  onTap: () {
                    onSearch(_term);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: AppColors.borderColor,
                    ))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          _term,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: () => onRemove(_index),
                          child:
                              Icon(FeatherIcons.x, size: 15, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
