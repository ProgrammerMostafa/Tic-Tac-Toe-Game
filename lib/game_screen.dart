import 'package:flutter/material.dart';
import './game_logic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameScreen extends StatefulWidget {
  String typeGame;
  GameScreen({
    Key? key,
    required this.typeGame,
  }) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String activePlayer = 'Player1';
  String winnerPlayer = 'Player1';
  bool gameOver = false;
  int turn = 0;
  Game game = Game();
  Map<String, int> score = {'Player1': 0, 'Player2': 0};
  FToast? fToast;
  bool isSettingScreen = false;
  ///////////////////////////////////////////////////
  List<String> gameIconsUrl = [
    'assets/images/gameIcons/greenX.png',
    'assets/images/gameIcons/greenO.png',
    'assets/images/gameIcons/greenHeart.png',
    'assets/images/gameIcons/greenStar.png',
    'assets/images/gameIcons/redO.png',
    'assets/images/gameIcons/redX.png',
    'assets/images/gameIcons/redHeart.png',
    'assets/images/gameIcons/redStar.png',
  ];

  @override
  void initState() {
    super.initState();
    ////////////////////
    getStoredData();
    ////////////////////
    Player.playerX = [];
    Player.playerO = [];
    Player.threeBtn = [];
    score = {'Player1': 0, 'Player2': 0};
    fToast = FToast()..init(context);
  }

  /////////////////////////////////////////////////////////
  List<String> _data = ['Player 1', 'Computer', '0', '4'];
  List<String> _dataNew = [];
  SharedPreferences? _prefs;
  void getStoredData() async {
    ///////////////// Get stored data //////////////////
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _data = _prefs!.getStringList(widget.typeGame)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    double _screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              ////////////////////////////////////////////////
              align_back_or_setting(Alignment.topLeft, context),
              ///////////////////////////////////////////////////////////////
              align_back_or_setting(Alignment.topRight, context),
              //////////////////////////////////////////////////////////
              //////////////////////////////////////////////////////////
              Column(
                children: [
                  ///////////////////////////////////////////
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: _screenHeight * 0.20,
                    margin: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ////////////// Player 1 Image //////////////
                              Opacity(
                                opacity: activePlayer == 'Player1' ? 1.0 : 0.4,
                                child:
                                    assetImage(_data[2], _screenHeight * 0.1),
                              ),
                              Text(
                                _data[0],
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ],
                          ),
                        ),
                        ////////////////// Score /////////////////
                        Align(
                          alignment: Alignment.center,
                          child: DefaultTextStyle(
                            style: Theme.of(context).textTheme.headline1!,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('  ${score['Player1']}'),
                                const Text(':'),
                                Text('${score['Player2']}  '),
                              ],
                            ),
                          ),
                        ),
                        ////////////// Player 2 Image //////////////
                        Align(
                          alignment: Alignment.centerRight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Opacity(
                                opacity: activePlayer == 'Player2' ? 1.0 : 0.4,
                                child:
                                    assetImage(_data[3], _screenHeight * 0.1),
                              ),
                              Text(
                                _data[1],
                                style: Theme.of(context).textTheme.headline3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  ////////////////////////////////////////////////////////////////////
                  /////////////////////////// Main Game /////////////////////////////
                  SizedBox(
                    width: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? MediaQuery.of(context).size.width
                        : MediaQuery.of(context).size.width / 1.4,
                    height: _screenHeight * 0.65,
                    child: mainGameFun(context, _screenHeight * 0.65),
                  ),
                  ////////////////////////////////////////////////////////////////////
                  //////////////////////// Play Again Button /////////////////////////
                  SizedBox(
                    height: _screenHeight * 0.15,
                    child: Center(
                      child: playAgainButton(
                        context,
                        MediaQuery.of(context).size.width / 2,
                        (_screenHeight * 0.10 >= 50
                            ? 50.0
                            : _screenHeight * 0.10),
                      ),
                    ),
                  ),
                ],
              ),

              if (isSettingScreen)
                _showContainerDialog(context, widget.typeGame),
            ],
          ),
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  Align align_back_or_setting(Alignment _alignment, BuildContext _ctx) {
    return Align(
      alignment: _alignment,
      child: InkWell(
        onTap: () {
          setState(() {
            if (_alignment == Alignment.topLeft) {
              Navigator.pop(_ctx);
            } else {
              _dataNew = _data.toList();
              isSettingScreen = true;
            }
          });
        },
        borderRadius: BorderRadius.circular(8),
        splashColor: Colors.deepOrange.withOpacity(0.1),
        child: Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(5),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.deepOrangeAccent,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _alignment == Alignment.topLeft
              ? Image.asset(
                  'assets/images/back.png',
                )
              : const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  Image assetImage(String _index, double _size) {
    return Image.asset(
      gameIconsUrl[int.parse(_index)],
      width: _size,
      height: _size,
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  GridView mainGameFun(BuildContext context, double _hSize) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        mainAxisExtent: _hSize / 4.0,
      ),
      itemCount: 9,
      primary: false,
      itemBuilder: (_, index) {
        return InkWell(
          splashColor: null,
          borderRadius: BorderRadius.circular(16.0),
          onTap: (gameOver ||
                  Player.playerX.contains(index) ||
                  Player.playerO.contains(index))
              ? null
              : () => _onTap(index),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).shadowColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Opacity(
              opacity: Player.threeBtn.isEmpty
                  ? 1.0
                  : (Player.threeBtn.contains(index) ? 1.0 : 0.2),
              child: LayoutBuilder(
                builder: (_c, cons) {
                  return Center(
                    child: Player.playerX.contains(index)
                        ? assetImage(_data[2], _hSize / 7)
                        : Player.playerO.contains(index)
                            ? assetImage(_data[3], _hSize / 7)
                            : null,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  Widget playAgainButton(context, double _w, double _h) {
    return Container(
      width: _w,
      height: _h,
      margin: const EdgeInsets.all(4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.deepOrangeAccent,
          width: 4.0,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            turn = 0;
            Player.playerX = [];
            Player.playerO = [];
            Player.threeBtn = [];
            activePlayer = winnerPlayer;
            if (widget.typeGame == 'Single' && winnerPlayer == 'Player2') {
              game.autoPlay(activePlayer);
              updateState();
            }
            gameOver = false;
          });
        },
        splashColor: Colors.deepOrange.withOpacity(0.3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.replay,
              color: Colors.white,
            ),
            Center(
              child: Text(
                ' Play Again',
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  _onTap(int index) async {
    game.playGame(index, activePlayer);
    updateState();

    //////////////// if you playing with computer
    if (widget.typeGame == 'Single' && !gameOver && turn != 9) {
      await game.autoPlay(activePlayer);
      updateState();
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  void updateState() {
    setState(() {
      ++turn;
      activePlayer = (activePlayer == 'Player1') ? 'Player2' : 'Player1';
      if (game.checkWinner() != '') {
        gameOver = true;
        winnerPlayer = game.checkWinner();
        activePlayer = winnerPlayer;
        score[winnerPlayer] = score[winnerPlayer]! + 1;
        showToastFun(winnerPlayer);
      } else if (turn == 9) {
        showToastFun('No');
      }
    });
  }

  //////////////////////////////////////////////////////////////////////////////
  void showToastFun(String winnerP) {
    List winnerList = [
      'assets/images/winnerIcons/winner1.png',
      'assets/images/winnerIcons/winner2.png',
      'assets/images/winnerIcons/winner3.png',
      'assets/images/winnerIcons/winner4.png',
      'assets/images/winnerIcons/winner5.png',
      'assets/images/winnerIcons/winner6.png',
      'assets/images/winnerIcons/winner7.png',
      'assets/images/winnerIcons/winner8.png',
    ];
    fToast!.showToast(
      child: Container(
        width: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).orientation == Orientation.portrait
                ? 1.2
                : 1.5),
        height: 80.0,
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.deepOrange,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).shadowColor,
        ),
        child: Center(
          child: winnerP == 'Player1'
              ? Image.asset(winnerList[int.parse(_data[2])])
              : winnerP == 'Player2'
                  ? Image.asset(winnerList[int.parse(_data[3])])
                  : Image.asset('assets/images/winnerIcons/noWinner.png'),
        ),
      ),
      gravity: ToastGravity.CENTER,
      toastDuration: const Duration(milliseconds: 1200),
    );
  }

  /////////////// Settings Button //////////////////
  _showContainerDialog(BuildContext _c, String typeGame) {
    int indexIcon = 0;
    return Container(
      color: Colors.black54,
      width: MediaQuery.of(_c).size.width,
      height: MediaQuery.of(_c).size.height,
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(_c).orientation == Orientation.portrait
            ? MediaQuery.of(_c).size.width
            : MediaQuery.of(_c).size.width / 1.6,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.deepOrange,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(_c).shadowColor,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Player 1',
                style: Theme.of(_c).textTheme.headline3,
              ),
              Divider(
                color: Colors.red[100],
                height: 15.0,
              ),
              ////////////////////////////////////////////////////
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ///////////// TextFormField (Player 1) //////////
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 4.0,
                    child: TextFormField(
                      initialValue: _dataNew[0],
                      maxLength: 8,
                      onChanged: (_newVal) {
                        setState(() {
                          _dataNew[0] = _newVal;
                        });
                      },
                    ),
                  ),
                  ///////////// Row (Player 1) //////////
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ///////////// IconButton_Left (Player 1) //////////
                      IconButton(
                        onPressed: () {
                          setState(() {
                            indexIcon = int.parse(_dataNew[2]);
                            if (indexIcon == 0) {
                              _dataNew[2] = '7';
                            } else {
                              _dataNew[2] = '${--indexIcon}';
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                        ),
                        splashRadius: 20.0,
                      ),
                      ///////////// Image (Player 1) //////////
                      assetImage(_dataNew[2], 35.0),
                      ///////////// IconButton_Right (Player 1) //////////
                      IconButton(
                        onPressed: () {
                          setState(() {
                            indexIcon = int.parse(_dataNew[2]);
                            if (indexIcon == 7) {
                              _dataNew[2] = '0';
                            } else {
                              _dataNew[2] = '${++indexIcon}';
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                        ),
                        splashRadius: 20.0,
                      ),
                    ],
                  ),
                ],
              ),
              ////////////////////////////////////////////////
              const SizedBox(
                height: 15,
              ),
              ////////////////////////////////////////////////
              Text(
                typeGame == 'Single' ? 'Computer' : 'Player 2',
                style: Theme.of(context).textTheme.headline3,
              ),
              Divider(
                color: Colors.red[100],
                height: 15.0,
              ),
              ///////////////////////////////////////////////////
              ///////////////////////////////////////////////////
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ///////////// TextFormField (Player 2) //////////
                  SizedBox(
                    width: MediaQuery.of(_c).size.width / 4.0,
                    child: TextFormField(
                      initialValue: _dataNew[1],
                      maxLength: 8,
                      onChanged: (_newVal) {
                        setState(() {
                          _dataNew[1] = _newVal;
                        });
                      },
                      enabled: typeGame == 'Single' ? false : true,
                    ),
                  ),
                  ///////////// Row (Player 2) //////////
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ///////////// IconButton_Left (Player 2) //////////
                      IconButton(
                        onPressed: () {
                          setState(() {
                            indexIcon = int.parse(_dataNew[3]);
                            if (indexIcon == 0) {
                              _dataNew[3] = '7';
                            } else {
                              _dataNew[3] = '${--indexIcon}';
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                        ),
                        splashRadius: 20.0,
                      ),
                      ///////////// Image (Player 2) //////////
                      assetImage(_dataNew[3], 35.0),
                      ///////////// IconButton_Right (Player 2) //////////
                      IconButton(
                        onPressed: () {
                          setState(() {
                            indexIcon = int.parse(_dataNew[3]);
                            if (indexIcon == 7) {
                              _dataNew[3] = '0';
                            } else {
                              _dataNew[3] = '${++indexIcon}';
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                        ),
                        splashRadius: 20.0,
                      ),
                    ],
                  ),
                ],
              ),
              ////////////////////////////////////////////////////////////
              /////////////////////// Two Buttons /////////////////////////
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /////////////////////// Save Button /////////////////////////
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          if (_dataNew[2] != _dataNew[3]) {
                            _data = _dataNew;
                            _prefs!.setStringList(widget.typeGame, _dataNew);
                            isSettingScreen = false; // To Cancel setting screen
                          } else {
                            showDialog(
                              context: context,
                              builder: (_) => const AlertDialog(
                                elevation: 3,
                                backgroundColor: Colors.black54,
                                title: Text('Not Saved'),
                                content: Text('Selected Icons is Similar'),
                              ),
                            );
                          }
                        });
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Save'),
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        elevation: MaterialStateProperty.all(1.0),
                      ),
                    ),
                  ),
                  /////////////////////////////////////////////////
                  const SizedBox(
                    width: 20,
                  ),
                  /////////////////////// Cancel Button /////////////////////////
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() {
                          isSettingScreen = false; // To Cancel setting screen
                        });
                      },
                      icon: const Icon(Icons.cancel),
                      label: const Text('Cancel'),
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all(Colors.redAccent),
                        elevation: MaterialStateProperty.all(1.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
