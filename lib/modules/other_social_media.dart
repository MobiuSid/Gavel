import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Other extends StatelessWidget{
    
  final facebook_launch_url = 'https://www.facebook.com/toastmastersnitt/';
  final instagram_launch_url = 'https://www.instagram.com/toastmasters_nitt/';

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: new AssetImage('assets/background_img.jpg'),
            fit: BoxFit.cover),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Toastmasters NIT-T Chapter',
            textAlign: TextAlign.center,
            style: GoogleFonts.ptSans(
              fontWeight: FontWeight.w400,
              fontSize: 28,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Text('Check us out on:',
          style: GoogleFonts.cabin(
            fontSize: 22,
            color: Colors.white
          ),),
          SizedBox(height: 50),
          iconButton(
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
        image: DecorationImage(
            image: new AssetImage('assets/Asset 1mdpi.png'),
            fit: BoxFit.cover)
            )
            ), 
              'Facebook', 
              GoogleFonts.signika(
                fontSize: 18
              ),facebook_launch_url),
          SizedBox(height: 16),
          iconButton(
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
        image: DecorationImage(
            image: new AssetImage('assets/Asset 1-8.png'),
            fit: BoxFit.cover)
            )
            ), 'Instagram', 
            GoogleFonts.lobsterTwo(
              fontSize: 20
            ), instagram_launch_url)
          

        ],
      )
    );
  }

  Widget iconButton(Widget widget, String text, TextStyle textStyle, String url){
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
      borderRadius: BorderRadius.circular(16),
      color: Colors.white.withOpacity(0.0),
      child: InkWell(
      splashColor: Colors.amber.shade800,
      onTap: () => {
        _launchApp(url)
      },
      child: Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[ 
         widget,
         SizedBox(width: 8),
         Text(text, 
         style: textStyle,
         )
        ],
      )
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.all(
          Radius.circular(16)
        ),
        boxShadow: [
          BoxShadow(
          color: Colors.black38,
          blurRadius: 2,
          spreadRadius: 2
        )
        ]
      ),
    )
    )
    )
    );
  }

Future<Null> _launchApp(String url) async {
    if(await canLaunch(url)){
      await launch(url,
      forceWebView: false,
      headers: <String,String>{'header_key':'header_value'},);}
      else{
        throw 'launch_error';
      }
    }
}

