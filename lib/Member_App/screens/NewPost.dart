import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  TextEditingController _txtAreainsq = TextEditingController();
  TextEditingController _txtRent = TextEditingController();
  TextEditingController _txtdeposit = TextEditingController();

  var paddingvalue = Padding(padding: EdgeInsets.only(top: 10.0));
  List Bhk = ["1 BHK", "2 BHK", "3 BHK", "4 BHK", "5 BHK+"];
  bool selectcolor = false;
  int selected = 0;
  var counterBalcony = 0;
  var bathroomCounter = 1;
  int dropdownValue = 1;
  bool selectimage = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _dropDownfloorItems = getDropDownMenuItems();
    _currentfloor = _dropDownfloorItems[0].value;

    _dropDownflatnoItems = getDropDownMenuflatno();
    _currentflatno = _dropDownflatnoItems[0].value;
  }

  List<DropdownMenuItem<String>> _dropDownfloorItems;
  String _currentfloor;
  List _floor = ["1", "2", "3", "4", "5"];

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String floor in _floor) {
      items.add(new DropdownMenuItem(value: floor, child: new Text(floor)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> _dropDownflatnoItems;
  String _currentflatno;
  List _falts = ["101", "102", "103", "104", "105"];

  List<DropdownMenuItem<String>> getDropDownMenuflatno() {
    List<DropdownMenuItem<String>> items = List();
    for (String flatno in _falts) {
      items.add(DropdownMenuItem(value: flatno, child: Text(flatno)));
    }
    return items;
  }

  balconyIncrementCounter() {
    if (counterBalcony >= 6) {
      return;
    }
    setState(() {
      counterBalcony++;
      print(counterBalcony);
    });
  }

  balconyDecrementConter() {
    if (counterBalcony <= 0) {
      return;
    }
    setState(() {
      counterBalcony--;
      print(counterBalcony);
    });
  }

  bathroomIncrementCounter() {
    if (bathroomCounter >= 6) {
      return;
    }
    setState(() {
      bathroomCounter++;
      print(bathroomCounter);
    });
  }

  bathroomDecrementConter() {
    if (bathroomCounter <= 1) {
      return;
    }
    setState(() {
      bathroomCounter--;
      print(bathroomCounter);
    });
  }

  var _image;

  Future<void> getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "New Post",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontFamily: "OpenSans"),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.deepPurple],
              stops: [0.1, 7.0],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(margin: EdgeInsets.all(10.0), child: UIdesign())),
    );
  }

  UIdesign() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Confirm BHK Type",
          style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.bold),
        ),
        Padding(padding: EdgeInsets.only(top: 15)),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 30.0,
          ),
          child: ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: Bhk.length,
              itemBuilder: (context, index) => BhkRowItem(Bhk[index], index)),
        ),
        Padding(padding: EdgeInsets.only(top: 15)),
        Text(
          "Built-Up Area*",
          style: TextStyle(fontFamily: "OpenSans", fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.0),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color: Colors.deepPurple[50],
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 15,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextFormField(
                    controller: _txtAreainsq,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: "Area in sq ft",
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0, right: 10.0),
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 15,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 8.0, left: 8.0, bottom: 8.0, right: 20.0),
                        child: Image.asset(
                          "assets/image/bathroom.png",
                        ),
                      ),
                      Text(
                        "Bathroom(s)",
                        style: TextStyle(fontFamily: "OpenSans"),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 90.0),
                      ),
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.all(6.0),
                          padding: EdgeInsets.only(left: 5.0, right: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.deepPurple)),
                          child:Text(
                            "+",
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontFamily: "OpenSans"),
                          ),
                        ),
                        onTap: () {
                          bathroomIncrementCounter();
                        },
                      ),
                      Text(
                        "$bathroomCounter",
                        style: TextStyle(fontFamily: "OpenSans"),
                      ),
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.all(6.0),
                          padding: EdgeInsets.only(left: 6.0, right: 6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.deepPurple)),
                          child: Text(
                            "-",
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontFamily: "OpenSans"),
                          ),
                        ),
                        onTap: () {
                          bathroomDecrementConter();
                        },
                      ),
                    ],
                  ),
                ),
                paddingvalue,
                Container(
                  height: MediaQuery.of(context).size.height / 15,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 8.0, left: 8.0, bottom: 8.0, right: 20.0),
                        child: Image.asset("assets/image/balcony.png"),
                      ),
                      Text(
                        "Balcony",
                        style: TextStyle(fontFamily: "OpenSans"),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 120),
                      ),
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.all(6.0),
                          padding: EdgeInsets.only(left: 5.0, right: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.deepPurple)),
                          child: Text(
                            "+",
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontFamily: "OpenSans"),
                          ),
                        ),
                        onTap: () {
                          balconyIncrementCounter();
                        },
                      ),
                      Text(
                        "$counterBalcony",
                        style: TextStyle(fontFamily: "OpenSans"),
                      ),
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.all(6.0),
                          padding: EdgeInsets.only(left: 6.0, right: 6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.deepPurple)),
                          child: Text(
                            "-",
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontFamily: "OpenSans"),
                          ),
                        ),
                        onTap: () {
                          balconyDecrementConter();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 12),
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Floor*",
                  style: TextStyle(
                      fontFamily: "OpenSans", fontWeight: FontWeight.bold),
                ),
                Padding(padding: EdgeInsets.only(top: 6.0)),
                Card(
                  elevation: 8,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2.3,
                    height: MediaQuery.of(context).size.height / 18,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: DropdownButton(
                        elevation: 16,
                        isDense: false,
                        value: _currentfloor,
                        focusColor: Colors.deepPurple,
                        dropdownColor: Colors.deepPurple[50],
                        underline: SizedBox(),
                        onChanged: changedDropDownfloor,
                        items: _dropDownfloorItems,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Flat No*",
                  style: TextStyle(
                      fontFamily: "OpenSans", fontWeight: FontWeight.bold),
                ),
                Padding(padding: EdgeInsets.only(top: 6.0)),
                Card(
                  elevation: 8,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2.3,
                    height: MediaQuery.of(context).size.height / 18,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: DropdownButton(
                        elevation: 16,
                        isDense: false,
                        value: _currentflatno,
                        focusColor: Colors.deepPurple,
                        dropdownColor: Colors.deepPurple[50],
                        underline: SizedBox(),
                        onChanged: changedDropDownflatno,
                        items: _dropDownflatnoItems,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 12),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Furnishing Status*",
              style: TextStyle(
                  fontFamily: "OpenSans", fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12),
            ),
            furnishingUI(),
            Padding(padding: EdgeInsets.only(top: 12.0)),
            Text(
              "Flat Pictures*",
              style: TextStyle(
                  fontFamily: "OpenSans", fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            InkWell(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.all(30.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(13.0),
                        child: Image(
                          image: AssetImage("assets/image/camera.png"),
                          width: MediaQuery.of(context).size.width / 8,
                        )),
                  ),
                ),
              ),onTap: (){
                 getImage();
            },
            ),
            Padding(padding: EdgeInsets.only(top: 12.0)),
            Text(
              "Rent & Deposit*",
              style: TextStyle(
                  fontFamily: "OpenSans", fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.only(top: 12),
            ),
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              color: Colors.deepPurple[50],
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 6.0)),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey)),
                      height: MediaQuery.of(context).size.height / 18,
                      child: TextFormField(
                        controller: _txtRent,
                        keyboardType: TextInputType.number,
                        cursorColor: Colors.deepPurple,
                        decoration: InputDecoration(
                            isDense: true,
                            icon: Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(13.0),
                                  child: Image(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              25,
                                      width: MediaQuery.of(context).size.width /
                                          11,
                                      image: AssetImage(
                                          "assets/image/home rent.png"),
                                      fit: BoxFit.fill)),
                            ),
                            hintText: "Rent",
                            border: InputBorder.none),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 6.0)),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey)),
                      height: MediaQuery.of(context).size.height / 18,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _txtdeposit,
                        cursorColor: Colors.deepPurple,
                        decoration: InputDecoration(
                            isDense: true,
                            icon: Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image(
                                      height:
                                          MediaQuery.of(context).size.width /
                                              13,
                                      width: MediaQuery.of(context).size.width /
                                          11,
                                      image: AssetImage(
                                          "assets/image/deposit.png"),
                                      fit: BoxFit.fill)),
                            ),
                            hintText: "deposit",
                            border: InputBorder.none),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Row(
              children: [
                Expanded(
                  child: RaisedButton(
                    onPressed: () async {},
                    color: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      "Confirm",
                      style: TextStyle(
                          color: Colors.white, fontFamily: "OpenSans"),
                    ),
                  ),
                )
              ],
            )
          ],
        )
      ],
    );
  }

  BhkRowItem(name, int index) {
    return selected == index
        ? Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: EdgeInsets.only(
                  top: 5.0, left: 20.0, right: 20.0, bottom: 5.0),
              child: Text(
                name.toString(),
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.deepPurple),
                borderRadius: BorderRadius.circular(5.0),
              ),
              padding: EdgeInsets.only(
                  top: 5.0, left: 20.0, right: 15.0, bottom: 5.0),
              child: GestureDetector(
                child: Text(
                  name.toString(),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
                onTap: () async {
                  setState(() {
                    selected = index;
                  });
                },
              ),
            ),
          );
  }

  void changedDropDownfloor(String selectedfloor) {
    setState(() {
      _currentfloor = selectedfloor;
    });
  }

  void changedDropDownflatno(String selectedFlatno) {
    setState(() {
      _currentflatno = selectedFlatno;
    });
  }

  furnishingUI() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5.0),
        ),
        Stack(children: [
          Positioned(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image(
                    height: 120.0,
                    width: MediaQuery.of(context).size.width / 3.5,
                    image: AssetImage("assets/image/Unfrnished.jpg"),
                    fit: BoxFit.fill)),
          ),
          Positioned(
            left: 10,
            top: 60,
            child: Text(
              "Un\nFurninshed",
              style: TextStyle(
                  fontSize: 15, color: Colors.white, fontFamily: "OpenSans"),
            ),
          ),
        ]),
        Padding(
          padding: EdgeInsets.only(left: 10),
        ),
        Stack(children: [
          Positioned(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image(
                    height: 120.0,
                    width: MediaQuery.of(context).size.width / 3.5,
                    image: AssetImage("assets/image/semifurnished.jpg"),
                    fit: BoxFit.fill)),
          ),
          Positioned(
            left: 10,
            top: 60,
            child: Text(
              "semi\nFurninshed",
              style: TextStyle(
                  fontSize: 15, color: Colors.white, fontFamily: "OpenSans"),
            ),
          ),
        ]),
        Padding(
          padding: EdgeInsets.only(left: 10),
        ),
        Stack(children: [
          Positioned(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image(
                    height: 120.0,
                    width: MediaQuery.of(context).size.width / 3.5,
                    image: AssetImage("assets/image/fullyfurnished.jpg"),
                    fit: BoxFit.fill)),
          ),
          Positioned(
            left: 10,
            top: 60,
            child: Text(
              "Fully\nFurninshed",
              style: TextStyle(
                  fontSize: 15, color: Colors.white, fontFamily: "OpenSans"),
            ),
          ),
        ]),
      ],
    );
  }
}
