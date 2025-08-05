import 'package:auto_route/auto_route.dart';
import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/core/auto_route/app_router.dart';
import 'package:chat_app/presentation/bloc/home/name/name_cubit.dart';
import 'package:chat_app/presentation/bloc/home/name/name_state.dart';
import 'package:chat_app/presentation/bloc/internet_connection_checker/connectivity_cubit.dart';
import 'package:chat_app/presentation/bloc/internet_connection_checker/connectivity_states.dart';
import 'package:chat_app/presentation/widgets/custom_icon_button.dart';
import 'package:chat_app/presentation/widgets/friend_request_widget.dart';
import 'package:chat_app/presentation/widgets/friend_widget.dart';
import 'package:chat_app/presentation/widgets/toastification_toast.dart';
import 'package:chat_app/utils/friends_data_sample.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
        return BlocBuilder<NameCubit, NameState>(
          builder: (context, state) {
            final String name;

            if (state is LoadingState) {
              return Scaffold(
                backgroundColor: Colors.white,
                body: const Center(child: CircularProgressIndicator()),
              );
            }

            if (state is FailureState) {
              showToastification(
                context,
                "Signin Failed",
                Colors.red,
                ToastificationType.error,
              );
            }

            if (state is SuccessState) {
              name = state.user.name.split(' ').first.length > 11
                  ? '${state.user.name.split(' ').first.substring(0, 11)}...'
                  : state.user.name.split(' ').first;

              return DefaultTabController(
                length: 2,
                child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    toolbarHeight: 100,
                    backgroundColor: Colors.white,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello,",
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          name,
                          style: TextStyle(
                            color: AppColors.lightBlack,
                            fontSize: 27,
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
                              size: 40,
                              iconColor: AppColors.lightBlack,
                              borderColor: AppColors.primaryColor,
                              icon: Icons.person,
                              onPressed: () {
                                context.router.push(const ProfileRoute());
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(30),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
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
                            const Tab(text: 'All Chats'),
                            const Tab(text: 'Requests'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: TabBarView(
                      children: [
                        SizedBox(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return FriendWidget(
                                logo: dataSample[index]["logo"],
                                name: dataSample[index]["name"],
                                lastMessage: dataSample[index]["lastMessage"],
                                time: dataSample[index]["time"],
                              );
                            },
                          ),
                        ),

                        SizedBox(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return FriendRequestWidget(
                                profilePicture: dataSample[index]["logo"],
                                name: dataSample[index]["name"],
                              );
                            },
                          ),
                        ),

                        // BlocBuilder<SignOutBloc, SignOutState>(
                        //   builder: (context, state) {
                        //     if (state is AuthInitialState) {
                        //       context.router.replace(const HomeRoute());
                        //     }
                        //     if (state is AuthFailureState) {
                        //       showToastification(
                        //         context,
                        //         "Signin Failed",
                        //         Colors.red,
                        //         ToastificationType.error,
                        //       );
                        //     }
                        //     if (state is AuthLoadingState) {
                        //       return Center(
                        //         child: CircularProgressIndicator(),
                        //       );
                        //     }
                        //     return ElevatedButton(
                        //       onPressed: () {
                        //         context.read<SignOutBloc>().add(
                        //           AuthSignOutEvent(),
                        //         );
                        //       },
                        //       child: Text("Sign out"),
                        //     );
                        //   },
                        // ),
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
        );
      },
    );
  }
}
