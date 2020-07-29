import 'package:flutter/material.dart';
import 'package:premiumsnake/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService extends ChangeNotifier{
  Future<User> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool user = prefs.getBool('userCreated');
    if (user != true) {
      await prefs.setBool('userCreated', true);
      await prefs.setInt('highScore', 0);
      await prefs.setInt('coins', 0);
      await prefs.setString('currentSnake', "default");
      await prefs.setString('currentBoard', "default");
      await prefs.setStringList('snakesIds', ["0"]);
      await prefs.setStringList('boardsIds', ["0"]);
      return User(
          userCreated: true,
          highScore: 0,
          coins: 0,
          currentSnake: "default",
          currentBoard: "default",
          snakesIds: ["0"],
          boardsIds: ["0"]);
    } else {
      final userCreated = prefs.getBool('userCreated');
      final highScore = prefs.getInt('highScore');
      final coins = prefs.getInt('coins');
      final currentSnake = prefs.getString('currentSnake');
      final currentBoard = prefs.getString('currentBoard');
      final snakesIds = prefs.getStringList('snakesIds');
      final boardsIds = prefs.getStringList('boardsIds');
      return User(
        boardsIds: boardsIds,
        userCreated: userCreated,
        coins: coins,
        highScore: highScore,
        snakesIds: snakesIds,
        currentBoard: currentBoard,
        currentSnake: currentSnake,
      );
    }
  }
}