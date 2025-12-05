import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/filter_options.dart';

class FilterCubit extends Cubit<FilterOptions> {
  FilterCubit() : super(const FilterOptions());

  void setMagnitude(MagnitudeFilter magnitude) {
    emit(state.copyWith(magnitude: magnitude));
  }

  void setPeriod(TimePeriod period) {
    emit(state.copyWith(period: period));
  }

  void setFilters({MagnitudeFilter? magnitude, TimePeriod? period}) {
    emit(FilterOptions(
      magnitude: magnitude ?? state.magnitude,
      period: period ?? state.period,
    ));
  }

  void resetFilters() {
    emit(const FilterOptions());
  }
}
