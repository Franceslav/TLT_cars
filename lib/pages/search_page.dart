import 'dart:async';

import 'package:cars/bloc/live_search/live_search_bloc.dart';
import 'package:cars/models/place.dart';
import 'package:cars/pages/pass_home_page.dart';
import 'package:cars/res/styles.dart';
import 'package:cars/widgets/map_container.dart';
import 'package:cars/widgets/maps/map_page.dart';
import 'package:cars/widgets/maps/order_form/address_input_filed.dart';
import 'package:cars/widgets/maps/search_form/search_results.dart';
import 'package:cars/widgets/maps/search_form/search_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../bloc/route_from_to/route_from_to.dart';

class SearchPage extends StatefulWidget {
  SearchPage({
    super.key,
    required this.setAddress,
    required this.isFrom,
  });
  Function setAddress;
  bool isFrom;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Place> result = [];
  bool isLoading = false;
  Timer? timer;
  bool showOnMap = false;
  FocusNode focus = new FocusNode();
  String place = '';
  @override
  Widget build(BuildContext context) {
    context.watch<LiveSearchBloc>().state.when(
          loaded: (res) {
            if (!showOnMap) {
              isLoading = false;
              result = res;
            } else {
              try {
                place = res[0].name;
                result = res;
                print(res[0].name);
              } catch (e) {
                print(e);
              }
            }
          },
          loading: () {
            if (!showOnMap) {
              isLoading = true;
            }
          },
          error: () {},
          noData: () {
            result = [];
          },
        );

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.bottomLeft,
                color: Colors.white,
                width: double.infinity,
                padding: EdgeInsets.only(top: 10, left: 10),
                child: InkWell(
                  onTap: () {
                    try {
                      widget.isFrom
                          ? context.read<RouteFromToCubit>().setFrom(result[0])
                          : context.read<RouteFromToCubit>().setTo(result[0]);
                      widget.setAddress();
                    } catch (e) {}
                    Get.to(() => PassHomePage());
                  },
                  child: Icon(Icons.arrow_back_ios),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      showOnMap = false;
                    });
                    Future.delayed(Duration(milliseconds: 200), () {
                      FocusScope.of(context).requestFocus(focus);
                    });
                  },
                  child: AddressInputField(
                    focus: focus,
                    isActive: !showOnMap,
                    change: (val) {
                      if (val != '') {
                        timer?.cancel();
                        context
                            .read<LiveSearchBloc>()
                            .add(LiveSearchEvent.fetch(text: val));
                        context
                            .read<LiveSearchBloc>()
                            .add(LiveSearchEvent.fetch(text: val));
                      }
                    },
                    hintText: showOnMap ? place : 'Куда поедете?',
                    icon: Container(
                      width: 5,
                      height: 5,
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: blue,
                      ),
                    ),
                  ),
                ),
              ),
              // if (!showOnMap)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        if (!isLoading)
                          Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    showOnMap = true;
                                  });
                                },
                                child: SearchRow(
                                  firstString: 'Указать на карте',
                                  secnodString: '',
                                  icon: Container(
                                    alignment: Alignment.center,
                                    height: 35,
                                    child:
                                        SvgPicture.asset('asstes/telegram.svg'),
                                  ),
                                ),
                              ),
                              const Divider(),
                              const SizedBox(height: 6),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : showOnMap
                      ? Container(
                          //  margin: EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 230,
                          child: MapContainer(),
                        )
                      : SearchResultsColumn(
                          isFrom: widget.isFrom,
                          results: result,
                          setAddress: widget.setAddress),
            ],
          ),
        ),
      ),
    );
  }
}
