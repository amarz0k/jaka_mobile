import 'package:equatable/equatable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectivityState extends Equatable {
  const ConnectivityState();

  @override
  List<Object> get props => [];
}

class ConnectivityInitial extends ConnectivityState {}

class ConnectivityConnected extends ConnectivityState {
  final List<ConnectivityResult> connectivityResults;

  const ConnectivityConnected(this.connectivityResults);

  @override
  List<Object> get props => [connectivityResults];

  bool get isConnected =>
      connectivityResults.isNotEmpty &&
      !connectivityResults.contains(ConnectivityResult.none);

  bool get hasWifi => connectivityResults.contains(ConnectivityResult.wifi);
  bool get hasMobile => connectivityResults.contains(ConnectivityResult.mobile);
  bool get hasEthernet =>
      connectivityResults.contains(ConnectivityResult.ethernet);
}

class ConnectivityDisconnected extends ConnectivityState {}

class ConnectivityError extends ConnectivityState {
  final String message;

  const ConnectivityError(this.message);

  @override
  List<Object> get props => [message];
}
