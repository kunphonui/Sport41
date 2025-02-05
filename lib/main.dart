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
        create: (context) => SportBloc(SportRepository())
          ..add(FetchSports(DateFormat('yyyy-MM-dd').format(DateTime.now()),
              matchLeague: "NBA")),
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
                  context.read<SportBloc>().add(FetchSports(selectedDate,
                      matchLeague: state.matchLanguage));
                } else {
                  context.read<SportBloc>().add(FetchSports(
                      DateFormat('yyyy-MM-dd')
                          .format(dateTime ?? DateTime.now()),
                      matchLeague: state.matchLanguage));
                }
              });
            } else if (state is UpdateAllMatchesSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('All matches updated successfully')),
              );
            } else if (state is UpdateAllMatchesFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('Failed to update all matches: ${state.message}')),
              );
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
        backgroundColor: Colors.blue,
        actions: [
          BlocBuilder<SportBloc, SportState>(
              buildWhen: (previous, current) => current is SportLoaded,
              builder: (context, state) {
                if (state is SportLoaded) {
                  return ElevatedButton(
                    onPressed: () {
                      context
                          .read<SportBloc>()
                          .add(ShowDatePicker(state.matchLanguage));
                    },
                    child: Text(
                      state.matchDate,
                      style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                }

                return const Text("Loading...");
              }),
          const SizedBox(width: 10),
          BlocBuilder<SportBloc, SportState>(
            buildWhen: (previous, current) => current is SportLoaded,
            builder: (context, state) {
              if (state is SportLoaded) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: DropdownButton<String>(
                    value: state.matchLanguage,
                    padding: const EdgeInsets.all(0),
                    borderRadius: BorderRadius.circular(20),
                    underline: Container(),
                    items: <String>['NBA', 'NFL', 'MLB', 'NHL']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(_getLeagueName(value),
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        context.read<SportBloc>().add(
                            FetchSports(state.matchDate, matchLeague: value));
                      }
                    },
                  ),
                );
              }
              return const Text("Loading...");
            },
          ),
          const SizedBox(width: 10),
          CircularIconButton(
            icon: Icons.update,
            onPressed: () {
              context.read<SportBloc>().add(UpdateAllMatches());
            },
          ),
          const SizedBox(width: 30),
        ],
      ),
      body: const SportList(),
    );
  }

  String _getLeagueName(String league) {
    switch (league) {
      case 'NBA':
        return 'Basketball';
      case 'NFL':
        return 'Football';
      case 'MLB':
        return 'Baseball';
      case 'NHL':
        return 'Hockey';
      default:
        return '';
    }
  }
}

class SportList extends StatelessWidget {
  const SportList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SportBloc, SportState>(
      buildWhen: (previous, current) =>
          current is SportLoaded || current is SportError,
      builder: (context, state) {
        if (state is SportLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SportLoaded && state.sports.isNotEmpty) {
          return RefreshIndicator(
              onRefresh: () async {
                context.read<SportBloc>().add(FetchSports(state.matchDate,
                    matchLeague: state.matchLanguage));
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
                          context.read<SportBloc>().add(FetchSports(
                              state.matchDate,
                              matchLeague: state.matchLanguage));
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

class CircularIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const CircularIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white, // Set the background color
      child: IconButton(
        icon: Icon(icon, color: Colors.blue), // Set the icon color
        onPressed: onPressed,
      ),
    );
  }
}
