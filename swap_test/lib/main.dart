import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> images =[
    'assets/images/taxiapp1.png',
    'assets/images/taxiapp2.png',
    'assets/images/taxiapp3.png'
  ];

  PageController _pageController;
  int currentIndex = 1 ;
  @override
  void initState() {
    super.initState();
    _pageController =PageController(
      initialPage: 1,
      viewportFraction: 0.5,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.teal,
      body: Container(
      margin: EdgeInsets.only(top: 100, bottom: 100),
        child: Column(
          children: <Widget>[
            Flexible(
              child: PageView.builder(
                controller: _pageController,
                  //cut my right swap from scroll first image and cut my left swap from scroll last image
                  physics:ClampingScrollPhysics(),
                  onPageChanged: (int position){
                      setState(() {
                        currentIndex = position;
                      });
                      print(position);
                  },
                  itemCount: this.images.length,
                  itemBuilder: (BuildContext context, int position){
                    return _itemBuild(context, position);
                  }
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: (){
                    _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                  },
                ),
              ],
            )
          ],
        ),
      ),

    );
  }

  Widget _itemBuild(BuildContext context, int position) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child){
        //print(_pageController.page);
        double transitionFactor = 1;
        double opacity = 1;
        if (_pageController.position.haveDimensions){
          transitionFactor = _pageController.page - position ;
          if(currentIndex == position){
            opacity =1 ;
          }else{
            opacity = 0;
          }
          transitionFactor = (1- (transitionFactor.abs()*0.6)).clamp(0.0, 1.0);
        }
        return Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 350 * transitionFactor,
                child: child,
              ),
              Opacity(
                opacity: opacity,
                child: Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 16),
                      child: Text('Welcome Slid App', style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,

                      ),)
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: Image.asset(
        images[position],
        fit: BoxFit.cover,
      ),
    );
  }


}
