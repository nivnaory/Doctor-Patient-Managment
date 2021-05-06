import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:homephiys/Controller/DoctorController.dart';
import 'package:homephiys/Entitys/Doctor.dart';

class DoctorHomeScreen extends StatefulWidget {
  _DoctorHomeScreen createState() => _DoctorHomeScreen();
  Doctor currentDoctor;
  bool isAvailable = false;

  final DoctorController dcontroller = DoctorController();
  DoctorHomeScreen({@required this.currentDoctor});
}

class _DoctorHomeScreen extends State<DoctorHomeScreen> {
  void initState() {
    this.widget.isAvailable = this.widget.currentDoctor.isAvilable;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 100.0,
          ),
          Text(
            'Your Waiting List',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'OpenSans',
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 50.0,
          ),
          buildIsAvailableButton(),
          SizedBox(
            height: 10.0,
          ),
          _buildListOfWaitingPaitent(),
        ],
      ),
    );
  }

  Widget _buildListOfWaitingPaitent() {
    return Expanded(
      child: Center(
        child: ListView.builder(
          itemCount: this.widget.currentDoctor.waitingPaitentList.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) => Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Card(
              elevation: 70.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 55.0,
                          height: 55.0,
                          child: CircleAvatar(
                            foregroundColor: Colors.green,
                            backgroundImage: NetworkImage(
                                "https://lh3.googleusercontent.com/proxy/MLN6Ito1zc6imYm07IurX8H8fngFETE4NS9LTngHzsp5ghi95BUPUhfQyNYQCbDgz4N8HyQIGd-MK_ZAdkB1FfCOTCi1c9Jtr7E5L9jhnEbOc4VI595m"),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                this
                                    .widget
                                    .currentDoctor
                                    .waitingPaitentList[index]
                                    .paitent
                                    .name,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                this
                                    .widget
                                    .currentDoctor
                                    .waitingPaitentList[index]
                                    .arrivalTime
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      child: FlatButton(
                        onPressed: () {},
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          "choose",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildIsAvailableButton() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: 200,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {
          setState(() {
            if (this.widget.isAvailable == false) {
              this.widget.isAvailable = true;
              this
                  .widget
                  .dcontroller
                  .updateDoctor(this.widget.currentDoctor.email, true);
            } else {
              this.widget.isAvailable = false;
              this
                  .widget
                  .dcontroller
                  .updateDoctor(this.widget.currentDoctor.email, false);
            }
          });
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: this.widget.isAvailable ? Colors.green : Colors.red,
        child: Text(
          this.widget.isAvailable ? "Available" : "Unavailable",
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
}

/*
  setState(() {
            if (this.widget.isAvailable == false)
              this.widget.isAvailable = true;
            else
              this.widget.isAvailable = false;
          });
          */