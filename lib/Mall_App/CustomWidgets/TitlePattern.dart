import 'package:flutter/material.dart';

class TitlePattern extends StatefulWidget {
  String title;
  TitlePattern({this.title});
  @override
  _TitlePatternState createState() => _TitlePatternState();
}

class _TitlePatternState extends State<TitlePattern> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              border:
              Border.all(width: 0.5, color: Colors.grey),
              borderRadius:
              BorderRadius.all(Radius.circular(4.0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left:8),
                child: Image.asset('assets/Pattern.png',
                    width: 25, color: Colors.brown),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${widget.title}",
                  style: TextStyle(
                      fontSize: 15, color: Colors.black87),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right:8.0),
                child: Image.asset('assets/Pattern.png',
                    width: 25, color: Colors.brown),
              ),
            ],
          )),
    );
  }
}
