import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/app_bottom_form/app_bottom_form.dart';
import 'forms/pass_order_form.dart';
import 'forms/pass_plan_form.dart';

class PassBottomSheetBody extends StatelessWidget {
  const PassBottomSheetBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 340,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          child: context.watch<AppBottomFormCubit>().get() ==
                  ShowBottomForm.orderNow
              ? OrderForm()
              : PassPlanForm(),
        ),
      ),
    );
  }
}
