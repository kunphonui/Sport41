// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/sport_bloc.dart';
import 'bloc/sport_event.dart';
import 'bloc/sport_state.dart';
import 'repositories/sport_repository.dart';
import 'models/sport_match.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return MaterialApp(
      title: 'Sport Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => SportBloc(SportRepository())..add(FetchSports(today)),
        child: const SportList(),
      ),
    );
  }
}

class SportList extends StatelessWidget {
  const SportList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sports'),
      ),
      body: BlocBuilder<SportBloc, SportState>(
        builder: (context, state) {
          if (state is SportLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SportLoaded) {
            return ListView.builder(
              itemCount: state.sports.length,
              itemBuilder: (context, index) {
                final sport = state.sports[index];
                return ListTile(
                  title: Text(sport.homeTeamName),
                  subtitle: Text(sport.awayTeamName),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateMatchScreen(sport: sport),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is SportError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('No sports found'));
          }
        },
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
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Home Team Odds'),
                initialValue: widget.sport.homeTeamOdds.toString(),
                keyboardType: TextInputType.number,
                onSaved: (value) => _homeTeamOdds = double.tryParse(value ?? ''),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Away Team Odds'),
                initialValue: widget.sport.awayTeamOdds.toString(),
                keyboardType: TextInputType.number,
                onSaved: (value) => _awayTeamOdds = double.tryParse(value ?? ''),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Draw Odds'),
                initialValue: widget.sport.drawOdds?.toString(),
                keyboardType: TextInputType.number,
                onSaved: (value) => _drawOdds = double.tryParse(value ?? ''),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Predicted Winner'),
                initialValue: widget.sport.predictedWinner,
                onSaved: (value) => _predictedWinner = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
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
                    Navigator.pop(context);
                  }
                },
                child: const Text('Update Match'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}