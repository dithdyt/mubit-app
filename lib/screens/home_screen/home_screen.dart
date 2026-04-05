import 'package:faker/faker.dart' hide Image, Color;
import 'package:flutter/material.dart' hide RadioGroup;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:mubit/screens/home_screen/main_drawer.dart';
import 'package:mubit/utils/Constant.dart';

String logoShalat = 'images/shalat.png';
String logoMesjid = 'images/muslimicon.jpeg';
String logoPuasa = 'images/logopuasa.jpeg';
String logoSedekah = 'images/logosedekah.png';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // TimeOfDay selectedTime = TimeOfDay.now();
  bool isTap = false;
  final Faker faker = Faker();

  Widget _buildSlidableTile({
    required String logo,
    required String title,
    required String subtitle,
    required String trailing,
    required bool isTapped,
    required VoidCallback onCheck,
    required VoidCallback onClose,
  }) {
    return Slidable(
      key: ValueKey(title),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (context) => onCheck(),
            backgroundColor: ColorsHelpers.mainColor,
            foregroundColor: Colors.white,
            icon: Icons.check_sharp,
          ),
          SlidableAction(
            onPressed: (context) => onClose(),
            backgroundColor: ColorsHelpers.redColor,
            foregroundColor: Colors.white,
            icon: Icons.close_sharp,
          ),
        ],
      ),
      child: Container(
        color: Colors.white,
        child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(logo),
              radius: 20,
            ),
            title: Text(
              title,
              style: TextStyle(
                  color: isTapped ? ColorsHelpers.mainColor : Colors.grey.shade400),
            ),
            subtitle: Text(
              subtitle,
              style: TextStyle(
                  color: isTapped ? Colors.black : Colors.grey.shade400),
            ),
            trailing: Text(
              trailing,
              style: TextStyle(
                  color: isTapped ? ColorsHelpers.mainColor : Colors.grey.shade400,
                  fontSize: 25.0),
            ),
            tileColor: isTapped
                ? (title.contains('Shubuh') ||
                        title.contains('Bidh') ||
                        title.contains('Infak')
                    ? Colors.green.shade100
                    : Colors.red.shade100)
                : Colors.grey.shade200),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        // elevation: 0,
        // backgroundColor: Colors.transparent,
        title: Text("DiaryIbadah"),
      ),
      drawer: MainDrawer(),
      backgroundColor: Color(0xFFF5F5F5),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return TambahShalat();
              });
        },
      ),
      body: Container(
        child: Column(children: [
          Stack(
            children: [
              Image.asset(
                logoMesjid,
                width: 550,
                height: 250,
                fit: BoxFit.cover,
              ),
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.arrow_back_ios_rounded,
                      color: ColorsHelpers.whiteColor,
                      size: 30,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 80, 0, 0),
                          child: Text(
                            '08',
                            style: TextStyle(
                                fontSize: 60, color: ColorsHelpers.whiteColor),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
                          child: Text(
                            'November, 2016',
                            style: TextStyle(
                                fontSize: 15, color: ColorsHelpers.whiteColor),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 75, 0, 0),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ColorsHelpers.whiteColor,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            width: 400,
            height: MediaQuery.of(context).size.height / 2,
            decoration: BoxDecoration(
              color: const Color(0xFFEEEEEE),
            ),
            child: DefaultTabController(
              length: 3,
              initialIndex: 0,
              child: Column(children: [
                TabBar(
                  tabs: [
                    Tab(
                      child: Text(
                        'SHALAT',
                        style: TextStyle(color: ColorsHelpers.mainColor),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'PUASA',
                        style: TextStyle(color: ColorsHelpers.mainColor),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'SEDEKAH',
                        style: TextStyle(color: ColorsHelpers.mainColor),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      SingleChildScrollView(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                                _buildSlidableTile(
                                  logo: logoShalat,
                                  title: 'Shalat Shubuh',
                                  subtitle: '20 Menit Lalu',
                                  trailing: '04:10',
                                  isTapped: isTap,
                                  onCheck: () => setState(() => isTap = true),
                                  onClose: () => setState(() => isTap = false),
                                ),
                                _buildSlidableTile(
                                  logo: logoShalat,
                                  title: 'Puasa Dhuha',
                                  subtitle: '3 Jam Lagi',
                                  trailing: '08:01',
                                  isTapped: isTap,
                                  onCheck: () => setState(() => isTap = true),
                                  onClose: () => setState(() => isTap = false),
                                ),
                              Container(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage(logoShalat),
                                  ),
                                  title: Text(
                                    'Shalat Dhuhur',
                                    style:
                                        TextStyle(color: Colors.grey.shade400),
                                  ),
                                  subtitle: Text(
                                    '6 Jam Lagi',
                                    style:
                                        TextStyle(color: Colors.grey.shade400),
                                  ),
                                  trailing: Text(
                                    '11:45',
                                    style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 25.0),
                                  ),
                                  // tileColor: Color(0xFFF5F5F5),
                                ),
                              ),
                              Container(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage(logoShalat),
                                  ),
                                  title: Text(
                                    'Shalat Ashar',
                                    style:
                                        TextStyle(color: Colors.grey.shade400),
                                  ),
                                  subtitle: Text(
                                    '10 Jam Lagi',
                                    style:
                                        TextStyle(color: Colors.grey.shade400),
                                  ),
                                  trailing: Text(
                                    '15:20',
                                    style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 25.0),
                                  ),
                                  // tileColor: Color(0xFFF5F5F5),
                                ),
                              ),
                              Container(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage(logoShalat),
                                  ),
                                  title: Text(
                                    'Shalat Maghrib',
                                    style:
                                        TextStyle(color: Colors.grey.shade400),
                                  ),
                                  subtitle: Text(
                                    '13 Jam Lagi',
                                    style:
                                        TextStyle(color: Colors.grey.shade400),
                                  ),
                                  trailing: Text(
                                    '18:00',
                                    style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 25.0),
                                  ),
                                  // tileColor: Color(0xFFF5F5F5),
                                ),
                              ),
                              Container(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage(logoShalat),
                                  ),
                                  title: Text(
                                    'Shalat Isya',
                                    style:
                                        TextStyle(color: Colors.grey.shade400),
                                  ),
                                  subtitle: Text(
                                    '14 Jam Lagi',
                                    style:
                                        TextStyle(color: Colors.grey.shade400),
                                  ),
                                  trailing: Text(
                                    '19:05',
                                    style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 25.0),
                                  ),
                                  // tileColor: Color(0xFFF5F5F5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                                _buildSlidableTile(
                                  logo: logoPuasa,
                                  title: 'Puasa Ayyamul Bidh',
                                  subtitle: 'Buka 6 Jam Lagi',
                                  trailing: '18:02',
                                  isTapped: isTap,
                                  onCheck: () => setState(() => isTap = true),
                                  onClose: () => setState(() => isTap = false),
                                ),
                                _buildSlidableTile(
                                  logo: logoPuasa,
                                  title: 'Puasa Syawal',
                                  subtitle: '3 Maret',
                                  trailing: '18:03',
                                  isTapped: isTap,
                                  onCheck: () => setState(() => isTap = true),
                                  onClose: () => setState(() => isTap = false),
                                ),
                                _buildSlidableTile(
                                  logo: logoPuasa,
                                  title: 'Puasa Nisfu Sya`ban',
                                  subtitle: '18 Maret',
                                  trailing: '18:04',
                                  isTapped: isTap,
                                  onCheck: () => setState(() => isTap = true),
                                  onClose: () => setState(() => isTap = false),
                                ),
                              Container(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage(logoPuasa),
                                  ),
                                  title: Text(
                                    'Puasa Tarwiyah',
                                    style:
                                        TextStyle(color: Colors.grey.shade400),
                                  ),
                                  subtitle: Text(
                                    '7 Juli',
                                    style:
                                        TextStyle(color: Colors.grey.shade400),
                                  ),
                                  trailing: Text(
                                    '18:04',
                                    style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 25.0),
                                  ),
                                  // tileColor: Color(0xFFF5F5F5),
                                ),
                              ),
                              Container(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage(logoPuasa),
                                  ),
                                  title: Text(
                                    'Puasa Ramadhan',
                                    style:
                                        TextStyle(color: Colors.grey.shade400),
                                  ),
                                  subtitle: Text(
                                    '5 April',
                                    style:
                                        TextStyle(color: Colors.grey.shade400),
                                  ),
                                  trailing: Text(
                                    '18:04',
                                    style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 25.0),
                                  ),
                                  // tileColor: Color(0xFFF5F5F5),
                                ),
                              ),
                              Container(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage(logoPuasa),
                                  ),
                                  title: Text(
                                    'Puasa Ramadhan',
                                    style:
                                        TextStyle(color: Colors.grey.shade400),
                                  ),
                                  subtitle: Text(
                                    '6 April',
                                    style:
                                        TextStyle(color: Colors.grey.shade400),
                                  ),
                                  trailing: Text(
                                    '18:04',
                                    style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 25.0),
                                  ),
                                  // tileColor: Color(0xFFF5F5F5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                                _buildSlidableTile(
                                  logo: logoSedekah,
                                  title: 'Infak',
                                  subtitle: '20 Menit Lalu',
                                  trailing: '04:49',
                                  isTapped: isTap,
                                  onCheck: () => setState(() => isTap = true),
                                  onClose: () => setState(() => isTap = false),
                                ),
                              Container(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage(logoSedekah),
                                  ),
                                  title: Text(
                                    'Puasa Nisfu Sya`ban',
                                    style:
                                        TextStyle(color: Colors.grey.shade400),
                                  ),
                                  subtitle: Text(
                                    '18 Maret',
                                    style:
                                        TextStyle(color: Colors.grey.shade400),
                                  ),
                                  trailing: Text(
                                    '18:04',
                                    style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 25.0),
                                  ),
                                  // tileColor: Color(0xFFF5F5F5),
                                ),
                              ),
                              Container(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage(logoSedekah),
                                  ),
                                  title: Text(
                                    'Puasa Tarwiyah',
                                    style:
                                        TextStyle(color: Colors.grey.shade400),
                                  ),
                                  subtitle: Text(
                                    '7 Juli',
                                    style:
                                        TextStyle(color: Colors.grey.shade400),
                                  ),
                                  trailing: Text(
                                    '18:04',
                                    style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 25.0),
                                  ),
                                  // tileColor: Color(0xFFF5F5F5),
                                ),
                              ),
                              Container(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage(logoSedekah),
                                  ),
                                  title: Text(
                                    'Puasa Ramadhan',
                                    style:
                                        TextStyle(color: Colors.grey.shade400),
                                  ),
                                  subtitle: Text(
                                    '5 April',
                                    style:
                                        TextStyle(color: Colors.grey.shade400),
                                  ),
                                  trailing: Text(
                                    '18:04',
                                    style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 25.0),
                                  ),
                                  // tileColor: Color(0xFFF5F5F5),
                                ),
                              ),
                              Container(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage(logoSedekah),
                                  ),
                                  title: Text(
                                    'Puasa Ramadhan',
                                    style:
                                        TextStyle(color: Colors.grey.shade400),
                                  ),
                                  subtitle: Text(
                                    '6 April',
                                    style:
                                        TextStyle(color: Colors.grey.shade400),
                                  ),
                                  trailing: Text(
                                    '18:04',
                                    style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 25.0),
                                  ),
                                  // tileColor: Color(0xFFF5F5F5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          )
        ]),
      ),
    );
  }
}

