import 'package:assesment_task/model/check_boxes_model.dart';
import 'package:assesment_task/resources/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import 'cubit/home_cubit.dart';
import 'debouncer.dart';
import 'resources/json_retriever.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _totalBoxController = TextEditingController();
  final TextEditingController _bothSideSelectionController =
      TextEditingController();
  final TextEditingController _alphabetsController = TextEditingController();
  final TextEditingController _numbersController = TextEditingController();

  late HomeCubit _cubit;
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    _cubit = HomeCubit(const JsonDataRetriever());
    _cubit.displayCheckBoxes('0');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _cubit,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          bottomNavigationBar: SizedBox(
            width: 100.w,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _cubit.resetToZero();
                    },
                    child: Container(
                      height: 10.h,
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      color: Colors.purpleAccent,
                      child: Center(
                        child: Text(
                          "reset_values_to_zero".resolveResource(),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                BlocBuilder(
                  bloc: _cubit,
                  builder: (context, state) {
                    String message = 'success'.resolveResource();
                    Color boxColor = Colors.greenAccent;
                    if (state is HomeErrorState) {
                      message = state.message;
                      boxColor = Colors.red;
                    }
                    return Expanded(
                      flex: 3,
                      child: Container(
                        height: 10.h,
                        color: boxColor,
                        child: Center(
                          child: Text(
                            message,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          body: BlocListener(
            bloc: _cubit,
            listener: (context, state) {
              if (state is HomeDefaultState) {
                if (!state.isMaxSelectionsChanged) {
                  _bothSideSelectionController.text = state.maxSelectedNo;
                }
                _alphabetsController.text = state.maxAlphabetsNo;
                _numbersController.text = state.maxNumbersNo;
                if (state.totalBoxesDisplayed != null) {
                  _totalBoxController.text = state.totalBoxesDisplayed!;
                }
              }
            },
            child: SafeArea(
              bottom: false,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 27.h,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 70.w,
                              child: Text(
                                'total_boxes_each_side_header'
                                    .resolveResource(),
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 10.w,
                              height: 5.h,
                              child: TextFormField(
                                controller: _totalBoxController,
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.center,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                    top: 15.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  _debouncer.run(
                                      () => _cubit.displayCheckBoxes(value));
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width: 70.w,
                                child: Text('max_selections_allowed'
                                    .resolveResource())),
                            const Spacer(),
                            SizedBox(
                              width: 10.w,
                              height: 5.h,
                              child: TextFormField(
                                controller: _bothSideSelectionController,
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.center,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                    top: 15.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  _debouncer.run(() => _cubit
                                      .onTotalSelectionsAllowedOnBothSidesChanged(
                                          value));
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 70.w,
                              child: Text(
                                'max_alphabets_allowed'.resolveResource(),
                                maxLines: 2,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 10.w,
                              height: 5.h,
                              child: TextFormField(
                                controller: _alphabetsController,
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.center,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                    top: 15.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  _debouncer.run(() => _cubit
                                      .onAlphabetsSelectionsChanged(value));
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width: 70.w,
                                child: Text(
                                    'max_numbers_allowed'.resolveResource())),
                            const Spacer(),
                            SizedBox(
                              width: 10.w,
                              height: 5.h,
                              child: TextFormField(
                                controller: _numbersController,
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.center,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                    top: 15.0,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                  ),
                                ),
                                onChanged: (value) {
                                  _debouncer.run(() =>
                                      _cubit.onNumbersSelectionsChanged(value));
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 1.0,
                    thickness: 5.0,
                    color: Colors.black,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        BlocBuilder(
                            bloc: _cubit,
                            buildWhen: (previous, current) =>
                                current is HomeDefaultState ||
                                current is HomeOnAlphabetsUpdateState,
                            builder: (context, state) {
                              List<CheckBoxesModel> alphabetsList = [];

                              if (state is HomeDefaultState) {
                                alphabetsList = state.alphabets;
                              } else if (state is HomeOnAlphabetsUpdateState) {
                                alphabetsList.clear();
                                alphabetsList = state.alphabets;
                              }
                              return Expanded(
                                child: ListView.builder(
                                  itemCount: alphabetsList.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return SizedBox(
                                      width: 50,
                                      height: 36,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Checkbox(
                                            value:
                                                alphabetsList[index].isSelected,
                                            onChanged: (value) {
                                              _cubit.onCheckBoxSelectionChanged(
                                                  index,
                                                  value: value!,
                                                  isNumbers: false);
                                            },
                                          ),
                                          Text(alphabetsList[index].title),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                        Container(
                          width: 5,
                          color: Colors.black,
                        ),
                        BlocBuilder(
                          bloc: _cubit,
                          buildWhen: (previous, current) =>
                              current is HomeDefaultState ||
                              current is HomeOnNumbersUpdateState,
                          builder: (context, state) {
                            List<CheckBoxesModel> numbersList = [];
                            if (state is HomeDefaultState) {
                              numbersList = state.numbers;
                            } else if (state is HomeOnNumbersUpdateState) {
                              numbersList.clear();
                              numbersList = state.numbers;
                            }
                            return Expanded(
                              child: ListView.builder(
                                itemCount: numbersList.length,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    width: 50,
                                    height: 36,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Checkbox(
                                          value: numbersList[index].isSelected,
                                          onChanged: (value) {
                                            _cubit.onCheckBoxSelectionChanged(
                                                index,
                                                value: value!,
                                                isNumbers: true);
                                          },
                                        ),
                                        Text(numbersList[index].title),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
