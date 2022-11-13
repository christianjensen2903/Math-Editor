import 'package:equatable/equatable.dart';

import 'package:frontend/models/models.dart';

class StateBase extends Equatable {
  final AppError? error;

  const StateBase({this.error});

  @override
  List<Object?> get props => [error];
}
