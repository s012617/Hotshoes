import 'package:flutter/material.dart';

class PageAppBar extends StatelessWidget with PreferredSizeWidget {
  final _title;

  PageAppBar(this._title);

  @override
  Widget build(BuildContext context) {
    return _buildAppBar();
  }

  Widget _buildAppBar() => AppBar(
        title: Text(
          _title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 22,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: <Color>[
                Color(0xffef7678),
                Color(0xffb41513),
              ],
            ),
          ),
        ),
      );

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
