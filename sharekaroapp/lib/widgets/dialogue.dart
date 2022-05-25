import 'package:flutter/material.dart';
import '../main.dart';

class DialogueGeneral{
  
  final Widget callback;
  double heightContainer = 180.0;
  DialogueGeneral({required this.callback, required this.heightContainer}){}

  Future<Object?> genDailogue(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context , anim1, anim2){
      return (
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: heightContainer,
            child: SizedBox.expand(
              child: callback
            ),
            margin: const EdgeInsets.only(bottom: 50, left: 12, right: 12),
            decoration: BoxDecoration(
              color: popupprimary,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        )
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return 
      SlideTransition(
        position: Tween(begin: const Offset(0, -1), end: const Offset(0, -0.4)).animate(anim1),
        child: child,
      );
    },
  );
  }
}