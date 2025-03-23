// lib/bloc/Trade_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/trade_repository.dart';
import 'trade_event.dart';
import 'trade_state.dart';

class TradeBloc extends Bloc<TradeEvent, TradeState> {
  final TradeRepository tradeRepository;

  TradeBloc(this.tradeRepository) : super(TradeInitial()) {
    on<UpdateTrade>((event, emit) async {
      emit(TradeLoading());
      try {
        final response  = await tradeRepository.updateTrade(
          coinName: event.coinName,
          leverage: event.leverage,
          orderType: event.orderType,
        );
        emit(UpdatedTrade(response ?? ''));
      } catch (e) {
        emit(TradeError(e.toString()));
      }
    });
  }
}
