import 'package:flutter/material.dart';
import 'package:mubit/utils/Constant.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreen createState() => _NotificationScreen();
}

class _NotificationScreen extends State<NotificationScreen> {
  var _toggle1 = false;
  var _toggle2 = false;
  var _toggle3 = false;
  var _toggle4 = false;
  var _toggle5 = false;
  var _toggle6 = false;
  var _toggle7 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Notifikasi'),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ListTile(
                      title: Text(
                        'WAKTU NOTIFIKASI',
                        style: TextStyle(color: Colors.grey),
                      ),
                      tileColor: Color(0xFFF5F5F5),
                    ),
                    ListTile(
                      title: Text('Pengingat Sholat'),
                      subtitle: Text('15 Menit Sebelum'),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: ColorsHelpers.mainColor,
                      ),
                      onTap: () {},
                    ),
                    ListTile(
                      title: Text(
                        'SHALAT WAJIB',
                        style: TextStyle(color: Colors.grey),
                      ),
                      tileColor: Color(0xFFF5F5F5),
                    ),
                    SwitchListTile(
                      title: Text('Subuh'),
                      value: _toggle1,
                      onChanged: (value) {
                        setState(() {
                          _toggle1 = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: Text('Duhur'),
                      value: _toggle2,
                      onChanged: (value) {
                        setState(() {
                          _toggle2 = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: Text("Ashar"),
                      value: _toggle3,
                      onChanged: (value) {
                        setState(() {
                          _toggle3 = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: Text('Maghrib'),
                      value: _toggle4,
                      onChanged: (value) {
                        setState(() {
                          _toggle4 = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: Text('Isya'),
                      value: _toggle5,
                      onChanged: (value) {
                        setState(() {
                          _toggle5 = value;
                        });
                      },
                    ),
                    ListTile(
                      title: Text(
                        'SHALAT SUNNAH',
                        style: TextStyle(color: Colors.grey),
                      ),
                      tileColor: Color(0xFFF5F5F5),
                    ),
                    SwitchListTile(
                      title: Text('Dhuha'),
                      value: _toggle6,
                      onChanged: (value) {
                        setState(() {
                          _toggle6 = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: Text('Tahajud'),
                      value: _toggle7,
                      onChanged: (value) {
                        setState(() {
                          _toggle7 = value;
                        });
                      },
                    )
                  ],
                ),
              ],
            ))
          ],
        ));
  }
}
