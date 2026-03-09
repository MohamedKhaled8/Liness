part of 'bottom_navigation_bar_cubit.dart';


abstract class BottomNavigationBarState extends Equatable {
  const BottomNavigationBarState();

  @override
  List<Object> get props => [];
}

class BottomNavigationBarInitial extends BottomNavigationBarState {
  final int index;
  const BottomNavigationBarInitial(this.index);

  @override
  List<Object> get props => [index];
}

class BottomNavigationBarUpdated extends BottomNavigationBarState {
  final int index;
  const BottomNavigationBarUpdated(this.index);

  @override
  List<Object> get props => [index];
}
