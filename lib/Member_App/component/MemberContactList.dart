import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/Member_App/common/constant.dart' as cnst;
import 'package:smart_society_new/Member_App/screens/AddFamilyMember.dart';
import 'package:smart_society_new/Member_App/screens/ContactList.dart';

class MemberContactList extends StatefulWidget {

  bool addMem;
  Function onAddFromContactMemList;
  MemberContactList({this.addMem,this.onAddFromContactMemList});

  @override
  _MemberContactListState createState() => _MemberContactListState();
}

class _MemberContactListState extends State<MemberContactList> {

  List<Contact> _contacts = new List<Contact>();
  List<CustomContactList> _searchContact = new List<CustomContactList>();
  List<CustomContactList> _uiCustomContacts = List<CustomContactList>();
  bool _isLoading = false, isSearching = false;
  List _selectedContact = [];

  TextEditingController txtSearch = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshContacts();
  }

  refreshContacts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //memberId = prefs.getString(Session.Member_Id);
    //wingId = prefs.getString(Session.WingId);
   // soceityId = prefs.getString(Session.SocietyId);
    setState(() {
      _isLoading = true;
    });
    var contacts = await ContactsService.getContacts(
      withThumbnails: false,
      photoHighResolution: false,
    );
    _populateContacts(contacts);
  }

  void _populateContacts(Iterable<Contact> contacts) {
    _contacts = contacts.where((item) => item.displayName != null).toList();
    _contacts.sort((a, b) => a.displayName.compareTo(b.displayName));
    setState(() {
      _uiCustomContacts =
          _contacts.map((contact) => CustomContactList(contact: contact)).toList();
      _searchContact =
          _contacts.map((contact) => CustomContactList(contact: contact)).toList();
      _isLoading = false;
    });
  }

  void searchOperation(String searchText) {
    if (searchText != "") {
      setState(() {
        _searchContact.clear();
        isSearching = true;
      });
      String mobile = "";
      for (int i = 0; i < _uiCustomContacts.length; i++) {
        String name = _uiCustomContacts[i].contact.displayName;
        var _phonesList = _uiCustomContacts[i].contact.phones.toList();
        if (_phonesList.length > 0) mobile = _phonesList[0].value;
        if (name.toLowerCase().contains(searchText.toLowerCase()) ||
            mobile.toLowerCase().contains(searchText.toLowerCase())) {
          setState(() {
            _searchContact.add(_uiCustomContacts[i]);
          });
        }
      }
    } else {
      setState(() {
        isSearching = false;
      });
    }
  }

  ListTile _buildListTile(CustomContactList c, List<Item> list) {
    return ListTile(
      leading: (c.contact.avatar != null && c.contact.avatar.length > 0)
          ? CircleAvatar(backgroundImage: MemoryImage(c.contact.avatar))
          : CircleAvatar(
        child: Text(
          c.contact.displayName.toUpperCase().substring(0, 1) ?? "",
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
        ),
      ),
      title: Text(c.contact.displayName ?? ""),
      subtitle: list.length >= 1 && list[0]?.value != null
          ? Text(list[0].value)
          : Text(''),
      trailing: Checkbox(
          activeColor: Colors.green,
          value: c.isChecked,
          onChanged: (bool value) {
            _onChange(value, c, list);
          }),
    );
  }
  _onChange(value, CustomContactList c, List<Item> list) {
    if (list.length >= 1 &&
        list[0]?.value != null &&
        c.contact.displayName != "") {
      print("list");
      print(list);
      String mobile = list[0].value.toString();
      String name = c.contact.displayName.toString();
      mobile = mobile.replaceAll(" ", "");
      mobile = mobile.replaceAll("-", "");
      mobile = mobile.replaceAll("+91", "");
      mobile = mobile.replaceAll("091", "");
      mobile = mobile.replaceAll("+091", "");
      mobile = mobile.replaceAll(RegExp("^0"), "");
      print(widget.addMem);
      if(widget.addMem == false){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddFamilyMember(name:name,mobileNo:mobile.toString()),
          ),
        );
        // Navigator.pop(context);
        // Navigator.pop(context);
      }
      print("mobile" + mobile);
      if (value) {
        if (mobile.length == 10) {
          setState(() {
            c.isChecked = value;
          });
          /*_selectedContact.add({
            "Id": 0,
            "MemberId": memberId,
            "SocietyId": soceityId,
            "StaffId": memberId,
            "Name": name,
            "ContactNo": mobile,
            "Image": null,
            "Date": DateTime.now().toString(),
            "IsVerified": false,
            "AddedBy": memberId,
            "Purpose": "",
            "WingId": "$wingId",
          });*/
        }
        // Fluttertoast.showToast(
        //     msg: "Mobile Number Is Not Valid",
        //     backgroundColor: Colors.red,
        //     textColor: Colors.white,
        //     gravity: ToastGravity.TOP,
        //     toastLength: Toast.LENGTH_SHORT);
      } else {
        setState(() {
          c.isChecked = value;
        });
        for (int i = 0; i < _selectedContact.length; i++) {
          if (_selectedContact[i]["ContactNo"].toString() == mobile)
            _selectedContact.removeAt(i);
        }
      }
      print(_selectedContact);
    } else {
      Fluttertoast.showToast(
          msg: "Contact Is Not Valid",
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          gravity: ToastGravity.TOP,
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Choose Members"),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
          actions: <Widget>[
            _selectedContact.length > 0
                ? GestureDetector(
              onTap: () {
              },
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                      width: 90,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius:
                          BorderRadius.all(Radius.circular(5))),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 3, right: 3, top: 2, bottom: 2),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              "Add",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Icon(
                              Icons.send,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ))),
            )
                : Container(),
          ],
        ),
        body: _isLoading
            ? Container(
          child: Center(child: CircularProgressIndicator()),
        )
            : Column(
          children: <Widget>[
            Padding(
              padding:
              const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0),
              child: TextFormField(
                onChanged: searchOperation,
                controller: txtSearch,
                scrollPadding: EdgeInsets.all(0),
                decoration: InputDecoration(
                    counter: Text(""),
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.black),
                        borderRadius:
                        BorderRadius.all(Radius.circular(8))),
                    suffixIcon: Icon(
                      Icons.search,
                      color: cnst.appPrimaryMaterialColor,
                    ),
                    hintText: "Search Contact"),
                maxLength: 10,
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.black),
              ),
            ),
            Expanded(
              child: _uiCustomContacts.length > 0
                  ? isSearching
                  ? ListView.builder(
                itemCount: _searchContact?.length,
                itemBuilder: (BuildContext context, int index) {
                  CustomContactList _contact =
                  _searchContact[index];
                  var _phonesList =
                  _contact.contact.phones.toList();
                  return _buildListTile(_contact, _phonesList);
                },
              )
                  : ListView.builder(
                itemCount: _uiCustomContacts?.length,
                itemBuilder: (BuildContext context, int index) {
                  CustomContactList _contact =
                  _uiCustomContacts[index];
                  var _phonesList =
                  _contact.contact.phones.toList();
                  return _buildListTile(_contact, _phonesList);
                },
              )
                  : Container(
                child: Center(child: Text("No Data Found")),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
class CustomContactList {
  final Contact contact;
  bool isChecked;

  CustomContactList({
    this.contact,
    this.isChecked = false,
  });
}
