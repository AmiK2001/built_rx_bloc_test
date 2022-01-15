import 'package:built_rx_bloc_test/built_rx_bloc_test.dart';
import 'package:test/test.dart';

import 'blocs/sum_bloc.dart';
import 'blocs/sum_state.dart';

void main() {
  group('SumBloc tests', () {
    blocStateTest<SumBloc, SumState, SumStateBuilder>(
      'sum test',
      build: () async => SumBloc(),
      event: (bloc) async => bloc.sum(5, 10),
      statePredicates: [
        (state) => state.sum == 5 + 10,
      ],
    );
  });
}
