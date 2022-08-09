// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rickmorty/domain/cubit/autentication_cubit.dart';
import 'package:rickmorty/screens/utils/responsive.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final autentication = context.read<AutenticationCubit>();
    Responsive responsive = Responsive(context);
    return Scaffold(
      body: SizedBox(
        height: responsive.height,
        width: responsive.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('WELCOME'),
              TextFormField(
                controller: _controller1,
                decoration: const InputDecoration(hintText: "Email"),
              ),
              TextFormField(
                controller: _controller2,
                decoration: const InputDecoration(hintText: "Password"),
              ),
              SizedBox(
                height: responsive.hp(10),
              ),
              BlocBuilder<AutenticationCubit, AutenticationState>(
                builder: (context, state) {
                  switch (state.runtimeType) {
                    case AutenticationInitial:
                      return IconButton(
                          onPressed: () {
                            if (_controller1.text.isNotEmpty &&
                                _controller2.text.isNotEmpty) {
                              autentication.signIn(
                                  mail: _controller1.text,
                                  password: _controller2.text);
                            }
                          },
                          icon: const Icon(Icons.search));
                    case AutenticationLoaded:
                      return Column(
                        children: [
                          const Icon(Icons.check),
                          IconButton(
                              onPressed: () {
                                autentication.initialState();
                              },
                              icon: const Icon(Icons.restore))
                        ],
                      );
                    case AutenticationError:
                      return Column(
                        children: [
                          const Icon(Icons.error),
                          IconButton(
                              onPressed: () {
                                autentication.initialState();
                              },
                              icon: const Icon(Icons.restore))
                        ],
                      );
                    case AutenticationLoading:
                      return const CircularProgressIndicator();
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
