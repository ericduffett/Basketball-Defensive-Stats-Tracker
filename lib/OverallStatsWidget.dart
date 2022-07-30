import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'Possession.dart';

class OverallStats extends StatefulWidget {

  final GlobalHistory history;

  const OverallStats({Key key, this.history}) : super(key: key);

  @override
  _OverallStatsState createState() => _OverallStatsState();
}

class _OverallStatsState extends State<OverallStats> {

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
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
              mainAxisSize: MainAxisSize.min,
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
                          Text('Points per possession: ${widget.history.pointsPerPossession} (${widget.history.hudlPointsPerPossession})',
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('Possessions: ${widget.history.possessions}'),
                              Text('Points: ${widget.history.points}'),
                            ],
                          ),
                          SizedBox(
                            height: buttonPadding / 2,
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
                                      Text(
                                          'Turnovers: ${widget.history.turnovers}'),
                                      Text('O-Boards: ${widget.history.oBoards}'),
                                      Text('2-Pointers: ${widget.history
                                          .twoPointMakes}/${widget.history
                                          .twoPointAttempts}'),
                                      Text('3-Pointers: ${widget.history
                                          .threePointMakes}/${widget.history
                                          .threePointAttempts}'),


                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text('FG%: ${widget.history
                                          .fieldGoalPercentage}'),
                                      Text('3FG%: ${widget.history
                                          .threePointPercentage}'),
                                      Text('TO%: ${widget.history
                                          .turnoverPercentage}'),
                                      Text('DReb %: ${widget.history
                                          .dBoardPercentage}'),

                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: buttonPadding / 2,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text('Fouls: ${widget.history.fouls}'),
                                  Text('FTs: ${widget.history
                                      .freeThrowMakes}/${widget.history
                                      .freeThrowAttempts}'),
                                  Text(
                                      'FT %: ${widget.history.freeThrowPercentage}')
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
/*
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
                              .pointsPerPossessionFirstHalf}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('Possessions: ${widget.defense
                                  .possessionsFirstHalf}'),
                              Text('Points: ${widget.defense.pointsFirstHalf}'),
                            ],
                          ),
                          SizedBox(
                            height: buttonPadding / 2,
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
                                      Text('Turnovers: ${widget.defense
                                          .turnoversFirstHalf}'),
                                      Text('O-Boards: ${widget.defense
                                          .oBoardsFirstHalf}'),
                                      Text('2-Pointers: ${widget.defense
                                          .twoPointMakesFirstHalf}/${widget.defense
                                          .twoPointAttemptsFirstHalf}'),
                                      Text('3-Pointers: ${widget.defense
                                          .threePointMakesFirstHalf}/${widget
                                          .defense.threePointAttemptsFirstHalf}'),


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
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text('Fouls: ${widget.defense.foulsFirstHalf}'),
                                  Text('FTs: ${widget.defense
                                      .freeThrowMakesFirstHalf}/${widget.defense
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
                              .pointsPerPossessionSecondHalf}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text('Possessions: ${widget.defense
                                  .possessionsSecondHalf}'),
                              Text('Points: ${widget.defense.pointsSecondHalf}'),
                            ],
                          ),
                          SizedBox(
                            height: buttonPadding / 2,
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
                                      Text('Turnovers: ${widget.defense
                                          .turnoversSecondHalf}'),
                                      Text('O-Boards: ${widget.defense
                                          .oBoardsSecondHalf}'),
                                      Text('2-Pointers: ${widget.defense
                                          .twoPointMakesSecondHalf}/${widget.defense
                                          .twoPointAttemptsSecondHalf}'),
                                      Text('3-Pointers: ${widget.defense
                                          .threePointMakesSecondHalf}/${widget
                                          .defense.threePointAttemptsSecondHalf}'),


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
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text('Fouls: ${widget.defense.foulsSecondHalf}'),
                                  Text('FTs: ${widget.defense
                                      .freeThrowMakesSecondHalf}/${widget.defense
                                      .freeThrowAttemptsSecondHalf}'),
                                  Text('FT %: ${widget.defense
                                      .freeThrowPercentageSecondHalf}')
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

 */
                    ],
                  ),
                ),


                SizedBox(
                  height: 4.0,
                ),
                /*
                DotsIndicator(
                  dotsCount: 3,
                  position: _pageNumber,
                  decorator: DotsDecorator(
                      activeColor: Colors.deepOrange
                  ),
                ),


                 */
              ],
          ),
        );
  }
}
