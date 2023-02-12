import 'package:pagination_vs_sms_fill/data/models/tendr_model.dart';

abstract class PaginationState {}

class InitialState extends PaginationState {}

class LoadInProgress extends PaginationState {}

class LoadInSuccess extends PaginationState {
  final List<Datum> orders;

  LoadInSuccess({
    required this.orders,
  });
}

class LoadInFailure extends PaginationState {}