import 'package:flutter/material.dart';
import 'package:healthys_app/domain/entities/user_session.dart';
import 'package:healthys_app/ui/notifiers/user_session_notifier.dart';
// TO-DO 3: Importa flutter_riverpod i user_session_provider.dart.
import 'package:healthys_app/ui/screens/register_form.dart';

/// Formulari inicial: funciona amb ValueNotifier abans de la migració.
///
/// TO-DO 3: Converteix-lo en ConsumerStatefulWidget i substitueix les
/// lectures/escriptures de userSessionNotifier per userSessionProvider.
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final controladorCorreu = TextEditingController();
  final controladorPass = TextEditingController();
  bool _passOcult = true;

  @override
  void dispose() {
    controladorCorreu.dispose();
    controladorPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TO-DO 3: En la migració, obtín la sessió amb:
    // final session = ref.watch(userSessionProvider);
    return ValueListenableBuilder<UserSession?>(
      valueListenable: userSessionNotifier,
      builder: (context, session, child) {
        return SafeArea(
          child: Form(
            key: _formKey,
            child: Center(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Image.asset('assets/img/healthys_logo_alpha.png'),
                  ),
                  const SizedBox(height: 16),
                  if (session != null) ...[
                    Center(child: Text('Hola, ${session.name}')),
                    const SizedBox(height: 16),
                    FilledButton.tonal(
                      // TO-DO 3: Tanca la sessió amb el notifier de Riverpod.
                      onPressed: () => userSessionNotifier.value = null,
                      child: const Text('Tanca la sessió'),
                    ),
                  ] else ...[
                    _createEmailField(),
                    const SizedBox(height: 16),
                    _createPassField(),
                    const SizedBox(height: 16),
                    _createSubmitButtons(context),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  TextFormField _createEmailField() {
    return TextFormField(
      controller: controladorCorreu,
      validator: (value) {
        if (value?.isEmpty ?? true) return 'El correu no pot ser buit';

        final regexCorreu = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!regexCorreu.hasMatch(value ?? '')) {
          return 'L\'adreça de correu no és vàlida';
        }
        return null;
      },
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        icon: Icon(Icons.email),
        labelText: 'Adreça de correu',
      ),
    );
  }

  TextFormField _createPassField() {
    return TextFormField(
      controller: controladorPass,
      validator: (value) {
        if (value?.isEmpty ?? true) return 'El password no pot ser buit';
        return null;
      },
      obscureText: _passOcult,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        icon: const Icon(Icons.password),
        labelText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(_passOcult ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _passOcult = !_passOcult),
        ),
      ),
    );
  }

  Widget _createSubmitButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FilledButton(
          onPressed: () {
            if (!(_formKey.currentState?.validate() ?? false)) return;

            // Gestió inicial amb ValueNotifier.
            // TO-DO 3: Escriu aquesta sessió en userSessionProvider.
            userSessionNotifier.value = UserSession(
              name: controladorCorreu.text.trim(),
            );
          },
          child: const Text('Accedeix'),
        ),
        OutlinedButton(
          onPressed: () async {
            final resposta = await showDialog<Map<String, dynamic>>(
              context: context,
              builder: (context) => const RegisterForm(),
            );

            if (resposta != null) {
              controladorCorreu.text = resposta['nom'] ?? '';
              controladorPass.text = resposta['pass'] ?? '';
            }
          },
          child: const Text('Registra\'t'),
        ),
      ],
    );
  }
}
