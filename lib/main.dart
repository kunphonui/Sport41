// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sportapp/views/update_match_view.dart';

import 'bloc/sport_bloc.dart';
import 'bloc/sport_event.dart';
import 'bloc/sport_state.dart';
import 'repositories/sport_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime? dateTime;

  @override
  void initState() {
    super.initState();
    dateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sport Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) =>
            SportBloc(SportRepository())..add(FetchSports(DateFormat('yyyy-MM-dd').format(DateTime.now()))),
        child: BlocListener<SportBloc, SportState>(
          listener: (context, state) {
            if (state is ShowDatePickerState) {
              showDatePicker(
                context: context,
                initialDate: dateTime!,
                firstDate: DateTime(2024),
                lastDate: DateTime(2101),
              ).then((picked) {
                if (picked != null) {
                  dateTime = picked;
                  final selectedDate = DateFormat('yyyy-MM-dd').format(picked);
                  context.read<SportBloc>().add(FetchSports(selectedDate));
                }
              });
            }
          },
          child: const SportScreen(),
        ),
      ),
    );
  }
}

class SportScreen extends StatelessWidget {
  const SportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SportTensor'),
        backgroundColor: Colors.blue,
        actions: [
          ElevatedButton(
            onPressed: () {
              context.read<SportBloc>().add(const ShowDatePicker());
            },
            child: BlocBuilder<SportBloc, SportState>(
              builder: (context, state) {
                if (state is SportLoaded) {
                  return Text(
                    state.matchDate,
                    style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  );
                }
                return const Text(
                  'Select Date',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
        ],
      ),
      body: const SportList(),
    );
  }
}

class SportList extends StatelessWidget {
  const SportList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SportBloc, SportState>(
      builder: (context, state) {
        if (state is SportLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SportLoaded) {
          return RefreshIndicator(
              onRefresh: () async {
                context.read<SportBloc>().add(FetchSports(state.matchDate));
              },
              child: ListView.builder(
                itemCount: state.sports.length,
                itemBuilder: (context, index) {
                  final sport = state.sports[index];
                  final hasOdds = sport.homeTeamOdds != null ||
                      sport.awayTeamOdds != null ||
                      sport.drawOdds != null;
                  return Container(
                    color: hasOdds ? Colors.yellow[100] : Colors.white,
                    child: ListTile(
                      title: Text(
                          '${sport.homeTeamName} vs ${sport.awayTeamName}'),
                      subtitle: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Predict: ${sport.predictedWinner}\n',
                              style: TextStyle(
                                color: sport.predictedWinner != null
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: sport.predictedWinner != null
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(sport.matchDate)}\n',
                            ),
                            TextSpan(
                              text: 'League: ${sport.matchLeague}\n',
                            ),
                            TextSpan(
                              text: 'Home Team Odds: ${sport.homeTeamOdds}\n',
                              style: TextStyle(
                                color: sport.homeTeamOdds != null
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: sport.homeTeamOdds != null
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            TextSpan(
                              text: 'Away Team Odds: ${sport.awayTeamOdds}\n',
                              style: TextStyle(
                                color: sport.awayTeamOdds != null
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: sport.awayTeamOdds != null
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            TextSpan(
                              text: 'Draw Odds: ${sport.drawOdds}\n',
                              style: TextStyle(
                                fontWeight: sport.drawOdds != null
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        final onBack = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MyMatchUpdatePage(sport: sport),
                          ),
                        );

                        if (onBack != null && onBack) {
                          context
                              .read<SportBloc>()
                              .add(FetchSports(state.matchDate));
                        }
                      },
                    ),
                  );
                },
              ));
        } else if (state is SportError) {
          return Center(child: Text('Error: ${state.message}'));
        } else {
          return const Center(child: Text('No sports found'));
        }
      },
    );
  }
}
