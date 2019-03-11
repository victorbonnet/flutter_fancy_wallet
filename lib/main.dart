import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:card_selector/card_selector.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var fancyWalletTextTheme = Theme.of(context).textTheme.apply(
          displayColor: Colors.white70,
          bodyColor: Colors.white70,
        );

    return MaterialApp(
      title: 'Fancy Wallet',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        accentColor: Colors.black87,
        textTheme: fancyWalletTextTheme,
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
  List _cards;
  Map _card;
  double width = 0;

  @override
  void initState() {
    super.initState();

    DefaultAssetBundle.of(context).loadString("assets/cards.json").then((d) {
      _cards = json.decode(d);

      setState(() => _card = _cards[0]);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cards == null) return Container();

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
                style: Theme.of(context).textTheme.display1,
              ),
            ),
            SizedBox(height: 32.0),
            CardSelector(
              cards: _cards.map((c) {
                return CreditCardWidget(c);
              }).toList(),
              cardWidth: width,
              cardHeight: width * 0.63,
              onChanged: (idx) {
                setState(() => _card = _cards[idx]);
              },
            ),
            Expanded(child: AmountWidget(_card)),
          ],
        ),
      ),
    );
  }
}

class AmountWidget extends StatelessWidget {
  final Map _card;

  AmountWidget(this._card);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var pad = EdgeInsets.symmetric(vertical: 8.0, horizontal: 24.0);

    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: (_card['trxs'] as List).length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: pad,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Balance', style: textTheme.caption),
                SizedBox(height: 8.0),
                Text(_card['balance'], style: textTheme.display1),
                SizedBox(height: 24.0),
                Text('Today', style: textTheme.caption),
              ],
            ),
          );
        }

        var trx = _card['trxs'][index - 1];
        return Padding(
          padding: pad,
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(MdiIcons.fromString(trx['icon']), size: 24.0, color: Colors.blueGrey,),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(trx['merchant'], style: textTheme.title),
                    Text(trx['time'], style: textTheme.caption),
                  ],
                ),
              ),
              Text(trx['amount'],
                  style: textTheme.body2.apply(color: Colors.deepOrange, fontWeightDelta: 2))
            ],
          ),
        );
      },
    );
  }
}

class CreditCardWidget extends StatelessWidget {
  final Map _card;

  CreditCardWidget(this._card);

  @override
  Widget build(BuildContext context) {
    String type = _card['type'];

    var tt = Theme.of(context).textTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        color: Color(_card['color']),
        child: Stack(
          children: <Widget>[
            Image.asset(
              'assets/${_card['texture']}.png',
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
                  Text(_card['bank'], style: tt.title),
                  Text(type.toUpperCase(), style: tt.caption),
                  Expanded(child: Container()),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(_card['number'], style: tt.body2.apply(fontWeightDelta: 2))),
                      Image.asset('assets/${_card['brand']}.png', width: 48.0)
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
