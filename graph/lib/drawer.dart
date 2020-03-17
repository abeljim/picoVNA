import 'package:flutter/material.dart';
import 'package:graph/about.dart';
import 'package:graph/settings.dart';
import 'package:graph/app_theme.dart';
import 'package:graph/vna_service.dart';


appDrawer(BuildContext context, VnaService vna) {
    return Drawer(
        child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: <Widget>[
                DrawerHeader(
                    child: Text(''),
                    decoration: BoxDecoration(
                        color: AppTheme.grey,
                    ),
                ),
                ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                    onTap: (){
                        Navigator.push(
							context,
							MaterialPageRoute(builder: (context) => SettingsPage(vna))
						);
                    },
                ),
                ListTile(
                    leading: Icon(Icons.info),
                    title: Text('About'),
                    onTap: (){
                        Navigator.push(
							context,
							MaterialPageRoute(builder: (context) => AboutPage())
						);
                    },
                )
            ],
        ),
    ); 
}
