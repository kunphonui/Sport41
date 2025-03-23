// lib/bloc/Trade_state.dart
import 'package:equatable/equatable.dart';

abstract class TradeState extends Equatable {
  TradeState();

  final initialTime = DateTime.now();

  @override
  List<Object> get props => [initialTime];
}

class TradeInitial extends TradeState {}

class TradeLoading extends TradeState {}

class TradeError extends TradeState {
  final String message;

  TradeError(this.message);
}

class UpdatedTrade extends TradeState {
  final String content;

  UpdatedTrade(this.content);
}