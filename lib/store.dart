import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:premiumsnake/model/coin.dart';
import 'package:premiumsnake/model/snake.dart';
import 'package:premiumsnake/services/route_service.dart';
import 'package:premiumsnake/services/user_service.dart';
import 'package:provider/provider.dart';

import 'model/board.dart';
import 'model/items_to_buy.dart';
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
  User savedUser;
  
  @override
  Widget build(BuildContext context) {
    final routeService = Provider.of<RouteService>(context, listen: false);
    final userService = Provider.of<UserService>(context, listen: false);
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

          body: FutureBuilder<User>(
        future: userService.getUser(),
        builder: (context, snapshot) {
          if(snapshot.data!= null  && snapshot.connectionState == ConnectionState.done)
          {
            User user = snapshot.data;
            savedUser = user;
            return  storeLayout(user);
          }
          return savedUser != null ? storeLayout(savedUser) : Container();
          
        }
      ),
    );
  }

  Widget storeLayout(User user)
  {
    return SafeArea(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    header("Shop Items",user),
                    moreCoins(),
                    heading("Snakes"),
                    snakes(user),
                    heading("Boards"),
                    boards(user),
                    heading("Buy More Coins"),
                    coinsGrid(user),
                    //backgrounds(),
                  ],
                ),
              ),
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

  Widget boards(User user) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 175,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: boardsToBuy.length,
          itemBuilder: (context, index) {
            if(user.boardsIds.contains(boardsToBuy[index].id))
            {
              if(user.currentBoard == boardsToBuy[index].id)
              {
                return snakeCard(
                boardsToBuy[index], () => buy(boardsToBuy[index]),true,true, ()=> selectSnake(boardsToBuy[index]));

              }
              return snakeCard(
                boardsToBuy[index], () => buy(boardsToBuy[index]),true,false,  ()=> selectSnake(boardsToBuy[index]));
              

            }
            
             return snakeCard(
                boardsToBuy[index], () => buy(boardsToBuy[index]),false);
            
          }),
    );
  }

  Widget coinsGrid(User user) {
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

  Widget snakes(User user) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 175,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: avaiableToBuy.length,
          itemBuilder: (context, index) {
            if(user.snakesIds.contains(avaiableToBuy[index].id))
            {
              if(user.currentSnake == avaiableToBuy[index].id)
              {
                return snakeCard(
                avaiableToBuy[index], () => buy(avaiableToBuy[index]),true,true, ()=> selectSnake(avaiableToBuy[index]));

              }
              return snakeCard(
                avaiableToBuy[index], () => buy(avaiableToBuy[index]),true,false,  ()=> selectSnake(avaiableToBuy[index]));
              

            }
            
             return snakeCard(
                avaiableToBuy[index], () => buy(avaiableToBuy[index]),false);
            
          }),
    );
  }

  buy(dynamic item) async {
    final userService = Provider.of<UserService>(context,listen:false);
    final response = await userService.buyItem(item);
    if(response.isError)
    {
      //SHow dialog
    }
    else
    {
      setState(() {
        
      });
      // Show Dialog
      // refresh the page
      // make sure it shows up
    }
  }
  selectSnake(dynamic item) async
  {
    final userService = Provider.of<UserService>(context,listen:false);
    final response = await userService.selectItem(item);
    if(response.isError)
    {


    }
    else
    {
      setState(() {
        
      });
    }

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

  Widget snakeCard(dynamic snake, Function onTap, bool bought, [bool selected, Function onSelect] ) {
    return Container(
      height: 175,
      width: 140,
      child: Stack(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 0.0, top: 8, right: 25, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: !bought ?Colors.grey.withOpacity(.25) : null,
                  gradient: bought ? LinearGradient(colors: [Colors.amber, Colors.orange]) : null,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  elevation: 0,
                  color: Colors.transparent,
                  //color: color,
                  child: InkWell(
                    onTap: !bought ? onTap : onSelect,
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
                                  snake is Snake ? Align(
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        snake.image,
                                        width: 50,
                                        height: 50,
                                      )) :  Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: 35,
                                        height: 50,
                                        color: snake.color,
                                      )),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    !bought ? snake.price.toString() : "Select",
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: !bought ? Colors.orange[300] : Colors.white,
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
              selected == true ? Align(
                alignment: Alignment.topRight,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.check,color: Colors.lightGreen,))) : Container()
        
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
                                        fontSize: 22,
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
