import 'package:flutter/material.dart';
import 'package:healthys_app/ui/screens/FondoPainter.dart';
import 'package:healthys_app/ui/screens/register_form.dart';

// Formulari de Login: Widget amb estat
class LoginForm extends StatefulWidget {
  const LoginForm(
      {super.key,
        required this.callback,
        required this.username,
      required this.size});

  // Afegim una funció de callback al widget, que serà
  // la que s'executarà quan enviem el formulari
  final Function callback;
  final String? username;
  final Size size;

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

// Classe estata associat al widget
class LoginFormState extends State<LoginForm> {
  // Clau global que usarem per validar el formulari
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController controladorCorreu = TextEditingController();
  final TextEditingController controladorPass = TextEditingController();

  // Per controlar visibilització del password
  late bool _pass1Ocult;

  @override
  Widget build(BuildContext context) {
    final double width = widget.size.width;
    final double height = widget.size.height;

    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(painter: FondoPainter(), child: const SizedBox.expand()),
          SafeArea(
            child: Center(
            // Per evitar superposar la UI amb els controls del sistema
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 480, maxHeight: 640),
              child: Form(
                // Clau del formulari: la clau _formKey generada
                key: _formKey,
                // ListView per organitzar els camps del formulari

                  child: ListView(
                    // Amb shrinkWrap podem centrar el ListView verticalment amb el Center
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: height*0.04
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.asset(
                          "assets/img/healthys_logo_alpha.png",
                        ),
                      ),
                      SizedBox(height: 16),

                      // Si ens passen l'usuari posem el nom
                      if (widget.username != null)
                        Center(child: Text("Hola ${widget.username!}"))
                      else ...[
                        // Si no, afegim els camps formulari
                        // Aquest operador ... (spread) "desempaqueta" la llista i
                        // insereix tots els widgets com si foren elements individuals
                        // de la llista pare.
                        // Això ens resulta útil quan volem afegir a la interfície
                        // més d'un widget de manera declarativa en el else.

                        // Mètodes per crear els diferents elements del formulari
                        createEmailField(),
                        // Correu/nom d'usuari
                        SizedBox(height: 16),
                        createPassField(),
                        // Password
                        SizedBox(height: 16),

                        createSubmitButtons(context),
                      ], // Realment és un row amb dos botons,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Inicialitzem el email
    controladorCorreu.text = "";
    controladorPass.text = "";
    _pass1Ocult = true;
  }

  @override
  void dispose() {
    // Alliberem el controlador quan el giny
    // s'elimine de l'arbre de ginys.
    controladorCorreu.dispose();
    controladorPass.dispose();
    super.dispose();
  }

  TextFormField createEmailField() {
    // Crea el giny de tipus TextFormField
    return TextFormField(
      // Definim el controller
      controller: controladorCorreu,
      // Validacions
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'El correu no pot ser buit';
        }
        // Expressió regular per validar un correu
        final regexCorreu = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

        // Validació del correu amb l'expressió regular
        if (!regexCorreu.hasMatch(value ?? "")) {
          return 'L\'adreça de correu no és vàlida';
        }
        return null;
      },

      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        icon: const Icon(Icons.email),
        labelText: "Adreça de correu",
      ),
    );
  }

  TextFormField createPassField() {
    // Crea el giny de tipus TextFormField
    return TextFormField(
      controller: controladorPass, // Controlador
      validator: (value) {
        // validador
        if (value?.isEmpty ?? true) {
          return 'El password no pot ser buit';
        }
      },

      obscureText: _pass1Ocult,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        icon: const Icon(Icons.password),
        labelText: "Password",
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _pass1Ocult ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              // Actualitzem l'estat
              _pass1Ocult = !_pass1Ocult;
            });
          },
        ),

        // Acaba aci el IconButton
      ),
    );
  }

  // Botonera per accedir al sistema i registrar-se
  Widget createSubmitButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              // Accedim al formulari fent ús de _formKey.
              if (_formKey.currentState?.validate() ?? false) {
                // Invoquem el callback proporcionat al widget
                // proporcionant-li el valor del correu
                widget.callback(controladorCorreu.text);
              }
            },
            child: const Text('Accedeix'),
          ),
          ElevatedButton(
            onPressed: () {
              /*ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Registrat')));*/

              Future<dynamic> respostaFuture = showDialog(
                // Proporcionem el context
                context: context,
                // I la funció (builder) que constueix el diàleg
                builder: (context) {
                  return RegisterForm();
                },
              );
              //
              respostaFuture.then((value) {
                controladorCorreu.text = value["nom"];
                controladorPass.text = value["pass"];
              });
            },
            child: const Text('Registra\'t'),
          ),
        ],
      ),
    );
  }
}
