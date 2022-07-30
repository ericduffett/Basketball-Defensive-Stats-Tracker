

import 'package:flutter/material.dart';

class TimeoutsWidget extends StatefulWidget {

  final Timeouts timeouts;

  const TimeoutsWidget({Key key, this.timeouts}) : super(key: key);


  @override
  _TimeoutsWidgetState createState() => _TimeoutsWidgetState();
}

class _TimeoutsWidgetState extends State<TimeoutsWidget> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      title: Text('Timeouts Remaining', textAlign: TextAlign.center,),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Our Timeouts',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              FlatButton(
                child: widget.timeouts.ourFullTimeouts == 3 ? Text('Full') : Text('-'),
                onPressed: () {
                  setState(() {
                    if (widget.timeouts.ourFullTimeouts == 3) {
                      widget.timeouts.takeFullTimeout();
                    } else {
                      widget.timeouts.giveFullBack();
                    }

                  });
                },
              ),
              FlatButton(
                child: widget.timeouts.ourFullTimeouts >= 2 ? Text('Full') : Text('-'),
                onPressed: () {
                  setState(() {
                    if (widget.timeouts.ourFullTimeouts >= 2) {
                      widget.timeouts.takeFullTimeout();
                    } else {
                      widget.timeouts.giveFullBack();
                    }

                  });
                },
              ),
              FlatButton(
                child: widget.timeouts.ourFullTimeouts >= 1 ? Text('Full') : Text('-'),
                onPressed: () {
                  setState(() {
                    if (widget.timeouts.ourFullTimeouts >= 1) {
                      widget.timeouts.takeFullTimeout();
                    } else {
                      widget.timeouts.giveFullBack();
                    }

                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: widget.timeouts.ourThirtySecondTimeouts >= 2 ? Text('30') : Text('-'),
                onPressed: () {
                  setState(() {
                    if (widget.timeouts.ourThirtySecondTimeouts >= 2) {
                      widget.timeouts.takeThirty();
                    } else {
                      widget.timeouts.giveThirtyBack();
                    }
                  });
                },
              ),
              FlatButton(
                child: widget.timeouts.ourThirtySecondTimeouts >= 1 ? Text('30') : Text('-'),
                onPressed: () {
                  setState(() {
                    if (widget.timeouts.ourThirtySecondTimeouts >= 1) {
                      widget.timeouts.takeThirty();
                    } else {
                      widget.timeouts.giveThirtyBack();
                    }

                  });
                },
              ),
            ],
          ),
          Divider(),
          Align(
              alignment: Alignment.centerLeft,
              child: Text('Their Timeouts',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
          ),
          Row(
            children: <Widget>[
              FlatButton(
                child: widget.timeouts.theirFullTimeouts == 3 ? Text('Full') : Text('-'),
                onPressed: () {
                  setState(() {
                    if (widget.timeouts.theirFullTimeouts == 3) {
                      widget.timeouts.theyTakeFull();
                    } else {
                      widget.timeouts.giveThemFullBack();
                    }

                  });
                },
              ),
              FlatButton(
                child: widget.timeouts.theirFullTimeouts >= 2 ? Text('Full') : Text('-'),
                onPressed: () {
                  setState(() {
                    if (widget.timeouts.theirFullTimeouts >= 2) {
                      widget.timeouts.theyTakeFull();
                    } else {
                      widget.timeouts.giveThemFullBack();
                    }

                  });
                },
              ),
              FlatButton(
                child: widget.timeouts.theirFullTimeouts >= 1 ? Text('Full') : Text('-'),
                onPressed: () {
                  setState(() {
                    if (widget.timeouts.theirFullTimeouts >= 1) {
                      widget.timeouts.theyTakeFull();
                    } else {
                      widget.timeouts.giveThemFullBack();
                    }

                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: widget.timeouts.theirThirtySecondTimeouts >= 2 ? Text('30') : Text('-'),
                onPressed: () {
                  setState(() {
                    if (widget.timeouts.theirThirtySecondTimeouts >= 2) {
                      widget.timeouts.theyTakeThirty();
                    } else {
                      widget.timeouts.giveThemThirtyBack();
                    }
                  });
                },
              ),
              FlatButton(
                child: widget.timeouts.theirThirtySecondTimeouts >= 1 ? Text('30') : Text('-'),
                onPressed: () {
                  setState(() {
                    if (widget.timeouts.theirThirtySecondTimeouts >= 1) {
                      widget.timeouts.theyTakeThirty();
                    } else {
                      widget.timeouts.giveThemThirtyBack();
                    }

                  });
                },
              ),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Close'),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}


class Timeouts with ChangeNotifier {
  int ourFullTimeouts = 3;
  int ourThirtySecondTimeouts = 2;

  int theirFullTimeouts = 3;
  int theirThirtySecondTimeouts = 2;

  takeFullTimeout() {
    ourFullTimeouts -= 1;
    notifyListeners();
  }


  theyTakeFull() {
    theirFullTimeouts -= 1;
    notifyListeners();
  }

  takeThirty() {
    ourThirtySecondTimeouts -= 1;
    notifyListeners();
  }

  theyTakeThirty() {
    theirThirtySecondTimeouts -= 1;
    notifyListeners();
  }

  giveFullBack() {
    ourFullTimeouts += 1;
    notifyListeners();
  }

  giveThemFullBack() {
    theirFullTimeouts += 1;
    notifyListeners();
  }

  giveThirtyBack() {
    ourThirtySecondTimeouts += 1;
    notifyListeners();
  }

  giveThemThirtyBack() {
    theirThirtySecondTimeouts += 1;
    notifyListeners();
  }

}