import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/res/styles.dart';
import 'package:cars/widgets/maps/order_form/address_input_filed.dart';
import 'package:cars/widgets/maps/order_form/saved_address.dart';
import 'package:cars/widgets/other/blue_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';

import '../../../pages/search_page.dart';

class OrderFormOld extends StatefulWidget {
  OrderFormOld({super.key});

  @override
  State<OrderFormOld> createState() => _OrderFormOldState();
}

class _OrderFormOldState extends State<OrderFormOld> {
  @override
  void initState() {
    super.initState();
  }

  String from = '';
  String to = '';
  @override
  Widget build(BuildContext context) {
    from = context.watch<RouteFromToCubit>().get().from?.name ?? '';
    to = context.watch<RouteFromToCubit>().get().to?.name ?? '';
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.to(SearchPage(
                      isFrom: true,
                      setAddress: () => setState(() {}),
                    ));
                  },
                  child: from == ''
                      ? AddressInputField(
                          isActive: false,
                          change: () {},
                          hintText: 'Откуда?',
                          icon: const Icon(Icons.search),
                        )
                      : AddressInputField(
                          showFrom: true,
                          isActive: false,
                          change: () {},
                          hintText: from,
                          icon: const BluePoint(),
                        ),
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.to(SearchPage(
                      isFrom: false,
                      setAddress: () => setState(() {}),
                    ));
                  },
                  child: to == ''
                      ? AddressInputField(
                          isActive: false,
                          change: () {},
                          hintText: 'Куда?',
                          icon: const Icon(Icons.search),
                        )
                      : AddressInputField(
                          showWhere: true,
                          isActive: false,
                          change: () {},
                          hintText: to,
                          icon: const BluePoint(),
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(),
          const Row(
            children: [
              Expanded(child: SavedAddress()),
              SizedBox(width: 20),
              Expanded(child: SavedAddress())
            ],
          ),
          const SizedBox(height: 5),
          const Row(
            children: [
              Expanded(child: SavedAddress()),
              SizedBox(width: 20),
              Expanded(child: SavedAddress())
            ],
          )
        ],
      ),
    );
  }
}
