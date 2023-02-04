import 'package:flutter/material.dart';
import './main_drawer.dart';

class Setting_Screen extends StatefulWidget {
  static const RouteName = '/Setting_Screen';

  final Function settingFilter;
  final changedFilter;
  Setting_Screen(this.settingFilter, this.changedFilter);

  @override
  State<Setting_Screen> createState() => _Setting_ScreenState();
}

class _Setting_ScreenState extends State<Setting_Screen> {
  var _Gluten = false;
  var _lactose = false;
  var _vegan = false;
  var _vegetarian = false;

  @override
  void initState() {
    _Gluten = widget.changedFilter['gluten'];
    _lactose = widget.changedFilter['lactose'];
    _vegan = widget.changedFilter['vegan'];
    _vegetarian = widget.changedFilter['vegetarian'];
    super.initState();
  }

  Widget buildSwitch(bool val, String text, String subtext, Function changed) {
    return SwitchListTile(
        title: Text(text),
        subtitle: Text(subtext),
        value: val,
        onChanged: changed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('meal Setting'),
        actions: [
          IconButton(
              onPressed: () {
                widget.settingFilter(_Gluten, _lactose, _vegan, _vegetarian);
              },
              icon: Icon(Icons.save)),
        ],
      ),
      drawer: Main_Drawer(),
      body: Column(children: [
        Container(
          padding: EdgeInsets.all(10),
          child: Text(
            'Select your meal type!',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        Expanded(
          child: ListView(children: [
            buildSwitch(
                _Gluten, 'Gluten-free', 'Only include Gluten-free meals',
                (newVal) {
              setState(() {
                _Gluten = newVal;
              });
            }),
            buildSwitch(
                _lactose, 'lactose-free', 'Only include lactose-free meals',
                (newVal) {
              setState(() {
                _lactose = newVal;
              });
            }),
            buildSwitch(_vegan, 'vegan-free', 'Only include Vegan-free meals',
                (newVal) {
              setState(() {
                _vegan = newVal;
              });
            }),
            buildSwitch(_vegetarian, 'vegetarian-free',
                'Only include vegetarian-free meals', (newVal) {
              setState(() {
                _vegetarian = newVal;
              });
            }),
          ]),
        )
      ]),
    );
  }
}
