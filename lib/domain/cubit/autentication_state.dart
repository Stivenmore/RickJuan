part of 'autentication_cubit.dart';

abstract class AutenticationState extends Equatable {
  const AutenticationState();

  @override
  List<Object> get props => [];
}

class AutenticationInitial extends AutenticationState {}

class AutenticationLoading extends AutenticationState {}

class AutenticationLoaded extends AutenticationState {}

class AutenticationError extends AutenticationState {}