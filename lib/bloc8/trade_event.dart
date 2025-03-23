// lib/bloc/Trade_event.dart
import 'package:equatable/equatable.dart';

abstract class TradeEvent extends Equatable {
  TradeEvent();

  final initialTime = DateTime.now();

  @override
  List<Object?> get props => [];
}

class UpdateTrade extends TradeEvent {
  final String coinName;
  final double leverage;
  final String orderType;

  UpdateTrade({
    required this.coinName,
    required this.leverage,
    required this.orderType,
  });
}
