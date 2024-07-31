import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_clone/features/home/bloc/login/login/bloc.dart';
import 'package:insta_clone/features/home/bloc/login/login/state.dart';
import 'package:insta_clone/features/home/screens/home_screen.dart';
import '../../../../generated/l10n.dart';
import '../../bloc/login/login/event.dart';
import '../registre/registre.dart';
import 'package:intl/intl.dart';


class loginwidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<loginwidget> {

  String dropdownValue = 'English';
  String local="en";
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool inputTextNotNull = false;
  late LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
    print(Intl.getCurrentLocale());
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {

          if (state is userLoginSuccessState) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (state is userLoginErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 90,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.topCenter,
                        child: DropdownButton<String>(
                          dropdownColor: Colors.white70,
                          value: dropdownValue,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 10,
                          style: TextStyle(color: Colors.black54),
                          underline: Container(),
                          items: <String>['English', 'Arabic', 'French']
                              .map<DropdownMenuItem<String>>((String value) {
                            String leadingIcon;
                            switch (value) {
                              case 'English':
                                leadingIcon = "/icon/en.png";
                                break;
                              case 'Arabic':
                                leadingIcon = "/icon/tunisie.png";
                                break;
                              case 'French':
                                leadingIcon ="/icon/fr.png";
                                break;
                              default:
                                leadingIcon = "/icon/en.png";
                            }
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Row(
                                children: [
                                  Image.asset(
                                    leadingIcon,
                                    width: 24,
                                    height: 24,
                                  ),
                                  SizedBox(width: 8), // Space between icon and text
                                  Text(
                                    value,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              dropdownValue = value!;
                              if(value=="English"){
                                S.load(Locale('en', 'US'));
                                Intl.defaultLocale='en';
                                local=Intl.defaultLocale!;
                              }else if(value=="French"){
                                S.load(Locale('fr', 'FR'));
                                Intl.defaultLocale='fr';
                                local=Intl.defaultLocale!;
                              }
                              else if(value=="Arabic"){
                                S.load(Locale('ar', 'AR'));
                                Intl.defaultLocale='ar';
                                print(Intl.getCurrentLocale()!= 'ar');
                                local=Intl.defaultLocale!;
                                print(Intl.getCurrentLocale());
                              }
                            });
                          },
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icon/insta2.jpg',
                            height: deviceWidth * .30,
                          ),
                          SizedBox(height: deviceWidth * .05),
                          Container(
                            width: deviceWidth * .90,
                            height: deviceWidth * .14,
                            decoration: BoxDecoration(
                              color: Color(0xffE8E8E8),
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  Icon(Icons.email, color: Colors.grey),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      onChanged: (text) {
                                        setState(() {
                                          if (usernameController.text.length >= 2 &&
                                              passwordController.text.length >= 2) {
                                            inputTextNotNull = true;
                                          } else {
                                            inputTextNotNull = false;
                                          }
                                        });
                                      },
                                      controller: usernameController,
                                      style: TextStyle(
                                        fontSize: deviceWidth * .040,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: S.of(context).email,
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: deviceWidth * .04),
                          Container(
                            width: deviceWidth * .90,
                            height: deviceWidth * .14,
                            decoration: BoxDecoration(
                              color: Color(0xffE8E8E8),
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  Icon(Icons.lock, color: Colors.grey),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      onChanged: (text) {
                                        setState(() {
                                          if (usernameController.text.length >= 2 &&
                                              passwordController.text.length >= 2) {
                                            inputTextNotNull = true;
                                          } else {
                                            inputTextNotNull = false;
                                          }
                                        });
                                      },
                                      controller: passwordController,
                                      obscureText: true,
                                      style: TextStyle(
                                        fontSize: deviceWidth * .040,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: S.of(context).password,
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: deviceWidth * .04),
                          GestureDetector(
                            onTap: () {
                              print("Email: ${usernameController.text}");
                              print("Password: ${passwordController.text}");
                              context.read<LoginBloc>().add(loginbuttonpressed(
                                  email: usernameController.text,
                                  password: passwordController.text));
                            },
                            child: Container(
                              width: deviceWidth * .90,
                              height: deviceWidth * .14,
                              decoration: BoxDecoration(
                                color: Color(0xff78C9FF),
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Center(
                                child: Text(
                                  S.of(context).loginButton,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: deviceWidth * .040,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: deviceWidth * .025),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              (local!='ar')?Row(
                                children: [
                                  Text(
                                    S.of(context).forgetlogin,
                                    style: TextStyle(
                                      fontSize: deviceWidth * .035,
                                    ),

                                  ),
                                  SizedBox(width: 5,),
                                  GestureDetector(
                                    onTap: () {
                                      print('Get help');
                                    },
                                    child: Text(
                                      S.of(context).Gethelp,
                                      style: TextStyle(
                                        fontSize: deviceWidth * .035,
                                        color: Color(0xff002588),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                ],
                              ):
                              Row(
                                children: [

                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          print('Get help');
                                        },
                                        child: Text(
                                          S.of(context).Gethelp,
                                          style: TextStyle(
                                            fontSize: deviceWidth * .035,
                                            color: Color(0xff002588),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Text(
                                        S.of(context).forgetlogin,
                                        style: TextStyle(
                                          fontSize: deviceWidth * .035,
                                        ),

                                      ),
                                    ],
                                  ),

                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: deviceWidth * .040),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 1,
                                width: deviceWidth * .40,
                                color: Color(0xffA2A2A2),
                              ),
                              SizedBox(width: 10),
                              Text(
                                S.of(context).or,
                                style: TextStyle(
                                  fontSize: deviceWidth * .040,
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                height: 1,
                                width: deviceWidth * .40,
                                color: Color(0xffA2A2A2),
                              ),
                            ],
                          ),
                          SizedBox(height: deviceWidth * .06),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/fcb.png',
                                    height: deviceWidth * .15,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    S.of(context).fcblogin,
                                    style: TextStyle(
                                      color: Color(0xff1877f2),
                                      fontSize: deviceWidth * .040,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),

                                ],
                              ),

                            ],
                          ),
                        ],
                      ),
                      Container(
                        width: deviceWidth,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: deviceWidth,
                              height: 1,
                              color: Color(0xffA2A2A2),
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,

                              children: [
                                (local!='ar')? Row(
                                  children: [
                                    Text(
                                      S.of(context).haveaccount,
                                      style: TextStyle(
                                        fontSize: deviceWidth * .040,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => SignUpScreen()),
                                        );
                                      },
                                      child: Text(
                                        S.of(context).Signup,
                                        style: TextStyle(
                                          color: Color(0xff00258B),
                                          fontSize: deviceWidth * .040,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ):
                                Row(
                                  children: [

                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => SignUpScreen()),
                                        );
                                      },
                                      child: Text(
                                        S.of(context).Signup,
                                        style: TextStyle(
                                          color: Color(0xff00258B),
                                          fontSize: deviceWidth * .040,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 4,),
                                    Text(
                                      S.of(context).haveaccount,
                                      style: TextStyle(
                                        fontSize: deviceWidth * .040,
                                      ),
                                    ),
                                  ],
                                ),
                                                           ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (context.watch<LoginBloc>().state is LoginLoadingState)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
