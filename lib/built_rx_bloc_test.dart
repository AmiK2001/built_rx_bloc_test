import 'dart:async';

import 'package:built_rx_bloc/built_rx_bloc.dart';
import 'package:built_value/built_value.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart' as tester;
import 'package:test/test.dart';
import 'package:tuple/tuple.dart';

@isTest
void blocStateTest<
        TBloc extends BuiltRxBloc<TState, TStateBuilder>,
        TState extends Built<TState, TStateBuilder>,
        TStateBuilder extends Builder<TState, TStateBuilder>>(
  String message, {
  required Future<TBloc> Function() build,
  required List<bool Function(TState state)> statePredicates,
  Future<void> Function(TBloc bloc)? event,
  Duration? wait,
  int skip = 1,
  tester.Timeout? timeout,
}) =>
    tester.test(
      message,
      () async {
        final bloc = await build().then((bloc) => bloc..debug = true);

        if (wait != null) await Future<void>.delayed(wait);

        final stateStream = bloc.stateStream.skip(skip);

        stateStream
            .zipWith<bool Function(TState state), Tuple2<TState, Matcher>>(
          Stream.fromIterable(statePredicates),
          (state, predicate) => Tuple2(state, tester.predicate(predicate)),
        )
            .listen((t) {
          tester.expect(t.item1, t.item2);
        });

        await event?.call(bloc);
      },
      timeout: timeout,
    );
