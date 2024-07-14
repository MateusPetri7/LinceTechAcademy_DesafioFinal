import 'package:flutter/material.dart';

import '../../routes.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final void Function(int)? onIconPressed;

  const BaseScaffold({
    required this.body,
    required this.title,
    this.onIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
        ),
        backgroundColor: Colors.deepPurple[400],
        automaticallyImplyLeading: false,
      ),
      body: body,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.subdirectory_arrow_left,
                size: 30.0,
              ),
              onPressed: () {
                if (onIconPressed != null) {
                  onIconPressed!(0);
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.home,
                size: 30.0,
              ),
              onPressed: () {
                if (onIconPressed != null) {
                  onIconPressed!(1);
                } else {
                  Navigator.pushNamed(context, AppRoutes.home);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
