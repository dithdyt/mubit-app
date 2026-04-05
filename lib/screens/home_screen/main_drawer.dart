import 'package:flutter/material.dart';
import 'package:mubit/screens/home_screen/home_screen.dart';
import 'package:mubit/screens/home_screen/notification_screen.dart';
import 'package:mubit/utils/Constant.dart';
import './details_screen.dart';

const String avatar = 'images/muslimavatar.jpeg';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              'Faiz Al-Qurni',
              style: TextStyle(fontSize: 17),
            ),
            accountEmail: Text(
              'Malang, Indonesia',
              style: TextStyle(fontSize: 15),
            ),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset(
                  'images/muslimavatar.jpeg',
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            decoration: BoxDecoration(color: Colors.green),
          ),
          Padding(padding: EdgeInsets.all(5)),
          ListTile(
            leading: Icon(Icons.wb_sunny),
            title: Text(
              'Ibadah',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen()));
            },
          ),
          Padding(padding: EdgeInsets.all(3)),
          ListTile(
            leading: Icon(Icons.graphic_eq),
            title: Text(
              'Grafik Istiqomah',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              // Navigator.of(context).pushNamed((DetailsScreen));
            },
          ),
          Padding(padding: EdgeInsets.all(3)),
          ListTile(
            leading: Icon(Icons.book),
            title: Text(
              'Info Ibadah',
              style: TextStyle(fontSize: 16),
            ),
            onTap: null,
          ),
          Padding(padding: EdgeInsets.all(3)),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text(
              'Notifikasi',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => NotificationScreen()));
            },
            // trailing: ClipOval(
            //   child: Container(
            //     color: Colors.red,
            //     width: 20,
            //     height: 20,
            //     child: Center(
            //       child: Text(
            //         '8',
            //         style: TextStyle(color: Colors.white, fontSize: 12),
            //       ),
            //     ),
            //   ),
            // ),
          ),
          Padding(padding: EdgeInsets.all(3)),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Settings',
              style: TextStyle(fontSize: 16),
            ),
            onTap: () {
              // Navigator.of(context).pushNamed(DetailScreen.routeName);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SettingScreen()));
            },
          ),
          Padding(padding: EdgeInsets.all(75)),
          Center(
            child: Text(
              'Sinkronisasi Terakhir : 1 Januari 2018',
              style: TextStyle(fontSize: 15, color: ColorsHelpers.grayColor),
            ),
          ),
          Padding(padding: EdgeInsets.all(5)),
          Divider(
            thickness: 1,
          ),
          Padding(padding: EdgeInsets.all(4)),
          Center(
            child: Text(
              'Keluar',
              style: TextStyle(fontSize: 15, color: ColorsHelpers.mainColor),
            ),
          ),
        ],
      ),
    );
  }
}
