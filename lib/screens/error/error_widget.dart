import 'package:flutter/cupertino.dart';

class MyErrorWidget extends StatelessWidget {
  const MyErrorWidget({super.key, required this.errorMessage});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Text(
          errorMessage, 
          style: const TextStyle(
            color: CupertinoColors.systemRed
          ),
        ),
      )
    );
  }
}