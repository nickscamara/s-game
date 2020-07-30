import 'package:flutter/material.dart';
import 'package:premiumsnake/model/coin.dart';
import 'package:premiumsnake/model/snake.dart';

import 'board.dart';

List<Snake> avaiableToBuy = [
    Snake(
      id: "0",
      color: Colors.green,
      name: "Default",
      price: 0,
      image: "assets/img/snake_green.png",
    ),
    Snake(
      id: "1",
      color: Colors.green,
      name: "Mint",
      price: 300,
      image: "assets/img/snake_green.png",
    ),
    Snake(
      id: "2",
      color: Colors.purple,
      name: "Jackson",
      price: 500,
      image: "assets/img/snake_purple.png",
    ),
    Snake(
      id: "3",
      color: Colors.orange,
      name: "Peterson",
      price: 700,
      image: "assets/img/snake_orange.png",
    ),
  ];
  List<Board> boardsToBuy = [
    Board(
      id: "0",
      color: Colors.black,
      name: "Back in Black",
      price: 0,
    ),
    Board(
      id: "1",
      color: Colors.white,
      name: "Super White",
      price: 350,
    ),
    Board(
      id: "2",
      color: Colors.orange,
      name: "Old School",
      price: 1000,
    ),
    Board(
      id: "3",
      color: Colors.blue,
      name: "Preimum",
      price: 960,
    ),
  ];
  List<Coin> coinsToBuy = [
    Coin(
      id: "1",
      quantity: 150,
      name: "Default Pack",
      price: 3.99,
    ),
    Coin(
      id: "2",
      quantity: 3500,
      name: "Preimum Pack",
      price: 5.99,
    ),
    Coin(
      id: "3",
      quantity: 5000,
      name: "Gold Pack",
      price: 21.99,
    ),
    Coin(
      quantity: 50000,
      name: "Silver Pack",
      price: 39.99,
    ),
    Coin(
      quantity: 100000,
      name: "Platinum Pack",
      price: 59.99,
    ),
    Coin(
      quantity: 250000,
      name: "Diamond Pack",
      price: 99.99,
    ),
  ];