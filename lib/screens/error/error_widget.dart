import 'package:flutter/cupertino.dart';

class MyErrorWidget extends StatelessWidget {
  const MyErrorWidget({super.key, this.errorMessage = 'An error occured'});


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