import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_vs_sms_fill/cubit/pagination_state.dart';
import 'package:pagination_vs_sms_fill/data/api_service/api_service.dart';
import 'package:pagination_vs_sms_fill/data/models/tendr_model.dart';

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
    var orders = await ApiService.getOrdersList();
    data.addAll(orders.data);
    emit(LoadInSuccess(
      orders: data,
    ));
    isFinished = data.length < size;
  }
}
