import 'package:cars/bloc/app_bottom_form/app_bottom_form.dart';
import 'package:cars/bloc/route_from_to/route_from_to.dart';
import 'package:cars/res/styles.dart';

import 'package:cars/widgets/buttons/button2.dart';
import 'package:cars/widgets/dialogs/planing_dialog_box.dart';

import 'package:cars/widgets/other/blue_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';

import '../../../pages/comment_page.dart';
import '../../../pages/search_page.dart';
import '../../maps/order_form/address_input_filed_v2.dart';

class PassPlanForm extends StatefulWidget {
  PassPlanForm({super.key});

  @override
  State<PassPlanForm> createState() => _PassPlanFormState();
}

class _PassPlanFormState extends State<PassPlanForm> {
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
            height: 45,
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
                height: 45,
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
                  top: 15,
                  child: Icon(Icons.add),
                ),
            ],
          ),
          SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 45,
                child: Expanded(
                  child: InkWell(
                    // onTap: () {
                    //   onTap: () => showMyDialog(context),
                    //   Get.to(SearchPage(
                    //     isFrom: false,
                    //     setAddress: () => setState(() {}),
                    //   ));
                    // },
                    onTap: () async {
                      await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                    },

                    child: to == ''
                        ? AddressInputFieldV2(
                            isActive: false,
                            change: () {},
                            hintText: 'Когда?',
                            icon: const Icon(Icons.calendar_month),
                          )
                        : AddressInputFieldV2(
                            showWhere: true,
                            isActive: false,
                            change: () {},
                            hintText: '11.23.2023 (11:00-12:30)',
                            icon: const BluePoint(),
                          ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
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
          InkWell(
            onTap: () =>
                context.read<AppBottomFormCubit>().set(ShowBottomForm.plan),
            child: Button2(
              title: 'Запланировать поездку',
            ),
          ),
          SizedBox(height: 20),
          // Button2(
          //   title: 'Заказать сейчас',
          // ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
