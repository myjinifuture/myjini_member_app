import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BankDetails extends StatefulWidget {
  var bankData;

  BankDetails({this.bankData});

  @override
  _BankDetailsState createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Bank Details', style: TextStyle(fontSize: 18)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(10),
          ),
        ),
      ),
      body: widget.bankData.length == 0
          ? Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset("images/file.png",
                        width: 70, height: 70, color: Colors.grey[300]),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text("No Bank Details Found",
                          style: TextStyle(color: Colors.grey[400])),
                    )
                  ],
                ),
              ),
            )
          : Column(
              children: [
                ListTile(
                  title: Text(
                    widget.bankData["Society"][0]["BankName"] == ""
                        ? "Bank Of Baroda"
                        : "${widget.bankData["Society"][0]["BankName"]}",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  leading: Icon(Icons.account_balance),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.bankData["Society"][0]["UPIID"] == null
                            ? "UPI Id : 9995552221@upi"
                            : "UPI Id : ${widget.bankData["Society"][0]["UPIID"]}",
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        "Account Number : ${widget.bankData["Society"][0]["AccountNo"]}",
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        "IFSC Number : ${widget.bankData["Society"][0]["IFSCCode"]}",
                        style: TextStyle(fontSize: 15),
                      ),
                      Text(
                        widget.bankData["Society"][0]["UPIID"] == null
                            ? "Address : Surat, Gujarat"
                            : "Adress : ${widget.bankData["Society"][0]["BankAddress"]}",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey[300],
                )
              ],
            ),
    );
  }
}
