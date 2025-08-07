class FriendsState {}

class FriendsIntialState extends FriendsState {}

class FriendsLoadingState extends FriendsState {}

class FriendsLoadedState extends FriendsState {
  final List<String> friends;

  FriendsLoadedState({required this.friends});
}

class FriendsSuccessState extends FriendsState {
  final String? message;

  FriendsSuccessState({this.message});
}

class FriendsFailureState extends FriendsState {
  final String? error;

  FriendsFailureState({required this.error});
}

class FriendsEmptyState extends FriendsState {}
