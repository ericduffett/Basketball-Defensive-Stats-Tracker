import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:possessions_app/OverallStatsWidget.dart';
import 'package:possessions_app/QuarterScoreWidget.dart';
import 'package:possessions_app/TimeOutWidget.dart';
import 'package:provider/provider.dart';
import 'HistoryWidget.dart';
import 'Possession.dart';
import 'package:dots_indicator/dots_indicator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalHistory>(
            builder: (context) => GlobalHistory()
        ),
        ChangeNotifierProvider<GameStatus>(
          builder: (context) => GameStatus(),
        ),
        ChangeNotifierProvider<DefensesUsed>(
          builder: (context) => DefensesUsed(),
        ),
        ChangeNotifierProvider<Timeouts>(
          builder: (context) => Timeouts(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
          'history': (context) => HistoryWidget(),
        },
      ),
    );
  }
}


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  GlobalKey scaffoldKey = GlobalKey();

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final Defense ntOffense = Defense('NT');

  @override
  Widget build(BuildContext context) {

    final defensesUsedProvider = Provider.of<DefensesUsed>(context);
    final ourTimeouts = Provider.of<Timeouts>(context);

    return Consumer<GlobalHistory>(
        builder: (context, history, child) {
          return Scaffold(
            appBar: AppBar(
              leading: UndoIconButton(defensesUsed: defensesUsedProvider.defensesUsed,),
              actions: <Widget>[
                FlatButton(
                  child: Text('Overall Stats',
                    style: TextStyle(
                      color: Colors.white,
                    ),),
                  onPressed: () {
                    showDialog(context: context, builder: (context) {
                      return OverallStats(history: history,);
                    } );
                  },
                ),
                FlatButton(
                  child: Text('Timeouts',
                    style: TextStyle(
                        color: Colors.white
                    ),),
                  onPressed: () {
                    showDialog(context: context, builder: (context) {
                      return TimeoutsWidget(timeouts: ourTimeouts,);
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.list),
                  onPressed: () {

                    Navigator.of(context).pushNamed('history');

                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Add a Defense'),
                            content: TextField(
                              autofocus: true,
                              controller: _controller,
                              focusNode: _focusNode,
                              decoration: InputDecoration(
                                  labelText: 'Defense Name'
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  _controller.clear();
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text('Add',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),),
                                onPressed: () {

                                  bool foundMatch = false;

                                  for (var i = 0; i < defensesUsedProvider.defensesUsed.length; i += 1){
                                    print(defensesUsedProvider.defensesUsed[i].defenseType);
                                    if (defensesUsedProvider.defensesUsed[i].defenseType == _controller.text) {
                                      print('match!!!');
                                      showDialog(context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text('Cannot add defense with same name. Please try again.'),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('OK'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                      foundMatch = true;
                                      break;
                                    }
                                  }

                                  if (!foundMatch) {
                                    defensesUsedProvider.addDefense(Defense(_controller.text));
                                    _controller.clear();
                                    Navigator.of(context).pop();
                                  }


                                },
                              ),
                            ],
                          );
                        });
                  },
                )
              ],
            ),
            body: ListOfDefenses(defenses: defensesUsedProvider.defensesUsed, ntOffense: ntOffense,),
          );
        }
    );
  }
}

class ListOfDefenses extends StatefulWidget {

  final List <Defense> defenses;
  final Defense ntOffense;

  const ListOfDefenses({Key key, this.defenses, this.ntOffense}) : super(key: key);

  @override
  _ListOfDefensesState createState() => _ListOfDefensesState();
}

class _ListOfDefensesState extends State<ListOfDefenses> {


