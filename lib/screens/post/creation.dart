import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:untitled/models/currency_input_formatter.dart';
import 'package:untitled/screens/home/home.dart';

import '../../models/cities.dart';

class CreatePost extends StatefulWidget {
  final List<String>? cities;
  const CreatePost(this.cities, {Key? key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();


}
class _CreatePostState extends State<CreatePost> {
  final _formKey=GlobalKey<FormState>();
  String departure='';
  String arrival='';
  int seats=0;
  DateTime? date;
  TimeOfDay? time;
  List<String>? cities;
  double price=0;
  final _controler=TextEditingController();

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
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (String value){
                    seats=int.parse(value);
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
                  onPressed: () => pickDate(context),
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
                    CurrencyInputFormatter(maxDigits: 5),
                    FilteringTextInputFormatter.allow(RegExp('[0-9,]')),
                  ],
                  onChanged: (String value){
                    price=double.parse(value);
                  },
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
                            onPressed: null,
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
}