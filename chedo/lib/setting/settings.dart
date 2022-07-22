import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late bool mode;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mode ? Colors.white24 : Colors.white,
      appBar: AppBar(
        title: const Text("Setting"),
        backgroundColor: mode ? Colors.black26 : Colors.black54,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(20),
            child: ListTile(
              title: Text(
                "App Dark Mode",
                style: TextStyle(
                    fontSize: 20, color: mode ? Colors.white : Colors.black87),
              ),
              trailing: Switch(
                value: mode,
                onChanged: (bool b) {},
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(20),
            child: ListTile(
              leading: Text(
                'Font Size',
                style: TextStyle(
                    fontSize: 20, color: mode ? Colors.white : Colors.black87),
              ),
              trailing: DropdownButton<String>(
                hint: const Text("select size"),
                items: <String>['A', 'B', 'C', 'D'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
            ),
          )
        ],
      ),
    );
  }
}