  Future <bool> confirmDismiss(String defenseName) async {

    bool dismiss;

    if (defenseName == 'Transition' || defenseName == 'BLOB') {
      dismiss = false;
    } else {
      await showDialog(context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Are you sure you want to delete $defenseName?'),
              content: Text('All stats for this defense will be lost.'),
              actions: <Widget>[
                FlatButton(
                    child: Text('Yes'),
                    onPressed: () {
                      Navigator.of(context).pop();
                      dismiss = true;
                    }
                ),
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    dismiss = false;
                  },
                ),
              ],
            );
          });
    }

    return dismiss;
  }


  @override
  Widget build(BuildContext context) {

    final defensesUsedProvider = Provider.of<DefensesUsed>(context);
    final globalDefensesProvider = Provider.of<GlobalHistory>(context);

    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            height: MediaQuery.of(context).size.height - AppBar().preferredSize.height - 100,
            color: Colors.transparent,
            child: ListView.separated(
              itemCount: widget.defenses.length + 1,
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemBuilder: (context, index) {

                if (index != widget.defenses.length) {
                  return Dismissible(
                      key: Key(defensesUsedProvider.defensesUsed[index].defenseType),
                      onDismissed: (direction) {
                        globalDefensesProvider.removeAllOfDefenseType(defensesUsedProvider.defensesUsed[index]);
                        defensesUsedProvider.removeDefense(defensesUsedProvider.defensesUsed[index]);

                      },
                      confirmDismiss: (direction) {
                        return confirmDismiss(widget.defenses[index].defenseType);
                      },
                      child: DefenseTypeRow(defense: widget.defenses[index])
                  );
                } else {
                  return NTOffenseRow(defense: widget.ntOffense);
                }


              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: Colors.black,
                    width: 1.0)
            ),
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                QuarterScoreWidget(quarter: Quarter.First,),
                QuarterScoreWidget(quarter: Quarter.Second,),
                QuarterScoreWidget(quarter: Quarter.Third,),
                QuarterScoreWidget(quarter: Quarter.Fourth,),
              ],
            ),
          ),
        ),
      ],

    );
  }
}



class DefenseTypeRow extends StatefulWidget {

  final Defense defense;

  const DefenseTypeRow({Key key, this.defense}) : super(key: key);


  @override
  _DefenseTypeRowState createState() => _DefenseTypeRowState();
}

class _DefenseTypeRowState extends State<DefenseTypeRow> {

  static const buttonPadding = 8.0;

  final pageController = PageController(initialPage: 0);

  int _pageNumber = 0;

  onPageSwiped(int newPage) {
    setState(() {
      _pageNumber = newPage.toInt();
    });
  }




  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<GlobalHistory>(context);
    final gameStatusProvider = Provider.of<GameStatus>(context);
    final defensesUsedProvider = Provider.of<DefensesUsed>(context);

