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
        String matchLeague = event.matchLeague;
        if (matchLeague == 'NFL') {
          matchLeague = 'English Premier League';
        }
        final sports = await sportRepository.fetchSports(event.matchDate,
            matchLeague: matchLeague);

        print("====> load match success: ${sports.length}");
        if (sports.isNotEmpty) {
          emit(SportLoaded(sports, event.matchDate, event.matchLeague));
        } else {
           emit(SportError("Data empty"));
        }
      } catch (e) {
        print("====> error load match: ${e.toString()}");
        // emit(SportLoaded(const [], event.matchDate, event.matchLeague));
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

    on<ShowDatePicker>((event, emit) {
      emit(ShowDatePickerState(matchLanguage: event.matchLanguage));
    });

    on<UpdateAllMatches>((event, emit) async {
      try {
        await sportRepository.updateAllMatches();
        emit(UpdateAllMatchesSuccess());
      } catch (e) {
        emit(UpdateAllMatchesFailure(e.toString()));
      }
    });
  }
}
