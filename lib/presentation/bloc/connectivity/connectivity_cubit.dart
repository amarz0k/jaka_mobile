import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'connectivity_states.dart'; // Import your states file

class ConnectivityCubit extends Cubit<ConnectivityState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  ConnectivityCubit() : super(ConnectivityInitial()) {
    _initConnectivity();
    _startListening();
  }

  // Initialize connectivity status
  Future<void> _initConnectivity() async {
    try {
      final List<ConnectivityResult> results = await _connectivity
          .checkConnectivity();
      _updateConnectivityStatus(results);
    } catch (e) {
      emit(ConnectivityError('Failed to check connectivity: ${e.toString()}'));
    }
  }

  // Start listening to connectivity changes
  void _startListening() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectivityStatus,
      onError: (error) {
        emit(
          ConnectivityError('Connectivity stream error: ${error.toString()}'),
        );
      },
    );
  }

  // Update connectivity status
  void _updateConnectivityStatus(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none) || results.isEmpty) {
      emit(ConnectivityDisconnected());
    } else {
      emit(ConnectivityConnected(results));
    }
  }

  // Manual connectivity check
  Future<void> checkConnectivity() async {
    try {
      final List<ConnectivityResult> results = await _connectivity
          .checkConnectivity();
      _updateConnectivityStatus(results);
    } catch (e) {
      emit(ConnectivityError('Failed to check connectivity: ${e.toString()}'));
    }
  }

  // Get current connectivity status
  bool get isConnected {
    final currentState = state;
    if (currentState is ConnectivityConnected) {
      return currentState.isConnected;
    }
    return false;
  }

  // Get connection types
  List<ConnectivityResult> get connectionTypes {
    final currentState = state;
    if (currentState is ConnectivityConnected) {
      return currentState.connectivityResults;
    }
    return [];
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    return super.close();
  }
}
