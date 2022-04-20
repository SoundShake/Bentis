import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter{
  CurrencyInputFormatter({this.maxDigits});
  final int? maxDigits;

  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue){
    if(newValue.selection.baseOffset==0){
      return newValue;
    }
    if(maxDigits!=null && newValue.selection.baseOffset>(maxDigits as int)){
      return oldValue;
    }
    double value=double.parse(newValue.text);
    final formatter=new NumberFormat("##.##", 'lt');
    String newText=formatter.format(value);
    return newValue.copyWith(
      text: newText,
      selection: new TextSelection.collapsed(offset: newText.length),
    );
  }
}