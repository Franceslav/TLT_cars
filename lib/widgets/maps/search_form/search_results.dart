import 'package:cars/pages/pass_home_page.dart';
import 'package:cars/widgets/maps/search_form/search_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../../../bloc/route_from_to/route_from_to.dart';
import '../../../models/place.dart';
import '../../../res/styles.dart';

class SearchResultsColumn extends StatelessWidget {
  SearchResultsColumn({
    super.key,
    required this.results,
    required this.setAddress,
    required this.isFrom,
    required,
  });
  List<Place> results;
  Function setAddress;
  bool isFrom;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...results.map(
          (e) => Column(
            children: [
              InkWell(
                onTap: () {
                  isFrom
                      ? context.read<RouteFromToCubit>().setFrom(e)
                      : context.read<RouteFromToCubit>().setTo(e);
                  setAddress();
                  Get.to(() => PassHomePage());
                },
                child: Container(
                  height: 41,
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  width: double.infinity,
                  child: SearchRow(
                    firstString: e.name,
                    secnodString: e.description ?? '',
                    icon: Container(
                      width: 5,
                      height: 5,
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 3,
                        backgroundColor: blue,
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ],
    );
  }
}
