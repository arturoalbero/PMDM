import 'package:flutter/material.dart';

// Formulari de registre: Widget amb estat
class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  RegisterFormState createState() {
    return RegisterFormState();
  }
}

// Classe estata associat al widget
class RegisterFormState extends State<RegisterForm> {
  // Clau global que usarem per validar el formulari
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController controladorNom = TextEditingController();

  // Definim els controladors per al correu i el telèfon
  final TextEditingController controladorCorreu = TextEditingController();
  final TextEditingController controladorTelefon = TextEditingController();
  final TextEditingController controladorPass = TextEditingController();
  final TextEditingController controladorConfirmPass = TextEditingController();

  // Per controlar visibilització dels passwords
  // utilitzem dues variables privades a l'estat
  late bool _pass1Ocult;
  late bool _pass2Ocult;

  @override
  void initState() {
    super.initState();
    // Inicialitzem el text del controlador
    controladorNom.text = "";

    // Inicialització de la resta de controladors
    controladorCorreu.text = "";
    controladorTelefon.text = "";
    controladorPass.text = "";
    controladorConfirmPass.text = "";

    // Visibilització dels passwords
    _pass1Ocult = true;
    _pass2Ocult = true;
  }

  @override
  void dispose() {
    // Alliberem el controlador quan el giny
    // s'elimine de l'arbre de ginys.
    controladorNom.dispose();

    // Allibera els controladores del correu i el telèfon
    controladorCorreu.dispose();
    controladorTelefon.dispose();
    controladorPass.dispose();
    controladorConfirmPass.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Per evitar superposar la UI amb els controls del sistema
        child: Form(
          // Clau del formulari: la clau _formKey generada
          key: _formKey,
          // ListView per organitzar els camps del formulari
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset("assets/img/healthys_logo_alpha.png"),
              ),
              // Mètodes per crear els diferents elements del formulari
              SizedBox(height: 16),
              createNameField(), // Nom
              SizedBox(height: 16),
              createEmailField(), // Correu
              SizedBox(height: 16),
              createPhoneField(), // Telèfon
              SizedBox(height: 16),
              createPassField(), // Password
              SizedBox(height: 16),
              createConfirmPassField(), // Repetició del password
              SizedBox(height: 16),
              createCheckboxConditionsFormField(),
              createSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  TextFormField createNameField() {
    // Crea el giny de tipus TextFormField
    return TextFormField(
      // Definim el controller
      controller: controladorNom,

      // Amb la propietat validator definim les validacions
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'El nom no pot ser buit';
        }
        return null;
      },

      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        icon: const Icon(Icons.people),
        labelText: "El teu nom",
      ),
    );
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

  TextFormField createPhoneField() {
    // Crea el giny de tipus TextFormField
    return TextFormField(
      controller: controladorTelefon,

      // Validacions
      validator: (value) {
        if (value?.isEmpty ?? true) {
          return 'El telèfon no pot ser buit';
        }

        String textSenseEspais = value!.replaceAll(RegExp(r'\s+'), '');
        if (!RegExp(r'^\d{9}$').hasMatch(textSenseEspais)) {
          return 'El telèfon ha de contenir 9 dígits';
        }
        return null;
      },

      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        icon: const Icon(Icons.phone),
        labelText: "Telèfon",
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
        return null;
      },

      obscureText: _pass1Ocult,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        icon: const Icon(Icons.password),
        labelText: "Password",
        suffixIcon: IconButton(
          icon: Icon(_pass1Ocult ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            // Actualitzem la visiblilitat i l'estat
            setState(() {
              _pass1Ocult = !_pass1Ocult;
            });
          },
        ),

        // Acaba aci el IconButton
      ),
    );
  }

  TextFormField createConfirmPassField() {
    // Crea el giny de tipus TextFormField
    return TextFormField(
      controller: controladorConfirmPass, // Controlador
      validator: (value) {
        // validador
        if (value?.isEmpty ?? true) {
          return 'El password no pot ser buit';
        }

        // Comparem amb el valor del text del controlador anterior
        if (value != controladorPass.text) {
          return "Els passwords no coincideixen";
        }

        return null;
      },

      // Oculta els caràcters del password
      obscureText: _pass2Ocult,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        icon: const Icon(Icons.password),
        labelText: "Repeteix el password",
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            _pass2Ocult ? Icons.visibility : Icons.visibility_off,
            //color: Theme.of(context).primaryColorDark,
          ),
          onPressed: () {
            // Modifiquem la visibilitat del widget i actualitzem l'estat
            setState(() {
              _pass2Ocult = !_pass2Ocult;
            });
          },
        ),

        // Acaba aci el IconButton
      ),
    );
  }

  FormField<bool> createCheckboxConditionsFormField() {
    // Creem un FormField per envoltar el Checkbox
    return FormField(
      // Donem un valor inicial
      initialValue: false,
      // Definim les validacions sobre el valor
      validator: (value) {
        if (!value!) {
          return 'Heu d\'acceptar les condicions de privacitat';
        }
        return null;
      },

      // Constructor del giny. Rebem en field l'estat del FormField.
      builder: (FormFieldState<dynamic> field) {
        return CheckboxListTile(
          // El valor del giny serà el que tinga el FormField
          value: field.value,
          title: const Text("Accepte les condicions de privacitat"),
          // Utilitzem el subtítol per indicar els missatges d'error
          subtitle: Text(
            field.errorText ?? "",
            style: TextStyle(
              fontStyle: FontStyle.normal,
              fontSize: 12,
              color: Colors.red[700],
              height: 0.5,
            ),
          ),
          onChanged: (bool? value) {
            field.didChange(value);
          },
        );
      },
    );
  }

  // Botó per enviar el formulari, prèvia validació
  Widget createSubmitButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          // Accedim al formulari fent ús de _formKey.

          if (_formKey.currentState?.validate() ?? false) {
            Map<String, String> resposta = {
              "nom": controladorCorreu.text,
              "pass": controladorPass.text,
            };
            Navigator.pop(context, resposta);
          }
        },
        child: const Text('Finalitzar'),
      ),
    );
  }
}
