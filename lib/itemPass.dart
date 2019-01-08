import 'package:flutter/material.dart';

class PassItemValidation extends StatefulWidget {
  PassItemValidation(this.title, this.valid);
  final String title;
  final bool valid;
  @override
  _PassItemValidationState createState() => _PassItemValidationState();
}

class _PassItemValidationState extends State<PassItemValidation>
    with TickerProviderStateMixin {
  AnimationController _passController;
  AnimationController stikeController;
  Animation<double> strikePercent;
  Animation<double> spaceWidth;

  @override
  void didUpdateWidget(PassItemValidation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.valid != widget.valid) {
      if (widget.valid) {
        _playAnimation(true);
      } else {
        _playAnimation(false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint("Init State");
    _passController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    stikeController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    spaceWidth = Tween<double>(begin: 8, end: 12).animate(
        CurvedAnimation(parent: _passController, curve: Curves.easeOut));
    strikePercent = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: stikeController, curve: Curves.easeOut));
    spaceWidth.addListener(() {
      setState(() {});
    });
    strikePercent.addListener(() {
      setState(() {});
    });
  }

  Future<void> _playAnimation(bool strikeIn) async {
    try {
      if (strikeIn) {
        print(strikePercent.value);
        stikeController.forward().orCancel;
      } else {
        print('ini ${strikePercent.value}');
        stikeController.reverse().orCancel;
      }

      await _passController.forward().orCancel;
      await _passController.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: spaceWidth.value,
        ),
        CustomPaint(
            foregroundPainter: StrikePainter(strikePercent.value),
            child: Text(
              widget.title,
              style: validateStyle(widget.valid),
            )),
      ],
    );
  }

  TextStyle validateStyle(bool validation) {
    return TextStyle(
        fontWeight: FontWeight.bold,
        color: validation ? Colors.black87 : Colors.orange,
        fontSize: 12.0);
  }
}

class StrikePainter extends CustomPainter {
  StrikePainter(this.percent);
  double percent;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Rect.fromLTWH(0, (size.height / 2) - 2, size.width * percent, 3),
        Paint()..color = Colors.green);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
