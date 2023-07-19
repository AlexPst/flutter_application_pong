import 'package:flutter/material.dart';
import 'ball.dart';
import 'bat.dart';

enum Direction{up, down, left, right}

class Pong extends StatefulWidget{
  
  @override
  _PongState createState()=> _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin{

  Direction vDir = Direction.down;
  Direction hDir = Direction.right;

  double increment = 5;
  late double width;
  late double height;
  double posX = 0;
  double posY = 0;
  double batWidth = 0;
  double batHeight = 0;
  double batPosition = 0;

  late Animation <double> animation;
  late AnimationController controller;

  @override
  void initState(){
    posX = 0;
    posY = 0;
    controller = AnimationController(duration: const Duration(seconds: 30), vsync: this, );
    animation = Tween<double>(begin: 0, end:10000).animate(controller);
    animation.addListener(() {
      setState(() {
        (hDir == Direction.right) ? posX += increment : posX -= increment;
        (vDir == Direction.down) ? posY += increment : posY -= increment;
      });

      checkBorders();
      
      
    });
    controller.forward();
    super.initState();
  }

  void checkBorders(){
    if(posX <= 0 && hDir == Direction.left)
    {
      hDir = Direction.right;
    }
    if(posX >= width - 50 && hDir == Direction.right)
    {
      hDir = Direction.left;
    }
    if(posY >= height - 50 && vDir == Direction.up)
    {
      vDir = Direction.up;
    }
    if(posY <= 0 && vDir == Direction.up)
    {
      vDir = Direction.down;
    }
  }

  void moveBat(DragUpdateDetails update){
    setState(() {
      batPosition += update.delta.dx;
    });
  }

  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constrains){
      height = constrains.maxHeight;
      width = constrains.maxWidth;
      batWidth = width /5;
      batHeight = height /20;
      return Stack(
        children: <Widget>[
          Positioned(
          child: Ball(),
          top: posY,
          left: posX,),
          Positioned(
          bottom: 0,
          left: batPosition,
          child: GestureDetector(
            onHorizontalDragUpdate: (DragUpdateDetails update) => moveBat(update),
            child: Bat(batWidth, batHeight)
          ),
         )
        ],
      );
    });
  }
}