class MyDialog extends StatefulWidget {
  const MyDialog({super.key, this.onValueChange, this.initialValue});

  final String? initialValue;
  final void Function(String)? onValueChange;

  @override
  State createState() => MyDialogState();
}

class MyDialogState extends State<MyDialog> {
  String? _selectedId;
  String _verticalGroupValue = "Tepat Waktu";

  final List<String> _status = ["Tepat Waktu", "Terlambat"];

  @override
  void initState() {
    super.initState();
    _selectedId = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      elevation: 1,
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        height: MediaQuery.of(context).size.height / 1.8,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'WAKTU SHALAT',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: RadioGroup<String>.builder(
                  groupValue: _verticalGroupValue,
                  direction: Axis.horizontal,
                  onChanged: (value) => setState(() {
                    if (value != null) {
                      _verticalGroupValue = value;
                    }
                  }),
                  items: _status,
                  itemBuilder: (item) => RadioButtonBuilder(
                    item,
                  ),
                ),
              ),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: Colors.grey.shade300,
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.topLeft,
                child: Text(
                  'JENIS SHALAT',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(bottom: 10),
                  child: DropdownButton<String>(
                    hint: const Text("Berjamaah"),
                    value: _selectedId,
                    isExpanded: true,
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          _selectedId = value;
                        });
                        widget.onValueChange?.call(value);
                      }
                    },
                    items: <String>['Berjamaah', 'Sendiri'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  'TEMPAT SHALAT',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(bottom: 10),
                  child: DropdownButton<String>(
                    hint: const Text("Masjid"),
                    value: _selectedId,
                    isExpanded: true,
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          _selectedId = value;
                        });
                        widget.onValueChange?.call(value);
                      }
                    },
                    items: <String>['Masjid', 'Musholla', 'Rumah']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'SHALAT QABLIYAH',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: DropdownButton<String>(
                              hint: const Text("Iya"),
                              value: _selectedId,
                              isExpanded: true,
                              onChanged: (String? value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedId = value;
                                  });
                                  widget.onValueChange?.call(value);
                                }
                              },
                              items:
                                  <String>['Iya', 'Tidak'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'SHALAT BADIYAH',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 3,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              hint: const Text("Iya"),
                              value: _selectedId,
                              onChanged: (String? value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedId = value;
                                  });
                                  widget.onValueChange?.call(value);
                                }
                              },
                              items:
                                  <String>['Iya', 'Tidak'].map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            )),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return TimePicker();
                        });
                  },
                  child: Text(
                    "SIMPAN",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  // color: ColorsHelpers.mainColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TambahShalat extends StatefulWidget {
  const TambahShalat({super.key, this.onValueChange, this.initialValue});

  final String? initialValue;
  final void Function(String)? onValueChange;

  @override
  State createState() => TambahShalatState();
}

