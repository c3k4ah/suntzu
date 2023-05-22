import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'juste_event.dart';
part 'juste_state.dart';

class JusteBloc extends Bloc<JusteEvent, JusteState> {
  JusteBloc() : super(JusteInitial()) {
    on<JusteEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
