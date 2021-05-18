import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  static const routeName = '/onboarding_screen';
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 3;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.deepOrange : Colors.purple,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new LoginScreen()));
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                          color: _currentPage == 0
                              ? Colors.deepOrange
                              : _currentPage == 1
                                  ? Colors.purple
                                  : Colors.blue[900],
                          fontFamily: "Arial Rounded",
                          fontSize: 20.0),
                    ),
                  ),
                ),
                Container(
                  height: 500.0,
                  child: PageView(
                    physics: ClampingScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage('assets/images/1.jpeg'),
                                height: 300.0,
                                width: 300.0,
                              ),
                            ),
                            SizedBox(height: 25.0),
                            Text('Connect people\naround the world',
                                style: TextStyle(
                                    fontFamily: "Arial Rounded",
                                    fontSize: 20,
                                    color: Colors.deepOrange)),
                            SizedBox(height: 15.0),
                            Text(
                                'Start chating with people from all over the world.',
                                style: TextStyle(
                                    fontFamily: "Arial Rounded",
                                    fontSize: 15,
                                    color: Colors.deepOrange)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage('assets/images/2.jpeg'),
                                height: 300.0,
                                width: 300.0,
                              ),
                            ),
                            SizedBox(height: 25.0),
                            Text('Stream Together\naround the world',
                                style: TextStyle(
                                    fontFamily: "Arial Rounded",
                                    fontSize: 20,
                                    color: Colors.purple)),
                            SizedBox(height: 15.0),
                            Text('watch videos with friends across the world!',
                                style: TextStyle(
                                    fontFamily: "Arial Rounded",
                                    fontSize: 15,
                                    color: Colors.purple)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Image(
                                image: AssetImage('assets/images/3.jpeg'),
                                height: 300.0,
                                width: 300.0,
                              ),
                            ),
                            SizedBox(height: 25.0),
                            Text('Draw and Share doodles with your friends',
                                style: TextStyle(
                                    fontFamily: "Arial Rounded",
                                    fontSize: 20,
                                    color: Colors.blue[900])),
                            SizedBox(height: 15.0),
                            Text('show your creativity with your friends',
                                style: TextStyle(
                                    fontFamily: "Arial Rounded",
                                    fontSize: 15,
                                    color: Colors.blue[900])),
                                    
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  //padding: const EdgeInsets.symmetric(vertical:20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildPageIndicator(),
                  ),
                ),
                _currentPage != _numPages - 1
                    ? Expanded(
                        child: Align(
                        alignment: FractionalOffset.bottomRight,
                        child: TextButton(
                            onPressed: () {
                              _pageController.nextPage(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    'Next',
                                    style: TextStyle(
                                      color: _currentPage == 0
                                          ? Colors.deepOrange
                                          : Colors.purple,
                                      fontSize: 22.0,
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: _currentPage == 0
                                        ? Colors.deepOrange
                                        : Colors.purple,
                                    size: 30.0,
                                  ),
                                ],
                              ),
                            )),
                      ))
                    : Text(''),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: _currentPage == _numPages - 1
          ? Container(
              margin: EdgeInsets.all(32),
              padding: EdgeInsets.all(20),
              height: 60.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue[900],
                borderRadius: BorderRadius.circular(50),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                              new LoginScreen()));
                },
                child: Container(
                  margin: EdgeInsets.all(0),
                  child: Center(
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontFamily: "Arial Rounded",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Text(''),
    );
  }
}
