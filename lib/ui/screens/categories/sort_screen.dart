import 'package:flutter/material.dart';
import '../../../core/common/app_color.dart';
import '../../../core/enums/ui_enums.dart';
import '../../../core/localization/transulation_constants.dart';

class SortScreen extends StatefulWidget {
  final SortPostsOption selectedSortOption;

  SortScreen({this.selectedSortOption});

  @override
  _SortScreenState createState() => _SortScreenState();
}

class _SortScreenState extends State<SortScreen> {
  /// Represent the value of the selected sort option
  SortPostsOption _selectedSortOption;

  @override
  void initState() {
    _selectedSortOption = widget.selectedSortOption;
    super.initState();
  }

  /// Handle on option selected
  ///
  /// Accept [value] to be set to _selectedSortOption
  void _setSelectedSortOption(SortPostsOption value) {
    setState(() {
      _selectedSortOption = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Describe the sort options that can be applied to list of posts
    List<Map<String, SortPostsOption>> _sortOptions = [
      {transulate(context, 'recent_posts'): SortPostsOption.latest},
      {transulate(context, 'oldest_posts'): SortPostsOption.oldest},
      {transulate(context, 'most_comments'): SortPostsOption.mostComments},
    ];

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(15),
                child: Text(
                  transulate(context, 'filter_posts'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ..._sortOptions.map((option) {
                return GestureDetector(
                  onTap: () => _setSelectedSortOption(option.values.first),
                  child: Row(
                    children: <Widget>[
                      Radio(
                        value: option.values.first,
                        groupValue: _selectedSortOption,
                        onChanged: _setSelectedSortOption,
                      ),
                      Text(
                        option.keys.first,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                );
              }).toList(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      child: Text(
                        transulate(context, 'apply'),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(_selectedSortOption);
                      },
                    ),
                  ),
                  if (widget.selectedSortOption != null)
                    SizedBox(
                      width: 10,
                    ),
                  if (widget.selectedSortOption != null)
                    ElevatedButton(
                      child: Text(
                        transulate(context, 'cancel_filter'),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.secondaryColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(SortPostsOption.reset);
                      },
                    ),
                ],
              ),
            ]),
      ),
    );
  }
}
