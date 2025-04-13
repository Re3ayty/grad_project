
import 'dart:io' ;
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/responsive_text.dart';
import '../../viewModel/provider/app_auth_provider.dart';

class UserProfileEditScreen extends StatefulWidget {
  const UserProfileEditScreen({super.key});

  @override
  State<UserProfileEditScreen> createState() => _UserProfileEditScreenState();
}


class _UserProfileEditScreenState extends State<UserProfileEditScreen> {
  var value=-1;
  final formKey=GlobalKey<FormState>();
  final picker=ImagePicker();
  final medicalConditionController = TextEditingController();

  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AppAuthProvider>(context);
    updateUserInfo(){
      final isValid=formKey.currentState!.validate();
      if (!isValid) return;
    }
    if(authProvider.databaseUser!.gender! == 'Female')
    {
    value= 1;
    } else if(authProvider.databaseUser!.gender! == 'Male')
    {
      value= 2;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("${authProvider.databaseUser!.userName!.characters.first.toUpperCase()}${authProvider.databaseUser!.userName!.substring(1)}'s profile",style: GoogleFonts.getFont('Poppins',fontWeight: FontWeight.w500,
          // fontSize: 18,
        ),
          textScaler: TextScaler.linear(ScaleSize.textScaleFactor(context)),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage:selectedImage != null ?Image.file(selectedImage!.absolute,fit: BoxFit.cover,).image:Image.asset("assets/Images/app_logo_icon.png").image ,
                    ),

                    InkWell(
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            color: Color(0xff4979FB),
                            borderRadius: BorderRadius.circular(200),
                            border: Border.all(color: Colors.white)
                        ),
                        child: Icon(Icons.edit,color: Colors.white,size: 20,),
                      ),
                      onTap: () {
                        // pickImageFromGallery();
                        DialogUtils.showMessageDialog(context,message: 'Choose an option to pick an image from',posActionTitle: 'Camera',posAction: () {
                          pickImageFromCamera();
                          Navigator.pop(context);
                        },negActionTitle: 'Gallery',negAction: () {
                          pickImageFromGallery();
                          Navigator.pop(context);
                        }
                        );

                        //todo
                        print('edit');
                      },
                    )
                  ],
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name *',
                      style: GoogleFonts.getFont(
                        'Poppins', fontWeight: FontWeight.w500,
                      ),
                      textScaler: TextScaler.linear(
                          ScaleSize.textScaleFactor(context)),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value)
                      {
                        if(value!.isEmpty)
                        {
                          return 'Enter a user name';
                        }
                        else
                        {
                          return null;
                        }
                      },
                      // controller: userName,
                      initialValue: authProvider.databaseUser!.userName!,
                      cursorColor: Color(0xff4979FB),
                      decoration: InputDecoration(
                        prefixIcon: Icon(CupertinoIcons.person,color:Color(0xff4979FB) ,),
                        hintText: 'Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xff6A6A6A63),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xff6A6A6A63),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xff4979FB),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text('Email *',style: GoogleFonts.getFont(
                      'Poppins', fontWeight: FontWeight.w500,
                    ),
                      textScaler: TextScaler.linear(
                          ScaleSize.textScaleFactor(context)),
                    ),
                    TextFormField(
                      cursorColor: Color(0xff4979FB),
                      validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? 'Enter a valid Email'
                          : null,
                      // controller: emailController,
                      initialValue: authProvider.databaseUser!.email!,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined,color:Color(0xff4979FB) ,),
                        hintText: 'name@gmail.com',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xff6A6A6A63),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xff6A6A6A63),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xff4979FB),
                          ),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,

                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text('Phone Number *',style: GoogleFonts.getFont(
                      'Poppins', fontWeight: FontWeight.w500,
                    ),
                      textScaler: TextScaler.linear(
                          ScaleSize.textScaleFactor(context)),
                    ),
                    IntlPhoneField(
                      initialValue: authProvider.databaseUser!.phone!,
                      cursorColor: Color(0xff4979FB),
                      decoration: InputDecoration(
                        hintText: 'Phone number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xff6A6A6A63),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xff6A6A6A63),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xff4979FB),
                          ),
                        ),
                      ),),

                    Text('Date Of Birth*',style: GoogleFonts.getFont(
                      'Poppins', fontWeight: FontWeight.w500,
                    ),
                      textScaler: TextScaler.linear(
                          ScaleSize.textScaleFactor(context)),
                    ),
                    // DatePickerDialog(firstDate: DateTime(1800), lastDate: DateTime.now(),onDatePickerModeChange: (value) {
                    //   print(value);
                    // },),
                    TextFormField(
                      cursorColor: Color(0xff4979FB),
                      // onTap: () {
                      //   _selectDate(context);
                      // },
                      initialValue:authProvider.databaseUser!.dateOfBirth! ,
                      // controller: emailController,
                      // initialValue: '${finalSelectedDate.day}/${finalSelectedDate.month}/${finalSelectedDate.year}',
                      decoration: InputDecoration(
                        // suffix: TextButton(onPressed: () {
                        //   //todo
                        //   print('update Date Of Birth.');
                        // },child: Text('Change',style: TextStyle(color: Colors.blue,),)),
                        prefixIcon: Icon(Icons.calendar_month,color:  Color(0xff4979FB),),
                        hintStyle: TextStyle(color: Colors.grey,fontSize: 15),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xff6A6A6A63),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xff6A6A6A63),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xff4979FB),
                          ),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,

                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text('Gender *',style: GoogleFonts.getFont(
                      'Poppins', fontWeight: FontWeight.w500,
                    ),
                      textScaler: TextScaler.linear(
                          ScaleSize.textScaleFactor(context)),
                    ),
                    // TextFormField(
                    //   // controller: userName,
                    //   decoration: InputDecoration(
                    //     suffix: TextButton(onPressed: () {
                    //       //todo
                    //       print('updat gender');
                    //     },child: Text('Change',style: TextStyle(color: Colors.blue,),)),
                    //     prefixIcon:
                    //         Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: ImageIcon(
                    //             AssetImage('images/FontAwesome_Person_Half_Dress_icon.png'),
                    //             size: 4,
                    //
                    //             color: Colors.blue,
                    //           ),
                    //         ),
                    //     // Icon(Icons.dress,color: Colors_palette.hyperLink,),
                    //     hintText: 'HagerYasser123',
                    //     hintStyle: TextStyle(color: Colors.grey,fontSize: 15),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(12),
                    //       borderSide: BorderSide(
                    //         color: Colors.grey.shade100,
                    //       ),
                    //     ),
                    //
                    //   ),
                    // ),

                    DropdownButtonFormField(
                      items:[
                        DropdownMenuItem(child: Text('-Select a gender-',style: GoogleFonts.getFont(
                      'Poppins', fontWeight: FontWeight.w400,
                    ),
                      textScaler: TextScaler.linear(
                          ScaleSize.textScaleFactor(context)),
                    ),value: -1,),
                        DropdownMenuItem(child: Text('Female',style: GoogleFonts.getFont(
                          'Poppins', fontWeight: FontWeight.w400,
                        ),
                          textScaler: TextScaler.linear(
                              ScaleSize.textScaleFactor(context)),
                        ),value: 1,),
                        DropdownMenuItem(child: Text('Male',style: GoogleFonts.getFont(
                          'Poppins', fontWeight: FontWeight.w400,
                        ),
                          textScaler: TextScaler.linear(
                              ScaleSize.textScaleFactor(context)),
                        ),value: 2,),
                      ], onChanged: (value) {

                    },
                      value: value,
                      borderRadius: BorderRadius.circular(12),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xff6A6A6A63),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xff6A6A6A63),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xff4979FB),
                          ),),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ImageIcon(
                            AssetImage('assets/Images/FontAwesome_Person_Half_Dress_icon.png',),

                            color: Color(0xff4979FB),
                          ),
                        ),
                      ),

                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Medical condition ",
                      style: GoogleFonts.getFont(
                        'Poppins', fontWeight: FontWeight.w500,
                      ),
                      textScaler: TextScaler.linear(
                          ScaleSize.textScaleFactor(context)),
                    ),
                    TextFormField(
                      initialValue:authProvider.databaseUser!.medicalCondition! ,
                      cursorColor: Color(0xff4979FB),
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: 'That\'s gonna help us provide better care.',

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xff6A6A6A63),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xff6A6A6A63),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Color(0xff4979FB),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              Container(
                width: 300,
                height: 50,
                margin: EdgeInsets.only(top: 30),
                child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Color(0xff4979FB),),shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
                  onPressed: () {
                    updateUserInfo();
                    //todo update data to firebase
                  },
                  child: Text('Update Data',style: TextStyle(color: Colors.white,fontSize: 18),),
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
  Future pickImageFromGallery()async
  {
    final returnedImage= await ImagePicker().pickImage(
        source: ImageSource.gallery
    );
    setState(() {

      selectedImage=File(returnedImage!.path);
      // widget.imgURL = null;
    });
  }

  Future pickImageFromCamera()async
  {
    final returnedImage= await ImagePicker().pickImage(
        source: ImageSource.camera
    );
    setState(() {

      selectedImage=File(returnedImage!.path);
      // widget.imgURL = null;
    });
  }


  var finalSelectedDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  TextEditingController date = new TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? userSelectedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1800),
        lastDate: DateTime.now()
    );
    if (userSelectedDate != null&& userSelectedDate != selectedDate)
      setState(() {
        selectedDate = userSelectedDate;
        date.value = TextEditingValue(text: '${userSelectedDate.day}-${userSelectedDate.month}-${userSelectedDate.year}');

      });
  }


}



