

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:possessions_app/Possession.dart';
import 'package:provider/provider.dart';

class QuarterScoreWidget extends StatefulWidget {

  final Quarter quarter;

  const QuarterScoreWidget({Key key, this.quarter}) : super(key: key);

  @override
  _QuarterScoreWidgetState createState() => _QuarterScoreWidgetState();
}

class _QuarterScoreWidgetState extends State<QuarterScoreWidget> {

  bool enteredScore = false;

  undoEnterScore() {
    setState(() {
      enteredScore = false;
    });
  }

  String quarterToString(Quarter quarter) {
    switch (quarter) {
      case Quarter.First:
        return '1Q';
      case Quarter.Second:
        return '2Q';
      case Quarter.Third:
        return '3Q';
      case Quarter.Fourth:
        return '4Q';
      default:
        return 'Overtime';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Container(),
        ),
        Visibility(
          visible: enteredScore,
          maintainSize: false,
          child: Text('${quarterToString(widget.quarter)}',
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),),
        ),
        enteredScore ? EnterScoreWidget(undoEnterScoreWidget: undoEnterScore, quarter: widget.quarter,) : FlatButton(
          child: Text('Enter ${quarterToString(widget.quarter)} Score'),
          onPressed: () {
            setState(() {
              enteredScore = true;
            });
          },
        ),
        Flexible(
          flex: 1,
          child: Container(),
        ),
      ],
    );
  }
}

class EnterScoreWidget extends StatefulWidget {

  final Function undoEnterScoreWidget;
  final Quarter quarter;

  const EnterScoreWidget({Key key, this.undoEnterScoreWidget, this.quarter}) : super(key: key);

  @override
  _EnterScoreWidgetState createState() => _EnterScoreWidgetState();
}

class _EnterScoreWidgetState extends State<EnterScoreWidget> {

  bool enteredScore = false;
  String homeScore = '0';
  String awayScore = '0';

  double fontSize = 10.0;

  TextEditingController _homeController = TextEditingController();
  TextEditingController _awayController = TextEditingController();

  FocusNode _homeFocusNode = FocusNode();
  FocusNode _awayFocusNode = FocusNode();


  @override
  Widget build(BuildContext context) {

    final historyProvider = Provider.of<GlobalHistory>(context);

    return Consumer<GameStatus> (
      builder: (context, gameStatus, _) {
        return SizedBox(
          width: 125,
          child: enteredScore ? GestureDetector(
              onDoubleTap: () {
                setState(() {
                  enteredScore = false;
                });
              },
              child: Container(
                height: 35,
                child: Center(
                  child: Text(
                    '$homeScore - $awayScore',
                    textAlign: TextAlign.center,),
                ),
              )
          )
              :
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 60,
                child: TextField(
                  controller: _homeController,
                  focusNode: _homeFocusNode,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      fontSize: fontSize
                  ),
                  decoration: InputDecoration(
                      labelText: 'Our Score'
                  ),
                  textInputAction: TextInputAction.next,
                  onEditingComplete: () {
                    _awayFocusNode.requestFocus();
                  },
                ),
              ),
              Container(
                width: 60,
                child: TextField(
                  controller: _awayController,
                  focusNode: _awayFocusNode,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                      fontSize: fontSize
                  ),
                  decoration: InputDecoration(
                      labelText: 'Their Score'
                  ),
                  onEditingComplete: () {
                    if (_homeController.text == '' ||
                        _awayController.text == '') {
                      widget.undoEnterScoreWidget();
                      _awayFocusNode.unfocus();
                      return;
                    }
                    setState(() {
                      homeScore = _homeController.text;
                      awayScore = _awayController.text;
                      enteredScore = true;
                      gameStatus.updateQuarter(widget.quarter);
                    });
                  },
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}


class QuarterEndWidget extends StatelessWidget {

  final String homeScore;
  final String awayScore;

  const QuarterEndWidget({Key key, this.homeScore, this.awayScore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('$homeScore - $awayScore');
  }
}


enum Half {
  First,
  Second
}

enum Quarter {
  First,
  Second,
  Third,
  Fourth
}
