import 'package:declarative_navigation/common.dart';
import 'package:declarative_navigation/provider/auth_provider.dart';
import 'package:declarative_navigation/utils/result_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final Function() onLogin;
  final Function() onRegister;

  const LoginScreen({
    Key? key,
    required this.onLogin,
    required this.onRegister,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authWatch = context.watch<AuthProvider>();
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 170,
                    width: 170,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.asset('assets/panda.jpg'),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    AppLocalizations.of(context)?.titleLogin ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context)?.subTitleLogin ?? '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)?.errorTextEmail ??
                            '';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)?.email ?? '',
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)?.password ?? '',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)
                                ?.errorTextPassword ??
                            '';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  authWatch.state != ResultState.loading
                      ? ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              final scaffoldMessenger =
                                  ScaffoldMessenger.of(context);

                              final authRead = context.read<AuthProvider>();

                              await authRead.login(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                              if (authRead.state == ResultState.hasData) {
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text(authRead.message ?? ''),
                                  ),
                                );
                                widget.onLogin();
                              } else {
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    content: Text(authRead.message ?? ''),
                                  ),
                                );
                              }
                            }
                          },
                          child:
                              Text(AppLocalizations.of(context)?.login ?? ''),
                        )
                      : const Center(child: CircularProgressIndicator()),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () => widget.onRegister(),
                    child: Text(AppLocalizations.of(context)?.register ?? ''),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
