import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/sport_bloc.dart';
import '../bloc/sport_event.dart';
import '../bloc/sport_state.dart';
import '../models/sport_match.dart';
import '../repositories/sport_repository.dart';

class MyMatchUpdatePage extends StatelessWidget {
  final SportMatch sport;

  const MyMatchUpdatePage({super.key, required this.sport});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SportBloc(SportRepository()),
      child: BlocListener<SportBloc, SportState>(
        listener: (context, state) {
          if (state is MatchUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Match updated')),
            );

            Navigator.pop(context, true);
          }
        },
        child: UpdateMatchScreen(
          sport: sport,
        ),
      ),
    );
  }
}

class UpdateMatchScreen extends StatefulWidget {
  final SportMatch sport;

  const UpdateMatchScreen({super.key, required this.sport});

  @override
  _UpdateMatchScreenState createState() => _UpdateMatchScreenState();
}

class _UpdateMatchScreenState extends State<UpdateMatchScreen> {
  final _formKey = GlobalKey<FormState>();
  double? _homeTeamOdds;
  double? _awayTeamOdds;
  double? _drawOdds;
  String? _predictedWinner;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Match'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.sport.homeTeamName} vs ${widget.sport.awayTeamName}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('League: ${widget.sport.matchLeague}'),
              Text(
                  'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(widget.sport.matchDate)}'),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Home Team Odds'),
                initialValue: widget.sport.homeTeamOdds?.toString(),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onSaved: (value) =>
                    _homeTeamOdds = double.tryParse(value ?? ''),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Away Team Odds'),
                initialValue: widget.sport.awayTeamOdds?.toString(),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onSaved: (value) =>
                    _awayTeamOdds = double.tryParse(value ?? ''),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Draw Odds'),
                initialValue: widget.sport.drawOdds?.toString(),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onSaved: (value) => _drawOdds = double.tryParse(value ?? ''),
              ),
              DropdownButtonFormField<String>(
                decoration:
                    const InputDecoration(labelText: 'Predicted Winner'),
                value: widget.sport.predictedWinner,
                items: const [
                  DropdownMenuItem(
                    value: 'Home team',
                    child: Text('Home team'),
                  ),
                  DropdownMenuItem(
                    value: 'Away team',
                    child: Text('Away team'),
                  ),
                  DropdownMenuItem(
                    value: 'Draw',
                    child: Text('Draw'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _predictedWinner = value;
                  });
                },
                onSaved: (value) => _predictedWinner = value,
              ),
              const SizedBox(height: 20),
              Center(
                  child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    context.read<SportBloc>().add(UpdateMatch(
                          matchId: widget.sport.matchId,
                          homeTeamOdds: _homeTeamOdds,
                          awayTeamOdds: _awayTeamOdds,
                          drawOdds: _drawOdds,
                          predictedWinner: _predictedWinner,
                        ));
                  }
                },
                child: const Text('Update Match'),
              )),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final url =
                        'https://www.google.com/search?q=${widget.sport.homeTeamName} vs ${widget.sport.awayTeamName}';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: const Text('Search Team'),
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
    final data =
        'Chuyên gia dự đoán tỷ số trận đấu giữa ${widget.sport.homeTeamName} vs ${widget.sport.awayTeamName} - ${widget.sport.matchLeague} - ${DateFormat('yyyy-MM-dd HH:mm').format(widget.sport.matchDate)}';
    Clipboard.setData(ClipboardData(text: data));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }
}
