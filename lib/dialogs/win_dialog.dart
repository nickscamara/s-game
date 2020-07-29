import 'package:flutter/material.dart';
import 'package:premiumsnake/model/snake.dart';

showWinDialog(context){
Dialog dialog = Dialog(
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
  child: Container(
    height: MediaQuery.of(context).size.height / 3,
    width: MediaQuery.of(context).size.width / 3,

    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding:  EdgeInsets.all(15.0),
          child: Text('Cool', style: TextStyle(color: Colors.red),),
        ),
        Padding(
          padding: EdgeInsets.all(15.0),
          child: Text('Awesome', style: TextStyle(color: Colors.red),),
        ),
        Padding(padding: EdgeInsets.only(top: 50.0)),
        FlatButton(onPressed: (){
          Navigator.of(context).pop();
        },
            child: Text('Got It!', style: TextStyle(color: Colors.purple, fontSize: 18.0),))
      ],
    ),
  ),
);
showDialog(context: context, builder: (BuildContext context) => dialog);}

showGameOverDialog(context,Snake snake, Function onRestart, Function onStore, Function onMenu){
 
Dialog dialog = Dialog(
  backgroundColor: Colors.grey[900].withOpacity(.5),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), //this right here
  child: Container(
    color: Colors.transparent,
    height: MediaQuery.of(context).size.height / 2.5,
    width: MediaQuery.of(context).size.width / 3,

    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:  EdgeInsets.all(15.0),
          child: Text('GAME OVER', style: TextStyle(color: Colors.white,fontSize: 30),),
        ),
        Padding(
          padding: EdgeInsets.all(15.0),
          child: Text('Score: ${snake.score.toString()}', style: TextStyle(color: Colors.white,fontSize: 20),),
        ),
        Padding(padding: EdgeInsets.only(top: 10.0)),
        _button(context,"Restart", onRestart, Colors.amber),
        _button(context,"Store", onStore, Colors.amber),
        _button(context,"Menu", onMenu, Colors.amber)
      ],
    ),
  ),
);
showDialog(
  barrierDismissible: false,
  context: context, builder: (BuildContext context) => dialog);}

Widget _button(context,String text, Function onTap,Color color)
  {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
              child: RaisedButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: color,
          onPressed: onTap,
          child: Text(text,style: TextStyle(fontSize: 16),)),
      ),
    );
  }