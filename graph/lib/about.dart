import 'package:flutter/material.dart';
import 'package:graph/app_theme.dart';

class AboutPage extends StatelessWidget {
	@override 
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
                backgroundColor: AppTheme.transparent,
                elevation: 0,
                centerTitle: true,
				iconTheme: IconThemeData(color: AppTheme.nearlyBlack),
				leading: Builder(
    				builder: (BuildContext context) {
      					return IconButton(
        					icon: const Icon(Icons.arrow_back),
        					onPressed: () { 
								Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
							},
      					);
    				},
  				),
                title: Container(
                    child: Text(
                        "About",
                        style: TextStyle(
                            color: AppTheme.darkText,
                        ),
                    ),
                ),
			),
			body: Center( child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
  				crossAxisAlignment: CrossAxisAlignment.center,
				children: <Widget>[
					Text("NanoVNA Wireless"),
					Text("Version V 0.2"),
					Text("OpenSource"),
				],
			),),
		);
	}
}