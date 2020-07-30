import 'package:flutter/material.dart';
import 'package:premiumsnake/model/board.dart';
import 'package:premiumsnake/model/snake.dart';
import 'package:premiumsnake/model/user.dart';
import 'package:premiumsnake/services/custom_response.dart';
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
 Future<void> updatePreferences(Snake snake) async{
   final user = await getUser();
   if(snake.score > user.highScore)
   {
     updateHighScore(snake.score);
   }
   updateCoins(snake.coins);
   notifyListeners();
 }


  Future<void> updateHighScore(int newHighScore) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("highScore", newHighScore);
  }
  Future<void> updateCoins(int coins) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int oldCoins = prefs.getInt("coins");
    int newCoins = coins + oldCoins;
    prefs.setInt("coins", newCoins);
  }

  Future<CustomResponse> selectItem(dynamic item) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> items = item is Snake ? prefs.getStringList("snakesIds") : prefs.getStringList("boardsIds");
    for(var i in items)
    {
      if(i == item.id)
      {
        final save = await prefs.setString(item is Snake ? "currentSnake": "currentBoard", item.id);
        return CustomResponse(msg:"Success",isError: false);
      }
      
    }
        return CustomResponse(msg:"You don't own this snake",isError: true);

    
  }
  // Item can be a snake
  Future<CustomResponse> buyItem(dynamic item) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int coins = prefs.getInt("coins");
    List<String> listOfIds = item is Snake ?  prefs.getStringList("snakesIds") : item is Board ? prefs.getStringList("boardsIds") : null;
    if(listOfIds == null)
    {
      return CustomResponse(msg:"Something went wrong!",isError: true); 
    }
    for(var i in listOfIds)
    {
      if(i == item.id)
      {
        // You already have that snake
        return CustomResponse(msg:"You already own that snake",isError: true);
      }
    }
    if(item.price > coins)
    {
      return CustomResponse(msg:"Not enough coins, watch a video!",isError: true);
    }
    int newcoins = coins - item.price;
    listOfIds.add(item.id);
    // Add the item they bought to their list
    prefs.setStringList( item is Snake ? "snakesIds" : "boardsIds", listOfIds);
    // Decrease the amount of coins
    prefs.setInt("coins", newcoins);
    await selectItem(item);
    return CustomResponse(msg:"Success!",isError: false);

  }
}