import 'package:flutter/material.dart';
class ToggleButton extends StatefulWidget {
  
  final VoidCallback? onPressed;
  final bool selected;

  
  const ToggleButton({super.key, required this.selected, this.onPressed});

  @override
  State<ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {

  

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        widget.onPressed?.call(); // Invoke the onPressed callback
      },
      child: Align(
        alignment: Alignment.centerLeft,
          child: Transform.rotate(
              angle: -90 *
                  3.1415927 /
                  180, // -90 degrees in radians (anticlockwise)
             child: 
              AnimatedContainer(
                width: 50.0,
                height:
                    30.0, // Use half the desired height to make a semicircle
                duration: const Duration(seconds: 2),
                               curve: Curves.fastOutSlowIn,
                decoration: BoxDecoration(
                
                  color: widget.selected ? Colors.red : Colors.blue,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(
                        100.0), // Adjust the radius for the semicircle
                  ),
                ),

                alignment: Alignment.center,
               
                child: widget.selected
                    ? const Icon(
                        Icons.expand_less,
                        size: 20,
                        color: Colors.white,
                      )
                      : const Icon(
                        Icons.expand_more,
                        size: 20,
                        color: Colors.white,
                      ),
    
              )),
              ),
    );
  }
}
