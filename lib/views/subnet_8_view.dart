import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportapp/bloc8/trade_bloc.dart';
import 'package:sportapp/bloc8/trade_event.dart';
import 'package:sportapp/bloc8/trade_state.dart';
import 'package:sportapp/repositories/trade_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class Subnet8View extends StatelessWidget {
  const Subnet8View({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => TradeBloc(TradeRepository()),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            actions: [],
          ),
          body: const TradeCoinScreen(),
        ));
  }
}

class TradeCoinScreen extends StatefulWidget {
  const TradeCoinScreen({super.key});

  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State<TradeCoinScreen> {
  final _formKey = GlobalKey<FormState>();
  final _coins = ["BTC", "ETH", "SOL", "XRP", "DOGE"];
  final _leverages = [0.1, 0.2, 0.3, 0.4, 0.5];
  var _chooseCoin = "BTC";
  var _chooseLeverage = 0.1;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TradeBloc, TradeState>(
      listener: (context, state) {},
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Trade Coin',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Text('Choose the coin you want to trade'),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Coin Name'),
                value: _chooseCoin,
                items: _coins
                    .map((coin) => DropdownMenuItem(
                          value: coin,
                          child: Text(coin),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _chooseCoin = value!;
                  });
                },
                onSaved: (value) => _chooseCoin = value!,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<double>(
                decoration: const InputDecoration(labelText: 'Leverage'),
                value: _chooseLeverage,
                items: _leverages
                    .map((leverage) => DropdownMenuItem(
                          value: leverage,
                          child: Text(leverage.toString()),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _chooseLeverage = value!;
                  });
                },
                onSaved: (value) => _chooseLeverage = value!,
              ),
              const SizedBox(height: 50),
              Center(
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                      }

                      context.read<TradeBloc>().add(UpdateTrade(
                            coinName: _chooseCoin,
                            leverage: _chooseLeverage,
                            orderType: 'LONG',
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      backgroundColor: Colors.green, // Background color
                    ),
                    child: const Text(
                      'LONG',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _formKey.currentState?.save();
                      }
                      context.read<TradeBloc>().add(UpdateTrade(
                            coinName: _chooseCoin,
                            leverage: _chooseLeverage,
                            orderType: 'SHORT',
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                      backgroundColor: Colors.red, // Background color
                    ),
                    child: const Text(
                      'SHORT',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final url = 'https://www.google.com/search?q=$_chooseCoin';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: const Text('Search Coin'),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _openChatGptWeb,
                  child: const Text('Open GPT'),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }

  Future<void> _openChatGptWeb() async {
    _copyTeamDetailsToClipboard();

    const url = 'https://chat.openai.com/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _copyTeamDetailsToClipboard() {
    final data = 'Trade Coin: $_chooseCoin';
    Clipboard.setData(ClipboardData(text: data));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }
}