    showButtonTapSnack(PossessionEnds possessionEnds) {

      final Defense defense = Defense('');
      final lastDefenseResultAsString = defense.possessionHistoryAsString(widget.defense.possessionHistory.last);
      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Added $lastDefenseResultAsString in NT ${widget.defense.defenseType}.',
              textAlign: TextAlign.center,),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
            shape: RoundedRectangleBorder(),
            behavior: SnackBarBehavior.floating,
          ));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(buttonPadding),
            child: GestureDetector(
              onDoubleTap: () {

                final TextEditingController _controller = TextEditingController();
                final FocusNode _focusNode = FocusNode();

                showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Change Defense Name'),
                        content: TextField(
                          autofocus: true,
                          controller: _controller,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                              labelText: 'Defense Name'
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              _controller.clear();
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text('Change Name',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),),
                            onPressed: () {

                              setState(() {
                                defensesUsedProvider.changeDefenseName(widget.defense, _controller.text);
                              });

                              _controller.clear();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    });
              },
              child: Container(
                width: 50,
                child: Text(widget.defense.defenseType,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  RaisedButton(
                    child: Text('Make 2',
                      style: TextStyle(
                          color: Colors.white
                      ),),
                    color: Colors.deepOrange[700],
                    onPressed: () {
                      setState(() {
                        widget.defense.addStat(PossessionEnds.twoPointMake, gameStatusProvider.half);
                        provider.addPossession(widget.defense, gameStatusProvider.quarter);
                        showButtonTapSnack(PossessionEnds.twoPointMake);
                      });
                    },
                  ),
                  SizedBox(
                    width: buttonPadding/2,
                  ),
                  RaisedButton(
                    child: Text('Make 3',
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                    color: Colors.deepOrange[700],
                    onPressed: () {
                      setState(() {
                        widget.defense.addStat(PossessionEnds.threePointMake, gameStatusProvider.half);
//                        widget.defense.threePointMakes += 1;
//                        widget.defense.possessionHistory.add(PossessionEnds.threePointMake);
                        provider.addPossession(widget.defense, gameStatusProvider.quarter);
                        showButtonTapSnack(PossessionEnds.threePointMake);
                        //globalPossessionHistory.add(widget.defense);
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  RaisedButton(
                    child: Text('Miss 2',
                      style: TextStyle(
                          color: Colors.green[700]
                      ),
                    ),
                    color: Colors.white,
                    shape: Border.all(
                        color: Colors.green[700]
                    ),
                    onPressed: () {
                      setState(() {
                        widget.defense.addStat(PossessionEnds.twoPointMiss, gameStatusProvider.half);
//                        widget.defense.twoPointMisses += 1;
//                        widget.defense.possessionHistory.add(PossessionEnds.twoPointMiss);
                        provider.addPossession(widget.defense, gameStatusProvider.quarter);
                        showButtonTapSnack(PossessionEnds.twoPointMiss);
                        //globalPossessionHistory.add(widget.defense);
                      });
                    },
                  ),
                  SizedBox(
                    width: buttonPadding/2,
                  ),
                  RaisedButton(
                    child: Text('Miss 3',
                      style: TextStyle(
                          color: Colors.green[700]
                      ),
                    ),
                    color: Colors.white,
                    shape: Border.all(
                        color: Colors.green[700]
                    ),
                    onPressed: () {
                      setState(() {
                        widget.defense.addStat(PossessionEnds.threePointMiss, gameStatusProvider.half);
                        provider.addPossession(widget.defense, gameStatusProvider.quarter);
                        showButtonTapSnack(PossessionEnds.threePointMiss);
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            width: buttonPadding,
          ),
          Column(
            children: <Widget>[
              SizedBox(
                width: 98,
                child: RaisedButton(
                  child: Text('O-Board',
                    style: TextStyle(
                        color: Colors.deepOrange[700]
                    ),
                  ),
                  color: Colors.white,
                  shape: Border.all(
                    color: Colors.deepOrange[700],
                  ),
                  onPressed: () {
                    setState(() {
                      widget.defense.addStat(PossessionEnds.oBoard, gameStatusProvider.half);
                      provider.addPossession(widget.defense, gameStatusProvider.quarter);
                      showButtonTapSnack(PossessionEnds.oBoard);
                    });
                  },
                ),
              ),
              SizedBox(
                width: 98,
                child: RaisedButton(
                  child: Text('Turnover',
                    style: TextStyle(
                        color: Colors.green[700]
                    ),
                  ),
                  color: Colors.white,
                  shape: Border.all(
                      color: Colors.green[700]
                  ),
                  onPressed: () {
                    setState(() {
                      widget.defense.addStat(PossessionEnds.turnover, gameStatusProvider.half);
                      provider.addPossession(widget.defense, gameStatusProvider.quarter);
                      showButtonTapSnack(PossessionEnds.turnover);
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            width: buttonPadding,
          ),
          Column(
            children: <Widget>[
              RaisedButton(
                child: Text('Free Throw',
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
                color: Colors.deepOrange[700],
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: Text('Make or Miss?'),
                          actions: <Widget>[
                            FlatButton(
                                child: Text('Miss'),
                                onPressed: () {
                                  setState(() {
                                    widget.defense.addStat(PossessionEnds.freeThrowMiss, gameStatusProvider.half);
                                    provider.addPossession(widget.defense, gameStatusProvider.quarter);
                                  });
                                  Navigator.of(context).pop();
                                }
                            ),
                            FlatButton(
                                child: Text('Make'),
                                onPressed: () {
                                  setState(() {
                                    widget.defense.addStat(PossessionEnds.freeThrowMake, gameStatusProvider.half);
                                    provider.addPossession(widget.defense, gameStatusProvider.quarter);
                                  });
                                  Navigator.of(context).pop();
                                }
                            )
                          ],
                        );
                      });
                },
              ),
              SizedBox(
                width: 98,
                child: RaisedButton(
                  child: Text('Foul',
                    style: TextStyle(
                      color: Colors.deepOrange[700],
                    ),
                  ),
                  color: Colors.white,
                  shape: Border.all(
                      color: Colors.deepOrange[700]
                  ),
                  onPressed: () {
                    setState(() {
                      widget.defense.addStat(PossessionEnds.foul, gameStatusProvider.half);
                      provider.addPossession(widget.defense, gameStatusProvider.quarter);
                    });
                    showDialog(
                        barrierDismissible: false,
                        context: (context),
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Did this foul result in free throws?'),
                            content: Text('Say yes to end the possession.'),
                            actions: <Widget>[
                              FlatButton(
                                  child: Text('Yes'),
                                  onPressed: () {
                                    setState(() {
                                      widget.defense.addStat(PossessionEnds.foulEndedPossession, gameStatusProvider.half);
                                      provider.addPossession(widget.defense, gameStatusProvider.quarter);
                                    });
                                    Navigator.of(context).pop();
                                  }
                              ),
                              FlatButton(
                                child: Text('No'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          );
                        });
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 8.0,),
                Container(
                  height: 150,
                  child: PageView(
                    controller: pageController,
                    onPageChanged: (newPage) {
                      onPageSwiped(newPage);
                    },
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('Full Game',
                            textAlign: TextAlign.center,
                          ),
                          Text('Points per possession: ${widget.defense.pointsPerPossession} (${widget.defense.hudlPointsPerPossession})',
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('Possessions: ${widget.defense.possessions}'),
                              Text('Points: ${widget.defense.points}'),
                            ],
                          ),
                          SizedBox(
                            height: buttonPadding/2,
                          ),
                          Column(
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text('Turnovers: ${widget.defense.turnovers}'),
                                      Text('O-Boards: ${widget.defense.oBoards}'),
                                      Text('2-Pointers: ${widget.defense.twoPointMakes}/${widget.defense.twoPointAttempts}'),
                                      Text('3-Pointers: ${widget.defense.threePointMakes}/${widget.defense.threePointAttempts}'),


                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text('FG%: ${widget.defense.fieldGoalPercentage}'),
                                      Text('3FG%: ${widget.defense.threePointPercentage}'),
                                      Text('TO%: ${widget.defense.turnoverPercentage}'),
                                      Text('DReb %: ${widget.defense.dBoardPercentage}'),

                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: buttonPadding/2,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text('Fouls: ${widget.defense.fouls}'),
                                  Text('FTs: ${widget.defense.freeThrowMakes}/${widget.defense.freeThrowAttempts}'),
                                  Text('FT %: ${widget.defense.freeThrowPercentage}')
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      //FIRST HALF
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('First Half',
                            textAlign: TextAlign.center,
                          ),
                          Text('Points per possession: ${widget.defense.pointsPerPossessionFirstHalf} (${widget.defense.hudlPointsPerPossessionFirstHalf})',
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('Possessions: ${widget.defense.possessionsFirstHalf}'),
                              Text('Points: ${widget.defense.pointsFirstHalf}'),
                            ],
                          ),
                          SizedBox(
                            height: buttonPadding/2,
                          ),
                          Column(
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text('Turnovers: ${widget.defense.turnoversFirstHalf}'),
                                      Text('O-Boards: ${widget.defense.oBoardsFirstHalf}'),
                                      Text('2-Pointers: ${widget.defense.twoPointMakesFirstHalf}/${widget.defense.twoPointAttemptsFirstHalf}'),
                                      Text('3-Pointers: ${widget.defense.threePointMakesFirstHalf}/${widget.defense.threePointAttemptsFirstHalf}'),


                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text('FG%: ${widget.defense.fieldGoalPercentageFirstHalf}'),
                                      Text('3FG%: ${widget.defense.threePointPercentageFirstHalf}'),
                                      Text('TO%: ${widget.defense.turnoverPercentageFirstHalf}'),
                                      Text('DReb %: ${widget.defense.dBoardPercentageFirstHalf}'),

                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: buttonPadding/2,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text('Fouls: ${widget.defense.foulsFirstHalf}'),
                                  Text('FTs: ${widget.defense.freeThrowMakesFirstHalf}/${widget.defense.freeThrowAttemptsFirstHalf}'),
                                  Text('FT %: ${widget.defense.freeThrowPercentageFirstHalf}')
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      //SECOND HALF
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text('Second Half',
                            textAlign: TextAlign.center,
                          ),
                          Text('Points per possession: ${widget.defense.pointsPerPossessionSecondHalf} (${widget.defense.hudlPointsPerPossessionSecondHalf})',
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('Possessions: ${widget.defense.possessionsSecondHalf}'),
                              Text('Points: ${widget.defense.pointsSecondHalf}'),
                            ],
                          ),
                          SizedBox(
                            height: buttonPadding/2,
                          ),
                          Column(
                            children: <Widget>[
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text('Turnovers: ${widget.defense.turnoversSecondHalf}'),
                                      Text('O-Boards: ${widget.defense.oBoardsSecondHalf}'),
                                      Text('2-Pointers: ${widget.defense.twoPointMakesSecondHalf}/${widget.defense.twoPointAttemptsSecondHalf}'),
                                      Text('3-Pointers: ${widget.defense.threePointMakesSecondHalf}/${widget.defense.threePointAttemptsSecondHalf}'),


                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text('FG%: ${widget.defense.fieldGoalPercentageSecondHalf}'),
                                      Text('3FG%: ${widget.defense.threePointPercentageSecondHalf}'),
                                      Text('TO%: ${widget.defense.turnoverPercentageSecondHalf}'),
                                      Text('DReb %: ${widget.defense.dBoardPercentageSecondHalf}'),

                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: buttonPadding/2,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text('Fouls: ${widget.defense.foulsSecondHalf}'),
                                  Text('FTs: ${widget.defense.freeThrowMakesSecondHalf}/${widget.defense.freeThrowAttemptsSecondHalf}'),
                                  Text('FT %: ${widget.defense.freeThrowPercentageSecondHalf}')
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 4.0,
                ),
                DotsIndicator(
                  dotsCount: 3,
                  position: _pageNumber,
                  decorator: DotsDecorator(
                      activeColor: Colors.deepOrange
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class NTOffenseRow extends StatefulWidget {

  final Defense defense;

  const NTOffenseRow({Key key, this.defense}) : super(key: key);


  @override
  _NTOffenseRowState createState() => _NTOffenseRowState();
}

class _NTOffenseRowState extends State<NTOffenseRow> {

  static const buttonPadding = 8.0;
  final pageController = PageController(initialPage: 0);
  int _pageNumber = 0;

  onPageSwiped(int newPage) {
    setState(() {
      _pageNumber = newPage.toInt();
    });
  }



  showButtonTapSnack(PossessionEnds possessionEnds) {

    final Defense defense = Defense('');
    final lastDefenseResultAsString = defense.possessionHistoryAsString(widget.defense.possessionHistory.last);
    Scaffold.of(context).removeCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Added $lastDefenseResultAsString in NT Offense.',
            textAlign: TextAlign.center,),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
          shape: RoundedRectangleBorder(),
          behavior: SnackBarBehavior.floating,
        ));
  }




  @override
  Widget build(BuildContext context) {

    //final provider = Provider.of<GlobalHistory>(context);
    //final gameStatusProvider = Provider.of<GameStatus>(context);

    return Consumer<GameStatus>(
        builder: (context, gameStatusProvider, _) {

          removeLastPossession() {
            print('remove');
            final lastDefenseResultAsString = widget.defense.possessionHistoryAsString(widget.defense.possessionHistory.last);
            setState(() {
              widget.defense.removeLastPossession(gameStatusProvider.half);
            });
            Scaffold.of(context).removeCurrentSnackBar();
            Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Removed $lastDefenseResultAsString in NT Offense.',
                    textAlign: TextAlign.center,),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                  shape: RoundedRectangleBorder(),
                  behavior: SnackBarBehavior.floating,
                ));
          }

          return Container(
            color: Colors.green[500],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(buttonPadding),
                        child: Container(
                          width: 50,
                          child: Text(widget.defense.defenseType,
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              RaisedButton(
                                child: Text('Make 2',
                                  style: TextStyle(
                                      color: Colors.white
                                  ),),
                                color: Colors.blue[900],
                                onPressed: () {
                                  setState(() {
                                    widget.defense.addStat(
                                        PossessionEnds.twoPointMake,
                                        gameStatusProvider.half);
                                    showButtonTapSnack(PossessionEnds.twoPointMake);
                                    // provider.addPossession(widget.defense, gameStatusProvider.quarter);
                                  });
                                },
                              ),
                              SizedBox(
                                width: buttonPadding / 2,
                              ),
                              RaisedButton(
                                child: Text('Make 3',
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                                color: Colors.blue[900],
                                onPressed: () {
                                  setState(() {
                                    widget.defense.addStat(
                                        PossessionEnds.threePointMake,
                                        gameStatusProvider.half);
                                    showButtonTapSnack(PossessionEnds.threePointMake);
//                        widget.defense.threePointMakes += 1;
//                        widget.defense.possessionHistory.add(PossessionEnds.threePointMake);
                                    //  provider.addPossession(widget.defense, gameStatusProvider.quarter);
                                    //globalPossessionHistory.add(widget.defense);
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              RaisedButton(
                                child: Text('Miss 2',
                                  style: TextStyle(
                                      color: Colors.green[700]
                                  ),
                                ),
                                color: Colors.white,
                                shape: Border.all(
                                    color: Colors.green[700]
                                ),
                                onPressed: () {
                                  setState(() {
                                    widget.defense.addStat(
                                        PossessionEnds.twoPointMiss,
                                        gameStatusProvider.half);
                                    showButtonTapSnack(PossessionEnds.twoPointMiss);
//                        widget.defense.twoPointMisses += 1;
//                        widget.defense.possessionHistory.add(PossessionEnds.twoPointMiss);
                                    //  provider.addPossession(widget.defense, gameStatusProvider.quarter);
                                    //globalPossessionHistory.add(widget.defense);
                                  });
                                },
                              ),
                              SizedBox(
                                width: buttonPadding / 2,
                              ),
                              RaisedButton(
                                child: Text('Miss 3',
                                  style: TextStyle(
                                      color: Colors.green[700]
                                  ),
                                ),
                                color: Colors.white,
                                shape: Border.all(
                                    color: Colors.green[700]
                                ),
                                onPressed: () {
                                  setState(() {
                                    widget.defense.addStat(
                                        PossessionEnds.threePointMiss,
                                        gameStatusProvider.half);
                                    showButtonTapSnack(PossessionEnds.threePointMiss);
                                    // provider.addPossession(widget.defense, gameStatusProvider.quarter);
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: buttonPadding,
                      ),
                      Column(
                        children: <Widget>[
                          SizedBox(
                            width: 98,
                            child: RaisedButton(
                              child: Text('O-Board',
                                style: TextStyle(
                                    color: Colors.blue[900]
                                ),
                              ),
                              color: Colors.white,
                              shape: Border.all(
                                color: Colors.blue[900],
                              ),
                              onPressed: () {
                                setState(() {
                                  widget.defense.addStat(
                                      PossessionEnds.oBoard, gameStatusProvider.half);
                                  showButtonTapSnack(PossessionEnds.oBoard);
                                  // provider.addPossession(widget.defense, gameStatusProvider.quarter);
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: 98,
                            child: RaisedButton(
                              child: Text('Turnover',
                                style: TextStyle(
                                    color: Colors.green[700]
                                ),
                              ),
                              color: Colors.white,
                              shape: Border.all(
                                  color: Colors.green[700]
                              ),
                              onPressed: () {
                                setState(() {
                                  widget.defense.addStat(PossessionEnds.turnover,
                                      gameStatusProvider.half);
                                  showButtonTapSnack(PossessionEnds.turnover);
                                  //  provider.addPossession(widget.defense, gameStatusProvider.quarter);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: buttonPadding,
                      ),
                      Column(
                        children: <Widget>[
                          RaisedButton(
                            child: Text('Free Throw',
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                            color: Colors.blue[900],
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Make or Miss?'),
                                      actions: <Widget>[
                                        FlatButton(
                                            child: Text('Miss'),
                                            onPressed: () {
                                              setState(() {
                                                widget.defense.addStat(
                                                    PossessionEnds.freeThrowMiss,
                                                    gameStatusProvider.half);
                                                //  provider.addPossession(widget.defense, gameStatusProvider.quarter);
                                              });
                                              Navigator.of(context).pop();
                                            }
                                        ),
                                        FlatButton(
                                            child: Text('Make'),
                                            onPressed: () {
                                              setState(() {
                                                widget.defense.addStat(
                                                    PossessionEnds.freeThrowMake,
                                                    gameStatusProvider.half);
                                                //  provider.addPossession(widget.defense, gameStatusProvider.quarter);
                                              });
                                              Navigator.of(context).pop();
                                            }
                                        )
                                      ],
                                    );
                                  });
                            },
                          ),
                          SizedBox(
                            width: 98,
                            child: RaisedButton(
                              child: Text('Foul',
                                style: TextStyle(
                                  color: Colors.blue[900],
                                ),
                              ),
                              color: Colors.white,
                              shape: Border.all(
                                  color: Colors.blue[900]
                              ),
                              onPressed: () {
                                setState(() {
                                  widget.defense.addStat(
                                      PossessionEnds.foul, gameStatusProvider.half);
                                  //  provider.addPossession(widget.defense, gameStatusProvider.quarter);
                                });
                                showDialog(
                                    barrierDismissible: false,
                                    context: (context),
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                            'Did this foul result in free throws?'),
                                        content: Text(
                                            'Say yes to end the possession.'),
                                        actions: <Widget>[
                                          FlatButton(
                                              child: Text('Yes'),
                                              onPressed: () {
                                                setState(() {
                                                  widget.defense.addStat(
                                                      PossessionEnds
                                                          .foulEndedPossession,
                                                      gameStatusProvider.half);
                                                  //      provider.addPossession(widget.defense, gameStatusProvider.quarter);
                                                });
                                                Navigator.of(context).pop();
                                              }
                                          ),
                                          FlatButton(
                                            child: Text('No'),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                        ],
                                      );
                                    });
                              },
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 8.0,),
                            Container(
                              height: 150,
                              child: PageView(
                                controller: pageController,
                                onPageChanged: (newPage) {
                                  onPageSwiped(newPage);
                                },
                                children: <Widget>[
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text('Full Game',
                                        textAlign: TextAlign.center,
                                      ),
                                      Text('Points per possession: ${widget.defense
                                          .pointsPerPossession} (${widget.defense.hudlPointsPerPossession})',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceEvenly,
                                        children: <Widget>[
                                          Text('Possessions: ${widget.defense
                                              .possessions}'),
                                          Text('Points: ${widget.defense.points}'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: buttonPadding / 2,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceAround,
                                            children: <Widget>[
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment
                                                    .start,
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .center,
                                                children: <Widget>[
                                                  Text('Turnovers: ${widget.defense
                                                      .turnovers}'),
                                                  Text('O-Boards: ${widget.defense
                                                      .oBoards}'),
                                                  Text('2-Pointers: ${widget.defense
                                                      .twoPointMakes}/${widget.defense
                                                      .twoPointAttempts}'),
                                                  Text('3-Pointers: ${widget.defense
                                                      .threePointMakes}/${widget
                                                      .defense.threePointAttempts}'),


                                                ],
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  Text('FG%: ${widget.defense
                                                      .fieldGoalPercentage}'),
                                                  Text('3FG%: ${widget.defense
                                                      .threePointPercentage}'),
                                                  Text('TO%: ${widget.defense
                                                      .turnoverPercentage}'),
                                                  Text('DReb %: ${widget.defense
                                                      .dBoardPercentage}'),

                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: buttonPadding / 2,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceEvenly,
                                            children: <Widget>[
                                              Text('Fouls: ${widget.defense.fouls}'),
                                              Text('FTs: ${widget.defense
                                                  .freeThrowMakes}/${widget.defense
                                                  .freeThrowAttempts}'),
                                              Text('FT %: ${widget.defense
                                                  .freeThrowPercentage}')
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  //FIRST HALF
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text('First Half',
                                        textAlign: TextAlign.center,
                                      ),
                                      Text('Points per possession: ${widget.defense
                                          .pointsPerPossessionFirstHalf} (${widget.defense.hudlPointsPerPossessionFirstHalf})',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceEvenly,
                                        children: <Widget>[
                                          Text('Possessions: ${widget.defense
                                              .possessionsFirstHalf}'),
                                          Text('Points: ${widget.defense
                                              .pointsFirstHalf}'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: buttonPadding / 2,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceAround,
                                            children: <Widget>[
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment
                                                    .start,
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .center,
                                                children: <Widget>[
                                                  Text('Turnovers: ${widget.defense
                                                      .turnoversFirstHalf}'),
                                                  Text('O-Boards: ${widget.defense
                                                      .oBoardsFirstHalf}'),
                                                  Text('2-Pointers: ${widget.defense
                                                      .twoPointMakesFirstHalf}/${widget
                                                      .defense
                                                      .twoPointAttemptsFirstHalf}'),
                                                  Text('3-Pointers: ${widget.defense
                                                      .threePointMakesFirstHalf}/${widget
                                                      .defense
                                                      .threePointAttemptsFirstHalf}'),


                                                ],
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  Text('FG%: ${widget.defense
                                                      .fieldGoalPercentageFirstHalf}'),
                                                  Text('3FG%: ${widget.defense
                                                      .threePointPercentageFirstHalf}'),
                                                  Text('TO%: ${widget.defense
                                                      .turnoverPercentageFirstHalf}'),
                                                  Text('DReb %: ${widget.defense
                                                      .dBoardPercentageFirstHalf}'),

                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: buttonPadding / 2,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceEvenly,
                                            children: <Widget>[
                                              Text('Fouls: ${widget.defense
                                                  .foulsFirstHalf}'),
                                              Text('FTs: ${widget.defense
                                                  .freeThrowMakesFirstHalf}/${widget
                                                  .defense
                                                  .freeThrowAttemptsFirstHalf}'),
                                              Text('FT %: ${widget.defense
                                                  .freeThrowPercentageFirstHalf}')
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  //SECOND HALF
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text('Second Half',
                                        textAlign: TextAlign.center,
                                      ),
                                      Text('Points per possession: ${widget.defense
                                          .pointsPerPossessionSecondHalf} (${widget.defense.hudlPointsPerPossessionSecondHalf})',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceEvenly,
                                        children: <Widget>[
                                          Text('Possessions: ${widget.defense
                                              .possessionsSecondHalf}'),
                                          Text('Points: ${widget.defense
                                              .pointsSecondHalf}'),
                                        ],
                                      ),
                                      SizedBox(
                                        height: buttonPadding / 2,
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceAround,
                                            children: <Widget>[
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment
                                                    .start,
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .center,
                                                children: <Widget>[
                                                  Text('Turnovers: ${widget.defense
                                                      .turnoversSecondHalf}'),
                                                  Text('O-Boards: ${widget.defense
                                                      .oBoardsSecondHalf}'),
                                                  Text('2-Pointers: ${widget.defense
                                                      .twoPointMakesSecondHalf}/${widget
                                                      .defense
                                                      .twoPointAttemptsSecondHalf}'),
                                                  Text('3-Pointers: ${widget.defense
                                                      .threePointMakesSecondHalf}/${widget
                                                      .defense
                                                      .threePointAttemptsSecondHalf}'),


                                                ],
                                              ),
                                              Column(
                                                children: <Widget>[
                                                  Text('FG%: ${widget.defense
                                                      .fieldGoalPercentageSecondHalf}'),
                                                  Text('3FG%: ${widget.defense
                                                      .threePointPercentageSecondHalf}'),
                                                  Text('TO%: ${widget.defense
                                                      .turnoverPercentageSecondHalf}'),
                                                  Text('DReb %: ${widget.defense
                                                      .dBoardPercentageSecondHalf}'),

                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: buttonPadding / 2,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceEvenly,
                                            children: <Widget>[
                                              Text('Fouls: ${widget.defense
                                                  .foulsSecondHalf}'),
                                              Text('FTs: ${widget.defense
                                                  .freeThrowMakesSecondHalf}/${widget
                                                  .defense
                                                  .freeThrowAttemptsSecondHalf}'),
                                              Text('FT %: ${widget.defense
                                                  .freeThrowPercentageSecondHalf}')
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            DotsIndicator(
                              dotsCount: 3,
                              position: _pageNumber,
                              decorator: DotsDecorator(
                                  color: Colors.white,
                                  activeColor: Colors.blue[900]
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Positioned(
                      top: 6,
                      left: 6,
                      child: Material(
                        type: MaterialType.circle,
                        color: Colors.transparent,
                        clipBehavior: Clip.hardEdge,
                        child: IconButton(
                          //disabledColor: Colors.grey,
                          splashColor: Colors.white54,
                          color: Colors.white,
                          icon: Icon(
                            Icons.undo,
                            // color: Colors.white,
                          ),
                          onPressed: (widget.defense.possessionHistory.length > 0)  ? removeLastPossession : null,
                        ),
                      )
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}


class UndoIconButton extends StatefulWidget {

  final List<Defense> defensesUsed;

  const UndoIconButton({Key key, this.defensesUsed}) : super(key: key);

  @override
  _UndoIconButtonState createState() => _UndoIconButtonState();
}

class _UndoIconButtonState extends State<UndoIconButton> {
  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<GlobalHistory>(context);
    final gameStatusProvider = Provider.of<GameStatus>(context);

    removeLastTouch() {
      final defenseType = provider.history.last;
      final index = widget.defensesUsed.indexOf(defenseType);
      final lastDefense = widget.defensesUsed[index];
      final lastDefenseName = lastDefense.defenseType;
      final lastDefenseResult = lastDefense.possessionHistory.last;
      final lastDefenseResultAsString = lastDefense.possessionHistoryAsString(lastDefenseResult);
      widget.defensesUsed[index].removeLastPossession(gameStatusProvider.half);

      Scaffold.of(context).removeCurrentSnackBar();
      Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Removed $lastDefenseResultAsString in $lastDefenseName.',
              textAlign: TextAlign.center,),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
            shape: RoundedRectangleBorder(),
            behavior: SnackBarBehavior.floating,
          ));
      provider.removeLast();
    }

    return Consumer<GlobalHistory>(
        builder: (context, history, _){
          return IconButton(
            icon: Icon(Icons.undo),
            onPressed: history.history.length > 0 ? removeLastTouch : null,
          );
        }
    );
  }
}




