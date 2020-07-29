import 'package:flutter/material.dart';

class Snake{
  String id;
  List<int> positions;
  String name;
  Color color;
  String image;
  int score;
  int price;
  String direction; // "up", "down", "left", "right"

  Snake({this.positions,this.color,this.name,this.score,this.direction,this.price,this.image,this.id});
}