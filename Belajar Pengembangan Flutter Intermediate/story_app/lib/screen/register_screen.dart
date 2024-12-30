import 'package:declarative_navigation/common.dart';
import 'package:declarative_navigation/provider/auth_provider.dart';
import 'package:declarative_navigation/utils/result_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  final Function() onRegister;
  final Function() onLogin;

  const RegisterScreen({
    Key? key,
    required this.onRegister,
    required this.onLogin,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();

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
                    child: Image.asset('assets/panda2.jpg'),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    AppLocalizations.of(context)?.titleRegister ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context)?.subTitleRegister ?? '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)?.fullName ?? '',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)
                                ?.errorTextFullName ??
                            '';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
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
                        hintText: AppLocalizations.of(context)?.email ?? ''),
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
                  context.watch<AuthProvider>().state == ResultState.loading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              final authRead = context.read<AuthProvider>();
                              final scaffoldMessenger =
                                  ScaffoldMessenger.of(context);

                              await authRead.register(
                                name: nameController.text.trim(),
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );
                              if (authRead.state == ResultState.hasData) {
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(authRead.message ?? ''),
                                  ),
                                );
                                widget.onRegister();
                              } else {
                                scaffoldMessenger.showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(authRead.message ?? ''),
                                  ),
                                );
                              }
                            }
                          },
                          child: Text(
                              AppLocalizations.of(context)?.register ?? ''),
                        ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () => widget.onLogin(),
                    child: Text(AppLocalizations.of(context)?.login ?? ''),
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
