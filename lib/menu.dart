import 'package:flutter/material.dart';
import 'package:premiumsnake/game.dart';
import 'package:premiumsnake/model/user.dart';
import 'package:premiumsnake/services/route_service.dart';
import 'package:premiumsnake/services/user_service.dart';
import 'package:premiumsnake/store.dart';
import 'package:provider/provider.dart';

class Menu extends StatefulWidget {
  Menu({Key key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RouteService>(
      builder: (context, value, child) {
        if(value.navigateTo == -1)
        {
          return menu(value);
        }
        else if(value.navigateTo == 0)
        {
          return menu(value);
        }
        else if(value.navigateTo == 1)
        {
          return Store();
        }
        else if(value.navigateTo == 2)
        {
          return Game();
        }
        return menu(value);
      },
    );
    
  }

  Widget menu(RouteService routeService)
  {
    final userService = Provider.of<UserService>(context, listen: false);
    return Scaffold(
          backgroundColor: Colors.black,
          body: FutureBuilder<User>(
            future: userService.getUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                User user = snapshot.data;
                return SafeArea(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.star,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: Image.asset("assets/img/logo1.png",
                                width: 500, height: 500)),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.all(25),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _button(
                                    "START",
                                    () => routeService.navigate(2),Colors.amber,
                                    Icon(Icons.play_arrow)),
                                _button(
                                    "STORE",
                                    () => routeService.navigate(1),
                                    Colors.orange,
                                    Icon(Icons.store)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
              return Container();
            }),
    );
  }

  Widget _button(String text, Function onTap, Color color, Icon icon) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: RaisedButton.icon(
          padding: EdgeInsets.only(left: 50, right: 50, top: 10, bottom: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: color,
          onPressed: onTap,
          icon: icon,
          label: Text(
            text,
            style: TextStyle(fontSize: 22),
          )),
    );
  }
}
