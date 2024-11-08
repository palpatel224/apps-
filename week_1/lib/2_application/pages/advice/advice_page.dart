import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning/2_application/core/services/theme_services.dart';
import 'package:learning/2_application/pages/advice/cubit/advicer_cubit.dart';
import 'package:learning/2_application/pages/advice/cubit/advicer_state.dart';
import 'package:learning/2_application/pages/advice/widgets/advice_field.dart';
import 'package:learning/2_application/pages/advice/widgets/custombutton.dart';
import 'package:learning/2_application/pages/advice/widgets/error_message.dart';
import 'package:provider/provider.dart';


class AdvicerPageWrapperProvider extends StatelessWidget {
  const AdvicerPageWrapperProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdvicerCubit(),
      child: const AdvicerPage(),
    );
  }
}

class AdvicerPage extends StatelessWidget {
  const AdvicerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Advicer',
            style: themeData.textTheme.displayLarge,
          ),
          centerTitle: true,
          actions: [
            Switch(
                value: Provider.of<ThemeService>(context).isDarkModeOn,
                onChanged: (_) {
                  Provider.of<ThemeService>(context, listen: false)
                      .toggleTheme();
                })
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            children: [
              Expanded(
                  child: Center(child: BlocBuilder<AdvicerCubit, AdvicerCubitState>(
                builder: (context, state) {
                  if (state is AdvicerInitial) {
                    return Text(
                      'Your Advice is waiting for you!',
                      style: themeData.textTheme.displayLarge,
                    );
                  } else if (state is AdvicerStateLoading) {
                    return CircularProgressIndicator(
                      color: themeData.colorScheme.secondary,
                    );
                  } else if (state is AdvicerStateLoaded) {
                    return AdviceField(
                      advice: state.advice,
                    );
                  } else if (state is AdvicerStateError) {
                    return ErrorMessage(message: state.message);
                  }
                  return const SizedBox();
                },
              ))),
              const SizedBox(height: 200, child: Center(child: Custombutton()))
            ],
          ),
        ));
  }
}