class TambahShalatState extends State<TambahShalat> {
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      elevation: 1,
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        height: MediaQuery.of(context).size.height / 1.8,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.center,
                child: Text(
                  'Tambah Shalat',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                height: 5,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(bottom: 15),
                // color: Colors.grey.shade300,
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.topLeft,
                child: Text(
                  'PILIH SHALAT',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(bottom: 10),
                  child: DropdownButton<String>(
                    hint: const Text("Shalat Dhuha"),
                    value: _selectedId,
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          _selectedId = value;
                        });
                        widget.onValueChange?.call(value);
                      }
                    },
                    items: <String>['Shalat Shubuh', 'Shala Dhuha', 'Shalat ']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )),
              Container(
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.topLeft,
                child: Text(
                  'JUMLAH RAKAAT',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(bottom: 10),
                  child: DropdownButton<String>(
                    hint: const Text("2 Rakaat"),
                    value: _selectedId,
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          _selectedId = value;
                        });
                        widget.onValueChange?.call(value);
                      }
                    },
                    items: <String>['2 Rakaat', '3 Rakaat', '4 Rakaat']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )),
              Container(
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.topLeft,
                child: Text(
                  'MASUKKAN WAKTU',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(bottom: 10),
                  child: DropdownButton<String>(
                    hint: const Text("10:45"),
                    value: _selectedId,
                    onChanged: (String? value) {
                      if (value != null) {
                        setState(() {
                          _selectedId = value;
                        });
                        widget.onValueChange?.call(value);
                      }
                    },
                    items: <String>['Tertera'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MyDialog();
                        });
                  },
                  child: Text(
                    "SIMPAN",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  // color: ColorsHelpers.mainColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TimePicker extends StatefulWidget {
  const TimePicker({super.key});

  @override
  State createState() => _MyTimePicker();
}

class _MyTimePicker extends State<TimePicker> {
  // TimeOfDay time = TimeOfDay(hour: 10, minute: 30);
  TimeOfDay time = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      elevation: 1,
      insetPadding: EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 0),
        height: MediaQuery.of(context).size.height / 1.8,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${time.hour}:${time.minute}',
                style: TextStyle(fontSize: 40),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: Text(
                  'Pilih Waktu',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () async {
                  showTimePicker(context: context, initialTime: time);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
