import 'package:flutter/material.dart';

class ToggleButton extends StatefulWidget {
  
  final VoidCallback? onPressed;

  const ToggleButton({Key? key, this.onPressed}) : super(key: key);

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = !selected;
        });
        if (widget.onPressed != null) {
          widget.onPressed!(); // Invoke the onPressed callback
        }
      },
      child: Center(
          child: Transform.rotate(
              angle: -90 *
                  3.1415927 /
                  180, // -90 degrees in radians (anticlockwise)
              child: AnimatedContainer(
                width: 50.0,
                height:
                    50.0, // Use half the desired height to make a semicircle
                duration: const Duration(seconds: 2),
                curve: Curves.fastOutSlowIn,
                decoration: BoxDecoration(
                  color: selected ? Colors.red : Colors.blue,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(
                        100.0), // Adjust the radius for the semicircle
                  ),
                ),

                alignment: Alignment.center,
                child: selected
                    ? Icon(
                        Icons.expand_less,
                        size: 20,
                        color: Colors.white,
                      )
                    : Icon(
                        Icons.expand_more,
                        size: 20,
                        color: Colors.white,
                      ),
              ))),
    );
  }
}
