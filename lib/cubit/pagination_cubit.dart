import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_vs_sms_fill/cubit/pagination_state.dart';
import 'package:pagination_vs_sms_fill/data/models/tendr_model.dart';
import 'package:pagination_vs_sms_fill/data/repository/app_repo.dart';

class PaginationCubit extends Cubit<PaginationState> {
  PaginationCubit() : super(InitialState());

  Tendr? tendr;
  List<Datum> data = [];
  bool isFinished = false;

  void loadOrders(int page, int size) async {
    if (page == 0) {
      emit(LoadInProgress());
      data = [];
    }
    await Future.delayed(const Duration(seconds: 2));
    var orders = await MyRepository.getOrdersList();
    data.addAll(orders.data);
    emit(LoadInSuccess(
      orders: data,
    ));
    isFinished = data.length < size;
  }
}
