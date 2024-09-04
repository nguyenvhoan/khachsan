import 'package:booking/user/widget/intro.dart';
import 'package:booking/user/widget/signIn.dart';

import 'package:booking/user/widget/signup.dart';

import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  int _currentPage = 0;
  PageController _controller = PageController();
 List<Widget> _pages=[];
  @override
  void initState() {
    super.initState();
    _pages = [
      Intro(
        onGetStarted:()=> _onGetStarted(1), 
      ),
      Signin(
        onGetStarted:()=> _onGetStarted(2),
      ),
      SignUp(
        onGetStarted:()=>_onGetStarted(1),
      ),
    ];
  }

  void _onChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }
  void _onGetStarted(int id) {
    _controller.jumpToPage(id); 
  }

  @override
  Widget build(BuildContext context) {

    
      return Container(
          
        child : Stack(
          fit: StackFit.loose,
          children:[
              
              Container(
                
                height: MediaQuery.of(context).size.height / 2,
                
                child: Image.asset('asset/images/icons/intro.png', fit: BoxFit.cover,width: MediaQuery.sizeOf(context).width),
              ),
              
              
              Positioned(
                top: 380,
                child: Container(
                 
                  decoration: BoxDecoration(  
                    borderRadius:   BorderRadius.circular(50),
                  ),
                  
                  width:  MediaQuery.of(context).size.width,
                  
                  child: Container(
                height:MediaQuery.sizeOf(context).height/2,
                child: Expanded( 
                  child: Stack(
                    children: <Widget>[
                      PageView.builder(
                        scrollDirection: Axis.horizontal,
                        onPageChanged: _onChanged,
                        controller: _controller,
                        itemCount: _pages.length,
                        itemBuilder: (context, int index) {
                          return _pages[index];
                        },
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List<Widget>.generate(_pages.length, (int index) {
                              return AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                height: 10,
                                width: (index == _currentPage) ? 30 : 10,
                                margin: EdgeInsets.symmetric(horizontal: 5, vertical: 30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: (index == _currentPage) ? Colors.blue : Colors.blue.withOpacity(0.5),
                                ),
                              );
                            }),
                          ),
                          
                          const SizedBox(height: 50),
                        ],
                      ),
                    ],
                  ),

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            color: Colors.red,
            child: Image.asset(
                kIsWeb
                    ? 'asset/images/london-west-hollywood-los-angeles-california-102897-2.jpg'
                    : 'asset/images/icons/intro.png',
                fit: BoxFit.cover,
                width: MediaQuery.sizeOf(context).width),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                PageView.builder(
                  scrollDirection: Axis.horizontal,
                  onPageChanged: _onChanged,
                  controller: _controller,
                  itemCount: _pages.length,
                  itemBuilder: (context, int index) {
                    return _pages[index];
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          List<Widget>.generate(_pages.length, (int index) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: 10,
                          width: (index == _currentPage) ? 30 : 10,
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 30),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: (index == _currentPage)
                                ? Colors.blue
                                : Colors.blue.withOpacity(0.5),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 50),
                  ],

                ),
              ),

                ),
              )
            ],
          
          
        ),
      );
    
  }
}
