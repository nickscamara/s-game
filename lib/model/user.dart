import 'package:premiumsnake/model/board.dart';
import 'package:premiumsnake/model/snake.dart';

class User {
  bool userCreated;
  List<String> snakesIds;
  List<String> boardsIds;
  int coins;
  String currentSnake;
  String currentBoard;
  int highScore;

  User(
      {
        this.userCreated,
        this.boardsIds,
      this.currentBoard,
      this.currentSnake,
      this.coins,
      this.highScore,
      this.snakesIds});

  User.fromMap(Map<dynamic, dynamic> map) {
     userCreated = map["userCreated"];
    snakesIds = map["snakesIds"];
    boardsIds = map["boardsIds"];
    highScore = map["highScore"];
    coins = map["score"];
    currentSnake = map["currentSnake"];
    currentBoard = map["currentBoard"];
  }
  toMap()
  {

  }
}
