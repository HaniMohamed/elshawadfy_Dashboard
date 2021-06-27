import 'package:admin/responsive.dart';
import 'package:admin/shared/constants.dart';
import 'package:admin/ui/screens/main/main_screen.dart';
import 'package:admin/services/login_service.dart';
import 'package:flutter/material.dart';

class RightSide extends StatefulWidget {
  const RightSide({
    Key? key,
  }) : super(key: key);

  @override
  State<RightSide> createState() => _RightSideState();
}

class _RightSideState extends State<RightSide> {
  bool isLoading = false;
  String? errorText;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  login() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        errorText = "please insert your account credentials!!";
      });
    } else {
      setState(() {
        isLoading = true;
      });

      String result = await LoginService()
          .login(usernameController.text, passwordController.text);
      setState(() {
        isLoading = false;
      });
      if (result == "success") {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
      } else {
        setState(() {
          errorText = result;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: Responsive.isMobile(context) ? 4 : 3,
      child: Container(
        padding: EdgeInsets.all(30),
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Text(
                    //   'ElShawadfy Radiology System',
                    //   style: TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 25,
                    //       color: Colors.pink,
                    //       letterSpacing: 2),
                    // ),
                    // Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                    Text(
                      'Sign in',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                          color: Colors.black),
                    ),
                  ],
                ),
                // Container(
                //     margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                //     child: Text(
                //       'Enter your details below',
                //       style: TextStyle(color: Colors.grey),
                //     )),

                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: TextField(
                    controller: usernameController,
                    onSubmitted: (value) {
                      login();
                    },
                    style: TextStyle(color: primaryColor),
                    decoration: InputDecoration(
                      labelText: 'Username',
                      icon: Image.asset('assets/images/user.png'),
                      labelStyle: TextStyle(color: secondaryColor),

                      // prefix: Image.asset('images/user.png'),
                      // prefixIcon: Icon(Icons.person),
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.grey)),
                      enabledBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.grey)),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    onSubmitted: (value) {
                      login();
                    },
                    style: TextStyle(color: primaryColor),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: secondaryColor),
                      icon: Image.asset('assets/images/closed-lock.png'),
                      // prefix: Image.asset('images/closed-lock.png'),
                      // prefixIcon: Icon(Icons.person),
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.grey)),
                      enabledBorder: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.grey)),
                    ),
                  ),
                ),
                errorText == null
                    ? Container()
                    : Container(
                        margin: EdgeInsets.only(top: 5),
                        alignment: Alignment.center,
                        child: Text(
                          '$errorText',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.02),
                        ),
                      ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () => login(),
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: primaryColor,
                          )),
                ),
                // ),
                // Container(
                //     margin: EdgeInsets.only(top: 30),
                //     padding: EdgeInsets.only(top: 20),
                //     width: 300,
                //     decoration: BoxDecoration(
                //         border: Border(
                //             top: BorderSide(
                //       color: Colors.grey,
                //     ))),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: <Widget>[
                //         Image.asset('assets/images/facebook.png'),
                //         SizedBox(
                //           width: 20,
                //         ),
                //         Image.asset('assets/images/youtube.png'),
                //         SizedBox(
                //           width: 20,
                //         ),
                //         Image.asset('assets/images/twitter.png'),
                //         SizedBox(
                //           width: 20,
                //         ),
                //         Image.asset('assets/images/github.png'),
                //       ],
                //     )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
