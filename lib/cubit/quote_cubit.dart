import 'package:flutter_bloc/flutter_bloc.dart';

import '../repositories/quote_repository.dart';
import 'quote_state.dart';

class QuoteCubit extends Cubit<QuoteState> {
  final QuoteRepository _repository;

  QuoteCubit(this._repository) : super(QuoteInitial());

  Future<void> loadQuote() async {
    emit(QuoteLoading());

    try {
      final quote = await _repository.fetchTodayQuote();
      emit(QuoteSuccess(quote));
    } catch (_) {
      emit(QuoteError('تعذّر تحميل عبارة اليوم. حاولي مرة أخرى.'));
    }
  }
}
