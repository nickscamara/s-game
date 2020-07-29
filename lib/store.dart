import 'package:flutter/material.dart';
import 'package:premiumsnake/model/coin.dart';
import 'package:premiumsnake/model/snake.dart';
import 'package:premiumsnake/services/route_service.dart';
import 'package:premiumsnake/services/user_service.dart';
import 'package:provider/provider.dart';

import 'model/board.dart';
import 'model/user.dart';

class Store extends StatefulWidget {
  Store({Key key}) : super(key: key);

  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  @override
  void initState() { 
    super.initState();
    
  }
  List<Snake> avaiableToBuy = [
    Snake(
      color: Colors.green,
      name: "Mint",
      price: 300,
      image: "assets/img/snake_green.png",
    ),
    Snake(
      color: Colors.purple,
      name: "Jackson",
      price: 500,
      image: "assets/img/snake_purple.png",
    ),
    Snake(
      color: Colors.orange,
      name: "Peterson",
      price: 700,
      image: "assets/img/snake_orange.png",
    ),
  ];
  List<Board> boardsToBuy = [
    Board(
      color: Colors.white,
      name: "Super White",
      price: 4000,
    ),
    Board(
      color: Colors.orange,
      name: "Old School",
      price: 5500,
    ),
    Board(
      color: Colors.blue,
      name: "Preimum",
      price: 10000,
    ),
  ];
  List<Coin> coinsToBuy = [
    Coin(
      quantity: 150,
      name: "Default Pack",
      price: 3.99,
    ),
    Coin(
      quantity: 3500,
      name: "Preimum Pack",
      price: 5.99,
    ),
    Coin(
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
  @override
  Widget build(BuildContext context) {
    final routeService = Provider.of<RouteService>(context, listen: false);
    final userService = Provider.of<UserService>(context, listen: false);
    return FutureBuilder<User>(
      future: userService.getUser(),
      builder: (context, snapshot) {
        if(snapshot.data!= null  && snapshot.connectionState == ConnectionState.done)
        {
          User user = snapshot.data;
          return Scaffold(
          backgroundColor: Colors.black,
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FloatingActionButton(
                child: Text("Back"),
                onPressed: () => routeService.navigate(0),
              ),
              SizedBox(width: 10),
              FloatingActionButton(
                backgroundColor: Colors.orange,
                child: Text(
                  "Play",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => routeService.navigate(2),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  header("Shop Items",user),
                  moreCoins(),
                  heading("Snakes"),
                  snakes(),
                  heading("Boards"),
                  boards(),
                  heading("Buy More Coins"),
                  coinsGrid(),
                  //backgrounds(),
                ],
              ),
            ),
          ),
        );

        }
        return Container();
        
      }
    );
  }

  Widget header(String text, User user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          text,
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
        coins(user.coins),
      ],
    );
  }

  Widget heading(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.white, fontSize: 18),
    );
  }

  Widget moreCoins() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: _customCard("Get FREE Coins!", "Watch a small video", () {},
          LinearGradient(colors: [Colors.lightGreen, Colors.green]), false),
    );
  }

  Widget boards() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 175,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: boardsToBuy.length,
          itemBuilder: (context, index) {
            return boardCard(
                boardsToBuy[index], () => buyBoard(boardsToBuy[index]));
          }),
    );
  }

  Widget coinsGrid() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 500,
      child: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemCount: coinsToBuy.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return coinCard(
                coinsToBuy[index], () => buyCoins(coinsToBuy[index]));
          }),
    );
  }

  Widget snakes() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 175,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: avaiableToBuy.length,
          itemBuilder: (context, index) {
            return snakeCard(
                avaiableToBuy[index], () => buy(avaiableToBuy[index]));
          }),
    );
  }

  buy(Snake snake) {
    print("Bought!");
  }

  buyBoard(Board board) {
    print("Bought! Board");
  }

  buyCoins(Coin coin) {
    print("Bought! Coins");
  }

  Widget coins(int coins) {
    return Row(
      children: <Widget>[
        Image.asset("assets/img/coin.png", width: 25),
        SizedBox(
          width: 3,
        ),
        Text(coins.toString())
      ],
    );
  }

  Widget _customCard(String text, String subtitle, Function onTap,
      Gradient gradient, bool disabled) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(0, 3), // changes position of shadow
              )
            ],
          ),
          child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              elevation: 0,
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: disabled
                          ? BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(25),
                            )
                          : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Image.asset(
                                "assets/img/coin.png",
                                width: 25,
                              ),
                              Text("+50")
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                text,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: disabled
                                        ? Colors.white.withOpacity(.75)
                                        : Colors.white),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Text(
                                  subtitle,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                      color: disabled
                                          ? Colors.white.withOpacity(.75)
                                          : Colors.white),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    )),
                borderRadius: BorderRadius.circular(25),
                highlightColor: Colors.purple.withOpacity(.3),
                focusColor: Colors.purple..withOpacity(.3),
                splashColor: Colors.purple..withOpacity(.3),
              ))),
    );
  }

  Widget snakeCard(Snake snake, Function onTap) {
    return Container(
      height: 175,
      width: 140,
      child: Stack(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 0.0, top: 8, right: 25, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.25),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  elevation: 0,
                  color: Colors.transparent,
                  //color: color,
                  child: InkWell(
                    onTap: onTap,
                    child: Container(
                      width: 140,
                      height: 140,
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          // gradient: highlightsList[index].gradient,
                          borderRadius: BorderRadius.circular(25)),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Align(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        snake.image,
                                        width: 50,
                                        height: 50,
                                      )),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    snake.price.toString(),
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.orange[300],
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    snake.name,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withOpacity(.75)),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget boardCard(Board board, Function onTap) {
    return Container(
      height: 175,
      width: 140,
      child: Stack(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 0.0, top: 8, right: 25, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.25),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  elevation: 0,
                  color: Colors.transparent,
                  //color: color,
                  child: InkWell(
                    onTap: onTap,
                    child: Container(
                      width: 140,
                      height: 140,
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          // gradient: highlightsList[index].gradient,
                          borderRadius: BorderRadius.circular(25)),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: 35,
                                        height: 50,
                                        color: board.color,
                                      )),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    board.price.toString(),
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 25,
                                        color: Colors.orange[300],
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    board.name,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withOpacity(.75)),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget coinCard(Coin coin, Function onTap) {
    return Container(
      height: 175,
      width: 140,
      child: Stack(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 0.0, top: 8, right: 25, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.25),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  elevation: 0,
                  color: Colors.transparent,
                  //color: color,
                  child: InkWell(
                    onTap: onTap,
                    child: Container(
                      width: 140,
                      height: 140,
                      padding: EdgeInsets.all(1),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          // gradient: highlightsList[index].gradient,
                          borderRadius: BorderRadius.circular(25)),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Align(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        "assets/img/coin.png",
                                        width: 25,
                                        height: 25,
                                      )),
                                  // Align(
                                  //     alignment: Alignment.center,
                                  //     child: Container(
                                  //       width: 35,
                                  //       height: 50,
                                  //       color: board.color,
                                  //     )),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    coin.quantity.toString(),
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.orange[300],
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "\$" + coin.price.toString(),
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white.withOpacity(.75)),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
