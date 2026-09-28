import '../models/quote.dart';

abstract class QuoteState {}

class QuoteInitial extends QuoteState {}

class QuoteLoading extends QuoteState {}

class QuoteSuccess extends QuoteState {
  final Quote quote;

  QuoteSuccess(this.quote);
}

class QuoteError extends QuoteState {
  final String message;

  QuoteError(this.message);
}
