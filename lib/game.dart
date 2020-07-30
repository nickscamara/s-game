import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:premiumsnake/dialogs/win_dialog.dart';
import 'package:premiumsnake/main.dart';
import 'package:premiumsnake/menu.dart';
import 'package:premiumsnake/model/snake.dart';
import 'package:premiumsnake/services/route_service.dart';
import 'package:premiumsnake/services/user_service.dart';
import 'package:provider/provider.dart';

class Game extends StatefulWidget {
  Game({Key key}) : super(key: key);

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  static int numberOfSquares = 640;
  static int foodRange = numberOfSquares - 50;
  static int botRange = numberOfSquares - 50;
  int maxHealth = 3;
  // Initialize snake with positions, name, color and score of 0
  Snake snake;
  static var random;
  static var randomCoin;
  List<Snake> bots = [];
  List<Snake> placeHolderBots = [];
  List<String> directions = ["up", "down", "left", "right"];
  Timer timer;
  var food;
  var coin;
  String currentPosition;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  startGame() {
    resetBots();
    initializeSnake();
    initalizeRandoms();
    initializeItems();
    timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      updateGame();
      if (gameOver()) {
        finishGame(context);

        //do smth
      }
    });
  }

  resetBots() {
    placeHolderBots = [];
    bots = [];
  }

  initalizeRandoms() {
    random = Random();
    randomCoin = Random();
  }

  initializeItems() {
    food = random.nextInt(foodRange);
    coin = randomCoin.nextInt(foodRange);
  }

  restartGame() {
    startGame();
  }

  generateRandomPositionList(
      String direction, int initialPosition, int snakeLength) {
    List<int> positionsList = [];
    positionsList.add(initialPosition);
    for (var i = 0; i < snakeLength - 1; i++) {
      switch (direction) {
        case "down":
          if (positionsList.last > numberOfSquares - 20) {
            positionsList.add(positionsList.last + 20 - numberOfSquares);
          } else {
            positionsList.add(positionsList.last + 20);
          }
          break;
        case "up":
          if (positionsList.last < 20) {
            positionsList.add(positionsList.last - 20 + numberOfSquares);
          } else {
            positionsList.add(positionsList.last - 20);
          }
          break;
        case "left":
          if (positionsList.last % 20 == 0) {
            positionsList.add(positionsList.last - 1 + 20);
          } else {
            positionsList.add(positionsList.last - 1);
          }
          break;
        case "right":
          if ((positionsList.last + 1) % 20 == 0) {
            positionsList.add(positionsList.last + 1 - 20);
          } else {
            positionsList.add(positionsList.last + 1);
          }
          break;
        default:
      }
    }
    return positionsList;
  }

  checkLength() {}
  spawnBots() {
    var direction = random.nextInt(3);
    var position = random.nextInt(botRange);
    var positions =
        generateRandomPositionList(directions[direction], position, 5);
    Snake bot1 = Snake(
        name: "bot 1",
        color: Colors.red,
        direction: directions[direction],
        score: 0,
        positions: positions);
    setState(() {
      placeHolderBots.add(bot1);
    });
    Future.delayed(
        Duration(seconds: 3),
        () => setState(() {
              placeHolderBots.remove(bot1);
              bots.add(bot1);
            }));
  }

  initializeSnake() {
    Random rand = Random();
    var direction = rand.nextInt(3);
    var positioni = rand.nextInt(botRange);
    snake = Snake(
        name: "Snake 1",
        color: Colors.green,
        direction: directions[direction],
        coins: 0,
        diamonds: 0,
        price: 0,
        score: 0,
        positions:
            generateRandomPositionList(directions[direction], positioni, 5));
  }

  finishGame(context) async {
    final routeService = Provider.of<RouteService>(context, listen: false);
    timer.cancel();
    await saveProgress();
    removeBots();
    showGameOverDialog(context, snake, () {
      restartGame();
      Navigator.pop(context);
    }, () {
      Navigator.pop(context);
      routeService.navigate(1);
    }, () {
      Navigator.pop(context);
      routeService.navigate(0);
    });
  }

  saveProgress() async {
    final userService = Provider.of<UserService>(context, listen: false);
    final response = await userService.updatePreferences(snake);
  }

  removeBots() {
    setState(() {
      for (var x = 0; x < bots.length; x++) {
        bots.remove(bots[x]);
      }
    });
  }

  gameOver() {
    for (var i = 0; i < snake.positions.length; i++) {
      var count = 0;
      for (var j = 0; j < snake.positions.length; j++) {
        for (var x = 0; x < bots.length; x++) {
          for (var t = 0; t < bots[x].positions.length; t++) {
            if (snake.positions[i] == bots[x].positions[t]) {
              count = 2;
            }
          }
        }
        if (snake.positions[i] == snake.positions[j]) {
          count += 1;
        }
        if (count == 2) {
          return true;
        }
      }
    }
    return false;
  }

  generateNewFood() {
    food = random.nextInt(foodRange);
  }

  generateNewCoin() {
    coin = randomCoin.nextInt(foodRange);
  }

  updateBots() {
    for (var i in bots) {
      switch (i.direction) {
        case "down":
          if (i.positions.last > numberOfSquares - 20) {
            i.positions.add(i.positions.last + 20 - numberOfSquares);
          } else {
            i.positions.add(i.positions.last + 20);
          }
          break;
        case "up":
          if (i.positions.last < 20) {
            i.positions.add(i.positions.last - 20 + numberOfSquares);
          } else {
            i.positions.add(i.positions.last - 20);
          }
          break;
        case "left":
          if (i.positions.last % 20 == 0) {
            i.positions.add(i.positions.last - 1 + 20);
          } else {
            i.positions.add(i.positions.last - 1);
          }
          break;
        case "right":
          if ((i.positions.last + 1) % 20 == 0) {
            i.positions.add(i.positions.last + 1 - 20);
          } else {
            i.positions.add(i.positions.last + 1);
          }
          break;
        default:
      }
      i.positions.removeAt(0);
    }
  }

  checkToSpawnBot() {
    if (snake.score >= 20 && bots.length == 0 && placeHolderBots.length == 0) {
      spawnBots();
    }
    if (snake.score >= 50 && bots.length == 1 && placeHolderBots.length == 0) {
      spawnBots();
    }
  }

  updateGame() {
    setState(() {
      checkToSpawnBot();
      if (bots.length > 0) {
        updateBots();
      }
      switch (snake.direction) {
        case "down":
          // LAST ROW OF GRIDS
          if (snake.positions.last > numberOfSquares - 20) {
            snake.positions.add(snake.positions.last + 20 - numberOfSquares);
          } else {
            snake.positions.add(snake.positions.last + 20);
          }
          break;
        case "up":
          if (snake.positions.last < 20) {
            snake.positions.add(snake.positions.last - 20 + numberOfSquares);
          } else {
            snake.positions.add(snake.positions.last - 20);
          }
          break;
        case "left":
          if (snake.positions.last % 20 == 0) {
            snake.positions.add(snake.positions.last - 1 + 20);
          } else {
            snake.positions.add(snake.positions.last - 1);
          }
          break;
        case "right":
          if ((snake.positions.last + 1) % 20 == 0) {
            snake.positions.add(snake.positions.last + 1 - 20);
          } else {
            snake.positions.add(snake.positions.last + 1);
          }
          break;
        default:
      }
      if (snake.positions.last == coin) {
        snake.coins += 50;
        generateNewCoin();
      }
      if (snake.positions.last == food) {
        snake.score += 20;
        generateNewFood();
      } else {
        snake.positions.removeAt(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              onVerticalDragUpdate: (details) {
                if (snake.direction != "up" && details.delta.dy > 0) {
                  snake.direction = "down";
                } else if (snake.direction != "down" && details.delta.dy < 0) {
                  snake.direction = "up";
                }
              },
              onHorizontalDragUpdate: (details) {
                if (snake.direction != "left" && details.delta.dx > 0) {
                  snake.direction = "right";
                } else if (snake.direction != "right" && details.delta.dx < 0) {
                  snake.direction = "left";
                }
              },
              child: Container(
                child: GridView.builder(
                    itemCount: numberOfSquares,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 20),
                    itemBuilder: (context, index) {
                      if (snake.positions.contains(index)) {
                        return snakePart();
                      } else if (food == index) {
                        return foodPart();
                      } else if (coin == index) {
                        return coinPart();
                      } else {
                        for (var i = 0; i < bots.length; i++) {
                          if (bots[i].positions.contains(index)) {
                            return botPart();
                          }
                        }
                        for (var i = 0; i < placeHolderBots.length; i++) {
                          if (placeHolderBots[i].positions.contains(index)) {
                            return PlaceHolderBot();
                          }
                        }
                        return boardSquare();
                      }
                    }),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _scoreWidget(),
                    _coinsWidget(),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: RaisedButton.icon(
                  onPressed: () {
                    finishGame(context);
                  },
                  icon: Icon(Icons.close),
                  label: Text("Game Over")),
            )
          ],
        ),
      ),
    );
  }

  Widget _scoreWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Score: ",
          style: TextStyle(color: Colors.white.withOpacity(.5), fontSize: 25),
        ),
        Text(
          snake.score.toString(),
          style: TextStyle(color: Colors.white.withOpacity(.75), fontSize: 25),
        ),
      ],
    );
  }

  Widget _coinsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/img/singlecoin.png",
          width: 25,
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          snake.coins.toString(),
          style: TextStyle(color: Colors.white.withOpacity(.75), fontSize: 25),
        ),
      ],
    );
  }

  // Represents an empty board square
  Widget boardSquare() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[900].withOpacity(.4),
            borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  Widget snakePart() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: snake.color, borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  Widget botPart() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: Colors.red, borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  Widget foodPart() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: snake.color, borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  Widget coinPart() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        padding: EdgeInsets.all(2),
        child: Image.asset("assets/img/singlecoin.png"),
        decoration: BoxDecoration(
            color: Colors.yellow, borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}

class PlaceHolderBot extends StatefulWidget {
  PlaceHolderBot({Key key}) : super(key: key);

  @override
  _PlaceHolderBotState createState() => _PlaceHolderBotState();
}

class _PlaceHolderBotState extends State<PlaceHolderBot>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    animation = Tween<double>(begin: 0, end: 1).animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: Colors.red.withOpacity(animation.value),
            borderRadius: BorderRadius.circular(5)),
      ),
    );
  }
}
