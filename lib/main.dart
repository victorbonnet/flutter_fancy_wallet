import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:card_selector/card_selector.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() => runApp(MyApp());

const w1 = Colors.white;
const w2 = Colors.white70;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var tt = Theme.of(context).textTheme.apply(
          displayColor: w2,
          bodyColor: w2,
        );

    return MaterialApp(
      title: 'Fancy Wallet',
      theme: ThemeData(
        brightness: Brightness.dark,
        textTheme: tt,
      ),
      home: FWHome(),
    );
  }
}

class FWHome extends StatefulWidget {
  @override
  _FWState createState() => _FWState();
}

class _FWState extends State<FWHome> {
  List _cs;
  Map _c;
  double width = 0;

  @override
  void initState() {
    super.initState();

    DefaultAssetBundle.of(context).loadString("assets/in.json").then((d) {
      _cs = json.decode(d);
      setState(() => _c = _cs[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cs == null) return Container();
    if (width <= 0) width = MediaQuery.of(context).size.width - 48.0;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 48.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                "Fancy Wallet",
                style: Theme.of(context).textTheme.display3.copyWith(
                      fontFamily: 'rms',
                      color: w1,
                    ),
              ),
            ),
            SizedBox(height: 32.0),
            CardSelector(
              cards: _cs.map((c) {
                return CreditCardWidget(c);
              }).toList(),
              cardWidth: width,
              cardHeight: width * 0.63,
              onChanged: (i) => setState(() => _c = _cs[i]),
            ),
            Expanded(child: AmountWidget(_c)),
          ],
        ),
      ),
    );
  }
}

class AmountWidget extends StatelessWidget {
  final Map _c;

  AmountWidget(this._c);

  @override
  Widget build(BuildContext context) {
    var tt = Theme.of(context).textTheme;
    var pd = EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0);
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: (_c['trxs'] as List).length + 1,
      itemBuilder: (ctx, idx) {
        if (idx == 0) {
          return Padding(
            padding: pd,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Balance', style: tt.caption),
                SizedBox(height: 8.0),
                Text(_c['bl'], style: tt.display1.apply(color: w1)),
                SizedBox(height: 24.0),
                Text('Today', style: tt.caption),
              ],
            ),
          );
        }

        var trx = _c['trxs'][idx - 1];
        return Padding(
          padding: pd,
          child: Row(
            children: <Widget>[
              Icon(
                MdiIcons.fromString(trx['i']),
                size: 24.0,
                color: Colors.blueGrey,
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(trx['m'], style: tt.title.apply(color: w1)),
                    Text(trx['t'], style: tt.caption),
                  ],
                ),
              ),
              Text(trx['a'], style: tt.body2.apply(color: Colors.deepOrange))
            ],
          ),
        );
      },
    );
  }
}

class CreditCardWidget extends StatelessWidget {
  final Map _c;

  CreditCardWidget(this._c);

  @override
  Widget build(BuildContext context) {
    var tt = Theme.of(context).textTheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        color: Color(_c['co']),
        child: Stack(
          children: <Widget>[
            Image.asset(
              'assets/${_c['txt']}.png',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
            Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(_c['bk'], style: tt.title),
                  Text(_c['ty'].toUpperCase(), style: tt.caption),
                  Expanded(child: Container()),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                          child: Text(_c['num'],
                              style: tt.body2.apply(fontSizeDelta: 3))),
                      Image.asset('assets/${_c['br']}.png', width: 48.0)
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}