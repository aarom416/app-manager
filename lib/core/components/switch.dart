import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:singleeat/core/components/container.dart';

class SGSwitch extends StatelessWidget {
  final bool value;
  final Function(bool) onChanged;

  SGSwitch({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: SGContainer(
        // child: Image.asset(
        //   value ? 'assets/images/switch-on.png' : 'assets/images/switch-off.png',
        //   width: 40,
        // ),
        child: Container(
          height: 24,
          width: 40,
          child: FittedBox(
            fit: BoxFit.contain,
            child: CupertinoSwitch(
              activeColor: const Color(0xFF2CB682),
                value: value,
                onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }
}
