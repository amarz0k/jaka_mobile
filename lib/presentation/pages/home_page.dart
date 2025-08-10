import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/core/auto_route/app_router.dart';
import 'package:chat_app/domain/entities/friend_entity.dart';
import 'package:chat_app/presentation/bloc/home/user_data/user_data_cubit.dart';
import 'package:chat_app/presentation/bloc/home/user_data/user_data_state.dart';
import 'package:chat_app/presentation/bloc/connectivity/connectivity_cubit.dart';
import 'package:chat_app/presentation/bloc/connectivity/connectivity_states.dart';
import 'package:chat_app/presentation/widgets/custom_icon_button.dart';
import 'package:chat_app/presentation/widgets/custom_text_field.dart';
import 'package:chat_app/presentation/widgets/friend_request_widget.dart';
import 'package:chat_app/presentation/widgets/friend_widget.dart';
import 'package:chat_app/presentation/widgets/image_detector.dart';
import 'package:chat_app/presentation/widgets/toastification_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _addFriendController = TextEditingController();

    return BlocConsumer<ConnectivityCubit, ConnectivityState>(
      listenWhen: (previous, current) {
        return (current is ConnectivityConnected &&
                previous is ConnectivityDisconnected) ||
            (current is ConnectivityDisconnected &&
                previous is ConnectivityConnected) ||
            current is ConnectivityError;
      },
      listener: (context, state) {
        if (state is ConnectivityDisconnected) {
          showToastification(
            context,
            "Internet connection Lost",
            Colors.red,
            ToastificationType.error,
          );
        }

        if (state is ConnectivityConnected) {
          showToastification(
            context,
            "Internet connection restored",
            Colors.green,
            ToastificationType.error,
          );
        }

        if (state is ConnectivityError) {
          showToastification(
            context,
            "Connectivity Error",
            Colors.red,
            ToastificationType.error,
          );
        }
      },
      builder: (context, state) {
        return BlocListener<UserDataCubit, UserDataState>(
          listener: (context, state) {
            if (state is FailureState) {
              showToastification(
                context,
                state.error!,
                Colors.red,
                ToastificationType.error,
              );
            }

            if (state is SuccessState) {
              showToastification(
                context,
                state.message!,
                Colors.green,
                ToastificationType.success,
              );
            }

            if (state is UserDataLoadedState) {
              // Handle success messages within UserDataLoadedState
              if (state.message != null) {
                showToastification(
                  context,
                  state.message!,
                  Colors.green,
                  ToastificationType.success,
                );
              }

              // Handle error messages within UserDataLoadedState
              if (state.error != null) {
                showToastification(
                  context,
                  state.error!,
                  Colors.red,
                  ToastificationType.error,
                );
              }
            }
          },
          child: BlocBuilder<UserDataCubit, UserDataState>(
            builder: (context, state) {
              final String name;

              if (state is LoadingState) {
                return Scaffold(
                  backgroundColor: Colors.white,
                  body: const Center(child: CircularProgressIndicator()),
                );
              }

              if (state is UserDataLoadedState) {
                name = state.user.name.split(' ').first.length > 11
                    ? '${state.user.name.split(' ').first.substring(0, 11)}...'
                    : state.user.name.split(' ').first;

                return DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      toolbarHeight: 170,
                      backgroundColor: Colors.white,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello,",
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            name,
                            style: TextStyle(
                              color: AppColors.lightBlack,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Row(
                            children: [
                              CustomIconButton(
                                size: 40,
                                iconColor: AppColors.lightBlack,
                                borderColor: AppColors.primaryColor,
                                icon: Icons.search,
                                onPressed: () {},
                              ),
                              const SizedBox(width: 10),
                              CustomIconButton(
                                size: 45,
                                iconColor: AppColors.lightBlack,
                                borderColor: Colors.transparent,
                                isIcon: true,
                                onPressed: () =>
                                    context.router.push(const SettingsRoute()),
                                widget: state.user.photoUrl != null
                                    ? imageDetector(
                                        state.user.photoUrl!,
                                        100,
                                        isCircle: true,
                                        radius: 100,
                                      )
                                    : imageDetector(
                                        "https://via.placeholder.com/150",
                                        100,
                                        isCircle: true,
                                        radius: 100,
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(60),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 20,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TabBar(
                                dividerColor: Colors.transparent,
                                overlayColor: WidgetStateProperty.all(
                                  Colors.transparent,
                                ),
                                indicator: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.grey.shade600,
                                isScrollable: false,
                                indicatorSize: TabBarIndicatorSize.tab,
                                tabs: [
                                  const Tab(
                                    child: Text(
                                      'All Chats',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Tab(
                                    child: Text(
                                      'Requests',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: CustomTextField(
                                      hintText: "Add Friend",
                                      textEditingController:
                                          _addFriendController,
                                      errorText: null,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  IconButton(
                                    onPressed: () {
                                      context.read<UserDataCubit>().addFriend(
                                        _addFriendController.text,
                                      );
                                    },
                                    style: IconButton.styleFrom(
                                      backgroundColor: AppColors.primaryColor,
                                      overlayColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                      ),
                                    ),
                                    padding: EdgeInsets.all(13),
                                    icon: Icon(
                                      Icons.person_add_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    body: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TabBarView(
                        children: [
                          SizedBox(
                            child: BlocBuilder<UserDataCubit, UserDataState>(
                              builder: (context, requestsState) {
                                List<FriendEntity>? friends;

                                // Extract incoming requests from different state types
                                if (requestsState is UserDataLoadedState) {
                                  friends = requestsState.friends;
                                }
                                log("friends homepage: $friends");

                                if (friends != null) {
                                  if (friends.isEmpty) {
                                    return Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Center(
                                        child: Text(
                                          "You have no friends",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                      ),
                                    );
                                  }

                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: friends.length,
                                    itemBuilder: (context, index) {
                                      final request = friends![index];
                                      return FriendWidget(
                                        logo:
                                            request.photoUrl ??
                                            'https://via.placeholder.com/150',
                                        name: request.name,
                                        lastMessage: null,
                                        time: null,
                                        nameFontSize: 20,
                                        lastMessageFontSize: 16,
                                        onTap: () {
                                          context.router.push(
                                            ConversationRoute(
                                              friendId: request.id,
                                              friendName: request.name,
                                              friendPhotoUrl: request.photoUrl,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                } else if (requestsState is LoadingState) {
                                  return const Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else if (requestsState is FailureState) {
                                  return Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      "Failed to load friends",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                      ),
                                    ),
                                  );
                                }

                                // Default case - show empty state
                                return Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                            ),
                          ),

                          SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 20),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Incoming Requests",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                BlocBuilder<UserDataCubit, UserDataState>(
                                  builder: (context, requestsState) {
                                    List<FriendEntity>? incomingRequests;

                                    // Extract incoming requests from different state types
                                    if (requestsState is UserDataLoadedState) {
                                      incomingRequests =
                                          requestsState.incomingRequests;
                                    }

                                    if (incomingRequests != null) {
                                      if (incomingRequests.isEmpty) {
                                        return Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Text(
                                            "No incoming requests",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        );
                                      }

                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: incomingRequests.length,
                                        itemBuilder: (context, index) {
                                          final request =
                                              incomingRequests![index];
                                          return FriendRequestWidget(
                                            profilePicture:
                                                request.photoUrl ??
                                                'https://via.placeholder.com/150',
                                            name: request.name,
                                            isIncoming: true,
                                            onAccept: () {
                                              context
                                                  .read<UserDataCubit>()
                                                  .acceptFriendRequest(
                                                    request.id,
                                                  );
                                            },
                                            onReject: () {
                                              context
                                                  .read<UserDataCubit>()
                                                  .rejectFriendRequest(
                                                    request.id,
                                                  );
                                            },
                                          );
                                        },
                                      );
                                    } else if (requestsState is LoadingState) {
                                      return const Padding(
                                        padding: EdgeInsets.all(20.0),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    } else if (requestsState is FailureState) {
                                      return Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Text(
                                          "Failed to load incoming requests",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.red,
                                          ),
                                        ),
                                      );
                                    }

                                    // Default case - show empty state
                                    return Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text(
                                        "No incoming requests",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Outgoing Requests",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                BlocBuilder<UserDataCubit, UserDataState>(
                                  builder: (context, requestsState) {
                                    List<FriendEntity>? outgoingRequests;

                                    // Extract incoming requests from different state types
                                    if (requestsState is UserDataLoadedState) {
                                      outgoingRequests =
                                          requestsState.outgoingRequests;
                                    }

                                    if (outgoingRequests != null) {
                                      if (outgoingRequests.isEmpty) {
                                        return Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Text(
                                            "No outgoing requests",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        );
                                      }

                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: outgoingRequests.length,
                                        itemBuilder: (context, index) {
                                          final request =
                                              outgoingRequests![index];
                                          return FriendRequestWidget(
                                            profilePicture:
                                                request.photoUrl ??
                                                'https://via.placeholder.com/150',
                                            name: request.name,
                                            isIncoming: false,
                                            onReject: () {
                                              context
                                                  .read<UserDataCubit>()
                                                  .rejectFriendRequest(
                                                    request.id,
                                                  );
                                            },
                                          );
                                        },
                                      );
                                    } else if (requestsState is LoadingState) {
                                      return const Padding(
                                        padding: EdgeInsets.all(20.0),
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    } else if (requestsState is FailureState) {
                                      return Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Text(
                                          "Failed to load outgoing requests",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.red,
                                          ),
                                        ),
                                      );
                                    }

                                    // Default case - show empty state
                                    return Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text(
                                        "No outgoing requests",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return const Scaffold(
                backgroundColor: Colors.white,
                body: Center(child: CircularProgressIndicator()),
              );
            },
          ),
        );
      },
    );
  }
}
