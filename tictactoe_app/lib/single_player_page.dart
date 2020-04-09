import 'package:flutter/material.dart';
import 'package:tictactoeapp/custom_dialog.dart';
import 'package:tictactoeapp/game_button.dart';
import 'dart:math';

class SinglePlayerPage extends StatefulWidget {
  @override
  _SinglePlayerPageState createState() => _SinglePlayerPageState();
}

class _SinglePlayerPageState extends State<SinglePlayerPage> {
  List buttonsList;
  var player1;
  var player2;
  var activePlayer;

  @override
  void initState() {
    super.initState();
    buttonsList = doInit();
  }

  List doInit() {
    player1 = List();
    player2 = List();
    activePlayer = 1;

    var gameButtons = <GameButton>[
      GameButton(id: 1),
      GameButton(id: 2),
      GameButton(id: 3),
      GameButton(id: 4),
      GameButton(id: 5),
      GameButton(id: 6),
      GameButton(id: 7),
      GameButton(id: 8),
      GameButton(id: 9),
    ];
    return gameButtons;
  }

  void playGame(GameButton gb) {
    setState(() {
      if (activePlayer == 1) {
        gb.text = "X";
        gb.bg = Colors.purple;
        activePlayer = 2;
        player1.add(gb.id);
      } else {
        gb.text = "O";
        gb.bg = Colors.greenAccent;
        activePlayer = 1;
        player2.add(gb.id);
      }
      gb.enabled = false;
      int winner = checkWinner();
      if (winner == -1) {
        if (buttonsList.every((p) => p.text != "")) {
          showDialog(
              context: context,
              builder: (_) =>
                  CustomDialog(
                      "Draw :/", "Press reset to to play again", resetGame));
        }
        else {
          activePlayer == 2 ? autoPlay() : null;
        }
      }
    });
  }

  void autoPlay() {
    var emptyCells = List();
    var list = List.generate(9, (i) => i + 1);
    for (var cellId in list) {
      if (!(player1.contains(cellId) || player2.contains(cellId))) {
        emptyCells.add(cellId);
      }
    }

    var r = new Random();
    var randIndex = r.nextInt(emptyCells.length - 1);
    int i = buttonsList.indexWhere((p) => p.id == emptyCells[randIndex]);
    playGame(buttonsList[i]);
  }

  int checkWinner() {
    var winner = -1;
    if (player1.contains(1) && player1.contains(2) && player1.contains(3))
      winner = 1;
    if (player2.contains(1) && player2.contains(2) && player2.contains(3))
      winner = 2;

    if (player1.contains(4) && player1.contains(5) && player1.contains(6))
      winner = 1;
    if (player2.contains(4) && player2.contains(5) && player2.contains(6))
      winner = 2;

    if (player1.contains(7) && player1.contains(8) && player1.contains(9))
      winner = 1;
    if (player2.contains(7) && player2.contains(8) && player2.contains(9))
      winner = 2;

    if (player1.contains(1) && player1.contains(4) && player1.contains(7))
      winner = 1;
    if (player2.contains(1) && player2.contains(4) && player2.contains(7))
      winner = 2;

    if (player1.contains(2) && player1.contains(5) && player1.contains(8))
      winner = 1;
    if (player2.contains(2) && player2.contains(5) && player2.contains(8))
      winner = 2;

    if (player1.contains(3) && player1.contains(6) && player1.contains(9))
      winner = 1;
    if (player2.contains(3) && player2.contains(6) && player2.contains(9))
      winner = 2;

    if (player1.contains(1) && player1.contains(5) && player1.contains(9))
      winner = 1;
    if (player2.contains(1) && player2.contains(5) && player2.contains(9))
      winner = 2;

    if (player1.contains(3) && player1.contains(5) && player1.contains(7))
      winner = 1;
    if (player2.contains(3) && player2.contains(5) && player2.contains(7))
      winner = 2;

    if (winner != -1) {
      if (winner == 1) {
        showDialog(
            context: context,
            builder: (_) =>
                CustomDialog(
                    "Player 1 won", "Press reset to to play again", resetGame));
      } else {
        showDialog(
            context: context,
            builder: (_) =>
                CustomDialog(
                    "Player 2 won", "Press reset to to play again", resetGame));
      }
    }
    return winner;
  }

  void resetGame() {
    if (Navigator.canPop(context)) Navigator.pop(context);
    setState(() {
      buttonsList = doInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tic Tac Toe"),
      ),
      body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: GridView.builder(
                    padding: EdgeInsets.all(20),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1,
                        crossAxisSpacing: 9,
                        mainAxisSpacing: 9),
                    itemCount: buttonsList.length,
                    itemBuilder: (context, i) =>
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: RaisedButton(
                            padding: EdgeInsets.all(10),
                            onPressed: buttonsList[i].enabled
                                ? () => playGame(buttonsList[i])
                                : null,
                            child: Text(
                              buttonsList[i].text,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                              ),
                            ),
                            color: buttonsList[i].bg,
                            disabledColor: buttonsList[i].bg,
                          ),
                        )),
              ),
              RaisedButton(
                child: Text("Reset",
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                color: Colors.red,
                padding: EdgeInsets.all(20),
                onPressed: () {
                  setState(() {
                    buttonsList = doInit();
                  });
                },
              )
            ],
          )),
    );
  }
}
