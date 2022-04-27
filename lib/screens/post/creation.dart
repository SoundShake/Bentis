import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';
import 'package:untitled/models/currency_input_formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/cities.dart';

class CreatePost extends StatefulWidget {
  final List<String>? cities;
  const CreatePost(this.cities, {Key? key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();


}
class _CreatePostState extends State<CreatePost> {
  String departure='';
  String arrival='';
  int seats=0;
  DateTime? date;
  TimeOfDay? time;
  List<String>? cities;
  double price=0;

  bool wrongDeparture=false;
  bool wrongArrival=false;
  bool wrongSeatCount=false;
  bool wrongDate=false;
  bool wrongTime=false;
  bool wrongPrice=false;

  @override
  void initState() {
    build(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Create post'),
        ),
        body: Form(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  children: const [
                    Text('Departure city:'),
                  ],
                ),
                DropdownSearch<String>(
                  mode: Mode.BOTTOM_SHEET,
                  showSelectedItems: true,
                  showSearchBox: true,
                  items: widget.cities,
                  selectedItem: departure,
                  onChanged: (String? item){
                    if(item!=null){
                      departure=item;
                    }
                    print(departure);
                    },
                ),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text('Arrival city:'),
                  ],
                ),
                DropdownSearch<String>(
                  mode: Mode.BOTTOM_SHEET,
                  showSelectedItems: true,
                  showSearchBox: true,
                  items: widget.cities,
                  selectedItem: arrival,
                  onChanged: (String? item){
                    if(item!=null){
                      arrival=item;
                    }
                    print(arrival);
                    },
                ),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text('Seat count:'),
                  ],
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  decoration: InputDecoration(
                    counter: Container(),
                  ),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (String value){
                    seats=int.parse(value);
                    validateSeats();
                  },
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  child: Text(
                    getDateText(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    minimumSize: MaterialStateProperty.all(Size.fromHeight(40)),
                  ),
                  onPressed: () => pickDate(context)
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  child: Text(
                    getTimeText(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    minimumSize: MaterialStateProperty.all(Size.fromHeight(40)),
                  ),
                  onPressed: () => pickTime(context),
                ),
                const SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text('Price:'),
                  ],
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(suffixText: "€"),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                    CurrencyInputFormatter(maxDigits: 5),
                  ],
                  onChanged: (String value){
                    validatePrice(value);
                  },
                ),
                Text(
                  (showError())
                      ? getErrorMessage()
                      : '',
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
                const Expanded(child: SizedBox(height: 15),),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          child: const Text('Cancel',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () => Navigator.pop(context),
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all(Colors.black),
                            minimumSize: MaterialStateProperty.all(Size.fromHeight(40)),
                          ),
                        ),
                      ),
                      const Center(
                        child: VerticalDivider(
                          thickness: 2,
                          color: Colors.black12,
                        ),
                      ),
                      Expanded(
                          child: TextButton(
                            child: const Text('Create',
                              style: TextStyle(fontSize: 20),
                            ),
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all(Colors.black),
                              minimumSize: MaterialStateProperty.all(Size.fromHeight(40)),
                            ),
                            onPressed: (){
                              if(verify()){
                                Navigator.pop(context);
                                submit(context);
                              }
                            }
                          )
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
    );
  }

  Future pickDate(BuildContext context) async{
    final newDate=await showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year+1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.black,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.black,
              ),
            )
          ),
          child: child!,
        );
      }
    );
    if(newDate==null) return;
    setState(() => date=newDate);
  }

  Future pickTime(BuildContext context) async{
    final newTime=await showTimePicker(
      context: context,
      initialTime: time ?? TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Colors.black,
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                  ),
                )
            ),
            child: child!,
          );
        }
    );
    if(newTime==null) return;
    setState(() => time=newTime);
  }

  String getDateText(){
    if (date!=null){
      DateTime temp=date as DateTime;
      final month=temp.month.toString().padLeft(2, '0');
      final day=temp.day.toString().padLeft(2, '0');
      return month+'-'+day;
    }
    else {
      return 'Select Date';
    }
  }

  String getTimeText(){
    if (time!=null){
      TimeOfDay temp=time as TimeOfDay;
      final hour=temp.hour.toString().padLeft(2, '0');
      final minute=temp.minute.toString().padLeft(2, '0');
      return hour+':'+minute;
    }
    else {
      return 'Select Time';
    }
  }

  String getErrorMessage(){
    String message='Incorrect data in fields:';
    if(wrongDeparture){
      message+=" Departure;";
    }
    if(wrongArrival){
      message+=" Arrival;";
    }
    if(wrongSeatCount){
      message+=" Seat count;";
    }
    if(wrongDate){
      message+=" Date;";
    }
    if(wrongTime){
      message+=" Time;";
    }
    if(wrongPrice){
      message+=" Price;";
    }
    return message;
  }

  bool validateDeparture(){
    if(departure!='' || departure!=arrival){
      setState(() {
        wrongDeparture=false;
      });
      return true;
    }
    else{
      setState(() {
        wrongDeparture=true;
      });
      return false;
    }
  }
  bool validateArrival(){
    if(arrival!='' || departure!=arrival){
      setState(() {
        wrongArrival=false;
      });
      return true;
    }
    else{
      setState(() {
        wrongArrival=true;
      });
      return false;
    }
  }
  bool validateSeats(){
    if(seats>0){
      setState(() {
        wrongSeatCount=false;
      });
      return true;
    }
    else{
      setState(() {
        wrongSeatCount=true;
      });
      return false;
    }
  }
  bool validateDate(){
    if(date!=null){
      setState(() {
        wrongDate=false;
      });
      return true;
    }
    else{
      setState(() {
        wrongDate=true;
      });
      return false;
    }
  }
  bool validateTime(){
    bool valid=true;
    if(time!=null){
      TimeOfDay now=time as TimeOfDay;
      if(date!=null){
        DateTime selected=date as DateTime;
        if(DateTime.now().month==selected.month && DateTime.now().day==selected.day){
          if(DateTime.now().hour==now.hour && DateTime.now().minute<now.minute || DateTime.now().hour<now.hour){
            setState(() {
              valid=true;
            });
          }
          else{
            setState(() {
              valid=false;
            });
          }
        }
        else{
          setState(() {
            valid=true;
          });
        }
      }
      else{
        setState(() {
          valid=true;
        });
      }
    }
    else{
      setState(() {
        valid=false;
      });
    }
    setState(() {
      wrongTime=!valid;
    });
    return valid;
  }
  bool validatePrice(String value){
    double? parsedValue=double.tryParse(value);
    if(parsedValue==null){
      setState(() {
        wrongPrice=true;
      });
      return false;
    }
    else{
      setState(() {
        price=parsedValue;
        wrongPrice=false;
      });
      return true;
    }
  }
  bool showError(){
    if(wrongDeparture || wrongArrival || wrongSeatCount || wrongDate || wrongTime || wrongPrice){
      return true;
    }
    else{
      return false;
    }
  }
  bool verify(){
    if(validateDeparture() && validateArrival() && validateSeats() && validateDate() && validateTime() && validatePrice(price.toString())){
      return true;
    }
    else{
      return false;
    }
  }
  bool submit(BuildContext context){
    CollectionReference posts=FirebaseFirestore.instance.collection('posts');
    var user=FirebaseAuth.instance.currentUser;
    bool greatSuccess=false;
    if(user!=null){
      final ref=FirebaseFirestore.instance.collection("users").doc(user.uid);
      DateTime postDate=date as DateTime;
      TimeOfDay postTime=time as TimeOfDay;
      int hour=postTime.hour;
      int minute=postTime.minute;
      setState(() {
        postDate=postDate.add(Duration(hours: hour, minutes: minute));
      });
      posts.add({
        'user': ref,
        'departure': departure,
        'destination': arrival,
        'seats': seats,
        'date': postDate,
        'price': price,
      })
          .then((value) => {
        print("post added"),
        setState(() {
          greatSuccess=true;
        }),
      })
          .catchError((error) => {
        print("Failed to add post: $error"),
        setState(() {
          greatSuccess=false;
        }),
      });
    }
    return greatSuccess;
  }
}