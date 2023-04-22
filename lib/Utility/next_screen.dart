import 'package:flutter/material.dart';


void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}
// Navigate to next screen with built in animation
// you can also costomize animation according to your choice.
void nextScreenWithAnimation(context, page) {
  // Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  Navigator.push(
    context,
    PageRouteBuilder(
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          alignment: Alignment.center,
          scale: Tween<double>(begin: 0.1, end: 1).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
          ),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return page;
      },
    ),
  );
}

// void nextScreeniOS (context, page){
//   Navigator.push(context, CupertinoPageRoute(
//     builder: (context) => page));
// }

void nextScreenCloseOthers(context, page) {
  Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (context) => page), (route) => false);
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenPopup(context, page) {
  Navigator.push(context,
      MaterialPageRoute(builder: (context) => page, fullscreenDialog: true));
}
