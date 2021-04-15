import 'package:flutter/material.dart';

class ShowAlert {
  static void show(BuildContext context, String title, String content,
      {Function onSubmit, bool needCancel = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          title: new Text(
            title,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          content: new Text(
            content,
            style: TextStyle(color: Colors.grey[600]),
          ),
          actions: <Widget>[
            if (needCancel)
              new FlatButton(
                child: new Text(
                  "取消",
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "確認",
                style: TextStyle(fontWeight: FontWeight.w500, color: Colors.pink),
              ),
              onPressed: () {
                if (onSubmit != null) onSubmit();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
