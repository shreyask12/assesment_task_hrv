part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeOnAlphabetsUpdateState extends HomeState {
  final List<CheckBoxesModel> alphabets;

  HomeOnAlphabetsUpdateState({
    required this.alphabets,
  });
}

class HomeOnNumbersUpdateState extends HomeState {
  final List<CheckBoxesModel> numbers;

  HomeOnNumbersUpdateState({required this.numbers});
}

class HomeDefaultState extends HomeState {
  final List<CheckBoxesModel> numbers;
  final List<CheckBoxesModel> alphabets;
  final String maxSelectedNo;
  final String maxAlphabetsNo;
  final String maxNumbersNo;
  final String? totalBoxesDisplayed;
  final bool isMaxSelectionsChanged;

  HomeDefaultState({
    required this.alphabets,
    required this.numbers,
    required this.maxAlphabetsNo,
    required this.maxNumbersNo,
    required this.maxSelectedNo,
    this.totalBoxesDisplayed,
    this.isMaxSelectionsChanged = false,
  });
}

class HomeErrorState extends HomeState {
  final String message;

  HomeErrorState({
    required this.message,
  });
}
