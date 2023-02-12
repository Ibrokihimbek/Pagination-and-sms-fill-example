import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_vs_sms_fill/cubit/pagination_cubit.dart';
import 'package:pagination_vs_sms_fill/cubit/pagination_state.dart';
import 'package:pagination_vs_sms_fill/data/models/tendr_model.dart';
import 'package:pagination_vs_sms_fill/utils/gradient_text.dart';

class PaginationPage extends StatefulWidget {
  const PaginationPage({Key? key}) : super(key: key);

  @override
  State<PaginationPage> createState() => _PaginationPageState();
}

class _PaginationPageState extends State<PaginationPage> {
  int page = 0;

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _loadMore(0);
    scrollController.addListener(() {
      print("CURRENT LIST PIXEL:${scrollController.position.pixels}");
      print("MAX LIST PIXEL:${scrollController.position.maxScrollExtent}");
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        _loadMore(page);
      }
    });
    super.initState();
  }

  _loadMore(int index) async {
    var cubit = BlocProvider.of<PaginationCubit>(context);
    if (!cubit.isFinished) {
      cubit.loadOrders(index, 15);
      page++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const GradientText(
          'Tenders',
          style: TextStyle(fontSize: 32),
          gradient: LinearGradient(
            colors: [
              Colors.tealAccent,
              Color(0xFF64FF95),
            ],
          ),
        ),
      ),
      body: BlocBuilder<PaginationCubit, PaginationState>(
        builder: (context, state) {
          if (state is LoadInProgress) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFF64FF95),
                ),
              ),
            );
          } else if (state is LoadInSuccess) {
            List<Datum> orders = state.orders;
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              itemCount: orders.length + 1,
              itemBuilder: (BuildContext context, index) {
                if (index == orders.length) {
                  return Opacity(
                    opacity:
                        context.read<PaginationCubit>().isFinished ? 0.0 : 1.0,
                    child: const SizedBox(
                      height: 40,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF64FF95),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  var item = state.orders[index];
                  return Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.tealAccent.withOpacity(0.4),
                              blurRadius: 4,
                              offset: const Offset(4, 4),
                            ),
                          ],
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white),
                      child: ListTile(
                        title: Text(
                            "Data: ${item.date}\nValue: ${item.awardedValue}"),
                        subtitle: Text("Title: ${item.title}"),
                      ),
                    ),
                  );
                }
              },
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
