import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:sathiclub/authentication/bloc/authentication_bloc.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart'as picker;
import '../../constants/themeColors.dart';
import '../models/UserModel.dart';

class DateOfBirthPage extends StatefulWidget {
  final String mUid;
  final UserModel mUser;
  final bool fromSignup;
  const DateOfBirthPage({Key? key, required this.mUid,required this.mUser,required this.fromSignup}) : super(key: key);

  @override
  _DateOfBirthPageState createState() => _DateOfBirthPageState();
}

class _DateOfBirthPageState extends State<DateOfBirthPage> {
  final TextEditingController _controllerDOB_AD = TextEditingController();
  final TextEditingController _controllerDOB_BS = TextEditingController();

  DateTime _birthDate = DateTime(4000,1,1);
  NepaliDateTime _birthDateNepali = NepaliDateTime(2100,1,1);
  String _birthDateString = '';
  int d = 0, m = 0, y = 0;
  int days1 = 0, month1 = 0, year1 = 0;

  @override void initState() {
    super.initState();
    if(!widget.mUser.birthDate.isAtSameMomentAs(DateTime(4000, 1, 1))){
      _birthDate = widget.mUser.birthDate;
      _birthDateNepali = widget.mUser.birthDate.toNepaliDateTime();
      _controllerDOB_AD.text ="Date of Birth (AD): "+widget.mUser.birthDate.toString().substring(0,10);
      _controllerDOB_BS.text="Date of Birth (BS): "+_birthDateNepali.toString().substring(0,10);
    }
  }

  @override
  Widget build(BuildContext context) {
    return datePage();
  }

