import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ufly_motorista/Helpers/Helper.dart';

class customSwitch extends StatefulWidget {

  bool value;
  ValueChanged<bool> onChanged;
  Color activeColor;

  customSwitch({Key key,this.value, this.onChanged, this.activeColor, }) : super(key: key);

  @override
  _customSwitchState createState() {
    return _customSwitchState();
  }
}

class _customSwitchState extends State<customSwitch>     with SingleTickerProviderStateMixin {
  Animation _circleAnimation;
  AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 60));
    _circleAnimation = AlignmentTween(
        begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
        end: widget.value ? Alignment.centerLeft : Alignment.centerRight)
        .animate(CurvedAnimation(
        parent: _animationController, curve: Curves.linear));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController.isCompleted) {
              _animationController.reverse();
            } else {
              _animationController.forward();
            }
            widget.value == false
                ? widget.onChanged(true)
                : widget.onChanged(false);
          },
          
          child: Container(

            width: getLargura(context)*.35,
    
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                color: _circleAnimation.value == Alignment.centerLeft
                    ? Colors.grey
                    : widget.activeColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _circleAnimation.value == Alignment.centerRight
                    ? Padding(
                  padding:  EdgeInsets.only(left: getLargura(context)*.060, right: getLargura(context)*.005),
                  child: Text(
                    'Online',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontSize: 16.0),
                  ),
                )
                    : Container(),
                Align(
                  alignment: _circleAnimation.value,
                  child: Container(
                    width: getAltura(context)*.060,
                      height: getAltura(context)*.1,

                    decoration: BoxDecoration(
                      image: DecorationImage(image: AssetImage('assets/icondestino.png')),
                        shape: BoxShape.circle, color: Colors.white),
                  ),
                ),
                _circleAnimation.value == Alignment.centerLeft
                    ? Padding(
                  padding:  EdgeInsets.only(left: getLargura(context)*.005, right: getLargura(context)*.060),
                  child: Text(
                    'Offline',
                    style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w900,
                        fontSize: 16.0),
                  ),
                )
                    : Container(),
              ],
            ),
          ),
        );
      },
    );
  }
}