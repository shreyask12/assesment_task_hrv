import 'package:assesment_task/model/check_boxes_model.dart';
import 'package:assesment_task/resources/json_retriever.dart';
import 'package:assesment_task/resources/string_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final JsonDataRetriever _jsonDataRetriever;

  HomeCubit(this._jsonDataRetriever) : super(HomeInitial());

  List<CheckBoxesModel> alphabets = [];
  List<CheckBoxesModel> numbers = [];

  int _checkBoxesOnBothSides = 0;

  int _maxTotalSelectionsAllowedOnBothSides = 0;

  int _maxAlphabetSelectionsAllowed = 0;

  int _maxNumberSelectionsAllowed = 0;

  void displayCheckBoxes(String totalCheckBoxes) {
    final alphabetList = _jsonDataRetriever.fetchAplhabets();

    final numbersList = _jsonDataRetriever.fetchNumbers();

    _checkBoxesOnBothSides = int.tryParse(totalCheckBoxes) ?? 0;

    if (_checkBoxesOnBothSides > 11) {
      emit(HomeErrorState(
          message: 'max_total_boxes_created_input_error'.resolveResource()));
    } else if (_checkBoxesOnBothSides == 0) {
      emit(
        HomeDefaultState(
          alphabets: [],
          numbers: [],
          maxAlphabetsNo: '0',
          maxNumbersNo: '0',
          maxSelectedNo: '0',
        ),
      );
    } else {
      alphabets.clear();
      numbers.clear();

      for (int i = 0; i < _checkBoxesOnBothSides; i++) {
        alphabets.add(CheckBoxesModel(
          title: alphabetList[i],
          isSelected: false,
          isError: false,
        ));

        numbers.add(CheckBoxesModel(
          title: numbersList[i],
          isSelected: false,
          isError: false,
        ));
      }
      _maxTotalSelectionsAllowedOnBothSides = _checkBoxesOnBothSides * 2;

      _maxAlphabetSelectionsAllowed = _checkBoxesOnBothSides;
      _maxNumberSelectionsAllowed = _checkBoxesOnBothSides;

      emit(HomeDefaultState(
        alphabets: alphabets,
        numbers: numbers,
        maxSelectedNo: _maxTotalSelectionsAllowedOnBothSides.toString(),
        maxAlphabetsNo: _maxAlphabetSelectionsAllowed.toString(),
        maxNumbersNo: _maxNumberSelectionsAllowed.toString(),
      ));
    }
  }

  void onTotalSelectionsAllowedOnBothSidesChanged(String value) {
    if (value.isEmpty) {
      _maxTotalSelectionsAllowedOnBothSides = 0;

      return;
    }

    _maxTotalSelectionsAllowedOnBothSides = int.tryParse(value) ?? 0;

    if (_maxTotalSelectionsAllowedOnBothSides > (_checkBoxesOnBothSides * 2)) {
      emit(HomeErrorState(
          message: 'max_selection_both_sides_input_error'
              .resolveResourceWithArgs(
                  {'value': (_checkBoxesOnBothSides * 2).toString()})));
    } else {
      if (_maxTotalSelectionsAllowedOnBothSides % 2 == 0) {
        _maxAlphabetSelectionsAllowed =
            (_maxTotalSelectionsAllowedOnBothSides / 2).round();
        _maxNumberSelectionsAllowed =
            (_maxTotalSelectionsAllowedOnBothSides / 2).round();
      } else {
        _maxAlphabetSelectionsAllowed =
            (_maxTotalSelectionsAllowedOnBothSides / 2).round();
        _maxNumberSelectionsAllowed = _maxTotalSelectionsAllowedOnBothSides -
            _maxAlphabetSelectionsAllowed;
      }

      final alphabetList = _jsonDataRetriever.fetchAplhabets();

      final numbersList = _jsonDataRetriever.fetchNumbers();

      alphabets.clear();
      numbers.clear();

      for (int i = 0; i < _checkBoxesOnBothSides; i++) {
        alphabets.add(CheckBoxesModel(
          title: alphabetList[i],
          isSelected: false,
          isError: false,
        ));

        numbers.add(CheckBoxesModel(
          title: numbersList[i],
          isSelected: false,
          isError: false,
        ));
      }

      emit(HomeDefaultState(
        alphabets: alphabets,
        numbers: numbers,
        maxSelectedNo: _maxTotalSelectionsAllowedOnBothSides.toString(),
        maxAlphabetsNo: _maxAlphabetSelectionsAllowed.toString(),
        maxNumbersNo: _maxNumberSelectionsAllowed.toString(),
        isMaxSelectionsChanged: true,
      ));
    }
  }

  void onCheckBoxSelectionChanged(int index,
      {required bool value, required bool isNumbers}) {
    if (value) {
      if (isNumbers) {
        numbers[index].isSelected = value;
        final totalnumbersSelected =
            numbers.where((element) => element.isSelected).toList().length;

        final totalBoxesSelected = totalnumbersSelected +
            alphabets.where((element) => element.isSelected).toList().length;

        if (totalnumbersSelected > _maxNumberSelectionsAllowed) {
          numbers[index].isSelected = false;
          numbers[index].isError = true;
          emit(
            HomeErrorState(
              message: 'max_numbers_selected_error'.resolveResourceWithArgs(
                {'value': (_maxNumberSelectionsAllowed).toString()},
              ),
            ),
          );
        } else if (totalBoxesSelected > _maxTotalSelectionsAllowedOnBothSides) {
          numbers[index].isSelected = false;
          numbers[index].isError = true;
          emit(
            HomeErrorState(
              message: 'max_total_selected_error'.resolveResourceWithArgs(
                {'value': (_maxTotalSelectionsAllowedOnBothSides).toString()},
              ),
            ),
          );
        } else {
          numbers[index].isError = false;
          emit(HomeOnNumbersUpdateState(numbers: numbers));
        }
      } else {
        alphabets[index].isSelected = value;
        final totalAplhabetSelected =
            alphabets.where((element) => element.isSelected).toList().length;

        final totalBoxesSelected = totalAplhabetSelected +
            numbers.where((element) => element.isSelected).toList().length;
        if (totalAplhabetSelected > _maxAlphabetSelectionsAllowed) {
          alphabets[index].isSelected = false;
          alphabets[index].isError = true;
          emit(
            HomeErrorState(
              message: 'max_alphabet_selected_error'.resolveResourceWithArgs(
                {'value': (_maxAlphabetSelectionsAllowed).toString()},
              ),
            ),
          );
        } else if (totalBoxesSelected > _maxTotalSelectionsAllowedOnBothSides) {
          alphabets[index].isSelected = false;
          alphabets[index].isError = true;
          emit(
            HomeErrorState(
              message: 'max_total_selected_error'.resolveResourceWithArgs(
                {'value': (_maxTotalSelectionsAllowedOnBothSides).toString()},
              ),
            ),
          );
        } else {
          alphabets[index].isError = false;
          emit(HomeOnAlphabetsUpdateState(alphabets: alphabets));
        }
      }
    } else {
      if (isNumbers) {
        numbers[index].isSelected = value;
        numbers[index].isError = value;
        emit(HomeOnNumbersUpdateState(numbers: numbers));
      } else {
        alphabets[index].isSelected = value;
        alphabets[index].isError = value;
        emit(HomeOnAlphabetsUpdateState(alphabets: alphabets));
      }
    }
  }

  void onAlphabetsSelectionsChanged(String value) {
    if (value.isEmpty) return;
    _maxAlphabetSelectionsAllowed = int.tryParse(value) ?? 0;
    if (_maxTotalSelectionsAllowedOnBothSides < _maxAlphabetSelectionsAllowed) {
      emit(
        HomeErrorState(
          message:
              'max_selection_alphabets_input_error'.resolveResourceWithArgs(
            {'value': (_maxTotalSelectionsAllowedOnBothSides).toString()},
          ),
        ),
      );
    } else {
      emit(HomeDefaultState(
        alphabets: alphabets,
        numbers: numbers,
        maxSelectedNo: _maxTotalSelectionsAllowedOnBothSides.toString(),
        maxAlphabetsNo: _maxAlphabetSelectionsAllowed.toString(),
        maxNumbersNo: _maxNumberSelectionsAllowed.toString(),
      ));
    }
  }

  void onNumbersSelectionsChanged(String value) {
    if (value.isEmpty) return;
    _maxNumberSelectionsAllowed = int.tryParse(value) ?? 0;
    if (_maxTotalSelectionsAllowedOnBothSides < _maxNumberSelectionsAllowed) {
      emit(
        HomeErrorState(
          message: 'max_selection_numbers_input_error'.resolveResourceWithArgs(
            {'value': (_maxTotalSelectionsAllowedOnBothSides).toString()},
          ),
        ),
      );
    } else {
      emit(HomeDefaultState(
        alphabets: alphabets,
        numbers: numbers,
        maxSelectedNo: _maxTotalSelectionsAllowedOnBothSides.toString(),
        maxAlphabetsNo: _maxAlphabetSelectionsAllowed.toString(),
        maxNumbersNo: _maxNumberSelectionsAllowed.toString(),
      ));
    }
  }

  void resetToZero() {
    numbers.clear();
    alphabets.clear();
    _maxNumberSelectionsAllowed = 0;
    _maxAlphabetSelectionsAllowed = 0;
    _maxTotalSelectionsAllowedOnBothSides = 0;

    emit(HomeDefaultState(
      alphabets: alphabets,
      numbers: numbers,
      totalBoxesDisplayed: '0',
      maxSelectedNo: _maxTotalSelectionsAllowedOnBothSides.toString(),
      maxAlphabetsNo: _maxAlphabetSelectionsAllowed.toString(),
      maxNumbersNo: _maxNumberSelectionsAllowed.toString(),
    ));
  }
}
