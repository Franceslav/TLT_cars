import 'package:cars/bloc/app_bottom_form/app_bottom_form.dart';
import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/res/styles.dart';

import 'package:cars/widgets/buttons/button1.dart';
import 'package:cars/widgets/buttons/button2.dart';
import 'package:cars/widgets/maps/order_form/address_input_filed.dart';
import 'package:cars/widgets/maps/order_form/saved_address.dart';
import 'package:cars/widgets/maps/search_form/search_row.dart';
import 'package:cars/widgets/other/blue_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';

import '../../../pages/comment_page.dart';
import '../../../pages/search_page.dart';
import '../../maps/order_form/address_input_filed_v2.dart';

class OrderForm extends StatefulWidget {
  OrderForm({super.key});

  @override
  State<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  @override
  void initState() {
    super.initState();
  }

  String from = '';
  String to = '';
  String comment = '';
  @override
  Widget build(BuildContext context) {
    from = context.watch<RouteFromToCubit>().get().from?.name ?? '';
    to = context.watch<RouteFromToCubit>().get().to?.name ?? '';
    comment = context.read<RouteFromToCubit>().get().comment ?? '';
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            height: 50,
            child: Expanded(
              child: InkWell(
                onTap: () {
                  Get.to(SearchPage(
                    isFrom: true,
                    setAddress: () => setState(() {}),
                  ));
                },
                child: from == ''
                    ? AddressInputFieldV2(
                        isActive: false,
                        change: () {},
                        hintText: 'Откуда?',
                        icon: const Icon(Icons.search),
                      )
                    : AddressInputFieldV2(
                        showFrom: true,
                        isActive: false,
                        change: () {},
                        hintText: from,
                        icon: const BluePoint(),
                      ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Stack(
            children: [
              Container(
                height: 50,
                child: Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.to(SearchPage(
                        isFrom: false,
                        setAddress: () => setState(() {}),
                      ));
                    },
                    child: to == ''
                        ? AddressInputFieldV2(
                            isActive: false,
                            change: () {},
                            hintText: 'Куда?',
                            icon: const Icon(Icons.search),
                          )
                        : AddressInputFieldV2(
                            showWhere: true,
                            isActive: false,
                            change: () {},
                            hintText: to,
                            icon: const BluePoint(),
                          ),
                  ),
                ),
              ),
              if (context.read<RouteFromToCubit>().get().to != null)
                const Positioned(
                  right: 0,
                  top: 20,
                  child: Icon(Icons.add),
                ),
            ],
          ),
          SizedBox(height: 30),
          InkWell(
            onTap: () {
              Get.to(CommentPage(
                setComment: (val) => setState(() {
                  comment = val;
                }),
              ));
            },
            child: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 0.1),
              ),
              child: Row(
                children: [
                  SizedBox(width: 15),
                  Icon(
                    Icons.message_outlined,
                    color: black.withOpacity(0.7),
                  ),
                  SizedBox(width: 15),
                  Text(comment != '' ? comment : 'Комментарий водителю',
                      style: h13w400Black)
                ],
              ),
            ),
          ),
          SizedBox(height: 30),
          Button2(
            title: 'Заказать сейчас',
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
