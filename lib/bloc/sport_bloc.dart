// lib/bloc/sport_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/sport_repository.dart';
import 'sport_event.dart';
import 'sport_state.dart';

class SportBloc extends Bloc<SportEvent, SportState> {
  final SportRepository sportRepository;

  SportBloc(this.sportRepository) : super(SportInitial()) {
    on<FetchSports>((event, emit) async {
      emit(SportLoading());
      try {
        final sports = await sportRepository.fetchSports(event.matchDate,
            matchLeague: event.matchLeague);
        emit(SportLoaded(sports, event.matchDate));
      } catch (e) {
        emit(SportError(e.toString()));
      }
    });

    on<UpdateMatch>((event, emit) async {
      emit(SportLoading());
      try {
        await sportRepository.updateMatch(
          event.matchId,
          homeTeamOdds: event.homeTeamOdds,
          awayTeamOdds: event.awayTeamOdds,
          drawOdds: event.drawOdds,
          predictedWinner: event.predictedWinner,
        );
        emit(MatchUpdated(event.matchId));
      } catch (e) {
        emit(SportError(e.toString()));
      }
    });
  }
}
