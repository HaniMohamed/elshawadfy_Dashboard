import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';

class LeftSide extends StatelessWidget {
  const LeftSide({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 5,
      child: Container(
        // color: Color(0xff292929),
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/images/bg.jpg'),
          fit: BoxFit.cover,
        )),
        child: Container(
          margin: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      width: 200, child: Image.asset('assets/images/logo.png'))
                ],
              ),
              Expanded(child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 5, 0, 30),
                          child: Text(
                            '\"Bringing The Future Of Healthcare\"',
                            maxLines: 5,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.isMobile(context)
                                  ? MediaQuery.of(context).size.width * 0.035
                                  : MediaQuery.of(context).size.width * 0.02,
                            ),
                          ),
                        ),
                        // Container(
                        //   margin: EdgeInsets.only(bottom: 30),
                        //   child: Text(
                        //     'Empower smarter design. Go to market faster. Spark design-driven innovation.',
                        //     style: TextStyle(color: Colors.white, fontSize: 15),
                        //   ),
                        // ),
                        // OutlineButton(
                        //   padding: EdgeInsets.fromLTRB(40, 15, 40, 15),
                        //   onPressed: () {},
                        //   child: Text(
                        //     'Learn More',
                        //     style: TextStyle(color: Colors.white, fontSize: 20),
                        //   ),
                        //   borderSide: BorderSide(
                        //     color: Colors.white,
                        //   ),
                        // )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
