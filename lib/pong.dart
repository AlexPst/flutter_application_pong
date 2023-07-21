import 'package:flutter/material.dart';
import 'dart:math';
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

  int score = 0;
  double randX = 1;
  double randY = 1;
  double increment = 5;
  late double width = 0;
  late double height = 0;
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
    animation = Tween<double>(begin: 0, end:100000).animate(controller);
    animation.addListener(() {
      safeSetState(() {
        (hDir == Direction.right) ? posX += ((increment * randX).round())
                                    :posX -= ((increment * randX).round());
        (vDir == Direction.down) ? posY += ((increment * randY).round())
                                   : posY -= ((increment * randY).round());
      });

      checkBorders();
      
      
    });
    controller.forward();
    super.initState();
  }

  void checkBorders(){
    double diameter = 50;
    if(posX <= 0 && hDir == Direction.left)
    {
      hDir = Direction.right;
      randX = randomNumber();
    }
    if(posX >= width - diameter && hDir == Direction.right)
    {
      hDir = Direction.left;
      randX = randomNumber();
    }
    if(posY >= height - diameter && vDir == Direction.up)
    {
      vDir = Direction.up;
      randY = randomNumber();
    }
    if(posY <= 0 && vDir == Direction.up)
    {
      vDir = Direction.down;
      randY = randomNumber();
    }

    if(posY >= height - diameter - batHeight && vDir == Direction.down)
    {
      if(posX >= (batPosition- diameter) && posX <= (batPosition + batWidth + diameter)){
        vDir = Direction.up;
        randY = randomNumber();
        safeSetState((){score++;});
      }else
      {
        controller.stop();
        showMessage(context);
      }
    }
    

  }

  void showMessage(BuildContext context)
  {
    showDialog(context: context, builder: (BuildContext context) {return AlertDialog(
      title: Text('Game Over'),
      content: Text('Would you like to play again?'),
      actions: <Widget>[
        TextButton(
          child: Text('Yes'),
          onPressed:() {
            setState(() {
              posX = 0;
              posY = 0;
              score = 0;
            });
            Navigator.of(context).pop();
            controller.repeat();
          },
        ),
        TextButton(onPressed:(){
          Navigator.of(context).pop();
          dispose();
        }, child: Text('No'))
      ],
    );});
  }

  void moveBat(DragUpdateDetails update){
    safeSetState(() {
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
            top: 0,
            right: 24, 
            child: Text('Score: ' + score.toString()),
          ),
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

  double randomNumber()
  {
    var ran = new Random();
    int myNum = ran.nextInt(101);
    return (50 + myNum) / 100;
  }

  void safeSetState(Function function)
  {
    if(mounted && controller.isAnimating)
    {
      setState((){
        function();
      });
    }
  }
}