  Widget datePage(){
    return SingleChildScrollView(
      child: Column(
        children:  [
          const SizedBox(height: 40,),
          Align(
              alignment: Alignment.centerLeft,
              child: backButtonDate()),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 54,
              width: 104,
              decoration:const BoxDecoration(
                image:DecorationImage(image: AssetImage('assets/images/sathi_icon_white.png'),
                  fit:BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40,),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Enter your Birth date ',
              style:TextStyle (
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.white),),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Your age will be public',
              style:TextStyle (
                  fontSize: 18,
                  color: themeColorSubtitle),),
          ),
          const SizedBox(
            height: 60,
          ),
          dateOfBirthFieldAD(),
          const SizedBox(height: 20,),
          dateOfBirthFieldBS(),
          const SizedBox(
            height: 50,
          ),
          continueButtonDate(),
        ],
      ),
    );

  }
  Widget dateOfBirthFieldAD(){return Padding(
    padding: const EdgeInsets.fromLTRB(16.0,8.0,16.0,8.0),
    child: Container(
      decoration:BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: themeColorSubtitle, width: 1,),
      ),
      child:GestureDetector(
        onTap: (){
          pickDateOfBirth(context);
        },
        child: TextFormField(
          //initialValue: mUser.dateOfBirth.toString(),
          controller: _controllerDOB_AD,
          enabled: false,
          decoration: const InputDecoration(
            contentPadding:EdgeInsets.symmetric(vertical:18) ,
            border:InputBorder.none,
            hintText:'Date of Birth AD',
            hintStyle: TextStyle(fontSize:22,color: Colors.black54,),
            prefixIcon:Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(FontAwesomeIcons.calendar,color:Colors.black54,size:30),
            ),
            suffixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.keyboard_arrow_down,color:Colors.black54,size:30),
            ),
          ),
          //style:GoogleFonts.getFont('McLaren',fontSize: 20,),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onSaved:(value)=>setState(()=>_birthDateString=value!),

        ),
      ),
    ),
  );}
  Widget dateOfBirthFieldBS(){return Padding(
    padding: const EdgeInsets.fromLTRB(16.0,8.0,16.0,8.0),
    child: Container(
      decoration:BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey, width: 1,),
      ),
      child:GestureDetector(
        onTap: (){
          pickDateOfBirthNepali(context);
        },

        child: TextFormField(
          //initialValue: mUser.dateOfBirth.toString(),
          controller: _controllerDOB_BS,
          enabled: false,
          decoration: const InputDecoration(
            contentPadding:EdgeInsets.symmetric(vertical:18) ,
            border:InputBorder.none,
            hintText:'Date of Birth BS',
            hintStyle: TextStyle(fontSize:22,color: Colors.black54,),
            prefixIcon:Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(FontAwesomeIcons.calendar,color:Colors.black54,size:30),
            ),
            suffixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.keyboard_arrow_down,color:Colors.black54,size:30),
            ),
          ),
          //style:GoogleFonts.getFont('McLaren',fontSize: 20,),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onSaved:(value)=>setState(()=>_birthDateString=value!),

        ),
      ),
    ),
  );}
  Widget backButtonDate(){
    return IconButton(
      icon:const Icon(Icons.arrow_back,color:themeColorSubtitle),
      onPressed: (){
        context.read<AuthenticationBloc>().add(BackFromDateStateEvent(uid:widget.mUid,user:widget.mUser));
      },
    );

  }
  Widget continueButtonDate(){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        alignment: Alignment.center,
        child: ElevatedButton(
            style:ElevatedButton.styleFrom(
              primary: themeButtonColor,
              onPrimary: Colors.white,
              minimumSize: const Size(double.infinity,50),
            ),
            child:const Text('Next',style: TextStyle(fontSize: 18),),
            onPressed:(){
              if (!_birthDate.isAtSameMomentAs(DateTime(4000, 1, 1)) ){
                final age = f1(mBirthDate: _birthDate);
                if(age>17){
                  context.read<AuthenticationBloc>().add(UpdateInfoDateEvent(uid:widget.mUid,date: _birthDate,age: age));
                }
                else{
                  showDialog(
                      context: context,
                      builder: (context)=>AlertDialog(
                        content: const Text("You must be 18 years old to sign up"),
                        actions: [
                          TextButton(
                            child: const Text('Ok'),
                            onPressed: () {
                              Navigator.pop(context);}, ),
                        ],
                      ));
                }

              }else{
                const msg = 'Please pick up date of birth first' ;
                const snackBar = SnackBar(content:Text(msg));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);

              }
            }
        ),
      ),
    );

  }
  Future pickDateOfBirth (BuildContext context) async{
    final initialDate = DateTime.now();
    final dateOfBirth = await showDatePicker(
        context: context,
        initialDate:  initialDate,
        firstDate: DateTime(DateTime.now().year-100,),
        lastDate: DateTime(DateTime.now().year+5,),
        builder: (context,child){
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: themeButtonColor,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: themeButtonColor, // button text color
                ),
              ),
            ),
            child: child!,
          );

        }
    );
    if (dateOfBirth==null){return;}
    else{
      setState(() {
        _birthDate = dateOfBirth;
        _birthDateNepali = _birthDate.toNepaliDateTime();
        _controllerDOB_AD.text="Date of Birth (AD): "+ _birthDate.toString().substring(0,10);
        _controllerDOB_BS.text="Date of Birth (BS): "+_birthDateNepali.toString().substring(0,10);
      });
    }
  }
  Future pickDateOfBirthNepali(BuildContext context) async{
    picker.NepaliDateTime? _selectedDateTime = await picker.showMaterialDatePicker(
        context: context,
        initialDate: NepaliDateTime.now(),
        firstDate: NepaliDateTime(NepaliDateTime.now().year-100),
        lastDate: NepaliDateTime(NepaliDateTime.now().year+5),
        initialDatePickerMode: DatePickerMode.day,
        builder: (context,child){
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: themeButtonColor,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  primary: themeButtonColor, // button text color
                ),
              ),
            ),
            child: child!,
          );

        }
    );
    if(_selectedDateTime==null){return;}
    else{
      _birthDateNepali =_selectedDateTime;
      _birthDate = _birthDateNepali.toDateTime();
      _controllerDOB_BS.text="Date of Birth (BS): "+_selectedDateTime.toString().substring(0,10);
      _controllerDOB_AD.text="Date of Birth (AD): "+ _birthDate.toString().substring(0,10);
    }
  }
  String getBirthDate(){return'${_birthDate.day}/${_birthDate.month}/${_birthDate.year}';}
  int f1({required DateTime mBirthDate}) {
    DateTime date1 = mBirthDate;
    if (!_birthDate.isAtSameMomentAs(DateTime(4000, 1, 1))) {
      setState(() {
        d = int.parse(DateFormat("dd").format(date1));
        m = int.parse(DateFormat("MM").format(date1));
        y = int.parse(DateFormat("yyyy").format(date1));

        int d1 = int.parse(DateFormat("dd").format(DateTime.now()));
        int m1 = int.parse(DateFormat("MM").format(DateTime.now()));
        int y1 = int.parse(DateFormat("yyyy").format(DateTime.now()));

        int day = findDays(m1, y1);

        if (d1 - d >= 0) {
          days1 = (d1 - d);
        } else {
          days1 = (d1 + day - d);
          m1 = m1 - 1;
        }

        if (m1 - m >= 0) {
          month1 = (m1 - m);
        } else {
          month1 = (m1 + 12 - m);
          y1 = y1 - 1;
        }
        year1 = (y1 - y);
      });
    } else {
      setState(() {
        days1 = 0;
        month1 = 0;
        year1 = 0;
      });
    }
    return year1;
  }
  int findDays(int m2, int y2) {
    int day2;
    if (m2 == 1 ||
        m2 == 3 ||
        m2 == 5 ||
        m2 == 7 ||
        m2 == 8 ||
        m2 == 10 ||
        m2 == 12) {
      day2 = 31;
    } else if (m2 == 4 || m2 == 6 || m2 == 9 || m2 == 11) {
      day2 = 30;
    } else {
      if (y2 % 4 == 0) {
        day2 = 29;
      } else {
        day2 = 28;
      }
    }

    return day2;
  }
}
