import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: Aplicativo()));

class Aplicativo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Formulário')),
      body: Formulario(),
    );
  }
}

class Formulario extends StatefulWidget {
  @override
  FormularioState createState() => FormularioState();
}

class FormularioState extends State<Formulario> {
/* Chave global que identifica o formulário e permite a validação.
* OBS: devemos usar GlobalKey<FormState>,
* não devemos usar GlobalKey<FormularioState>.
*/
  final chaveFormulario = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController mensagemlController = TextEditingController();
  late FocusNode meuFoco1, meuFoco2, meuFoco3;
  int contador = 0;
//Método de iniciação:
  @override
  void initState() {
    super.initState();
    this.meuFoco1 = FocusNode();
    this.meuFoco2 = FocusNode();
    this.meuFoco3 = FocusNode();
  }

//Método de finalização:
  @override
  void dispose() {
    this.meuFoco1.dispose();
    this.meuFoco2.dispose();
    this.meuFoco3.dispose();
    this.emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      child: Form(
        key: this.chaveFormulario,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CampoTexto(
              nome: 'e-mail',
              textoController: this.emailController,
              foco: this.meuFoco1,
              autoFoco: true,
            ),
            CampoTexto(
              nome: 'senha',
              textoController: this.senhaController,
              foco: this.meuFoco2,
              autoFoco: true,
            ),
            ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text('Próximo'),
                  focusNode: this.meuFoco2,
                  onPressed: () {
                    this.contador = (++this.contador % 3);
                    switch (this.contador) {
                      case 0:
                        meuFoco1.requestFocus();
                        break;
                      case 1:
                        meuFoco2.requestFocus();
                        break;
                      case 2:
                        meuFoco3.requestFocus();
                        break;
                      default:
                        meuFoco1.requestFocus();
                    }
                  },
                ),
                TextButton(
                  child: Text('Enviar'),
                  focusNode: this.meuFoco3,
                  onPressed: () {
                    if (this.chaveFormulario.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Enviando os dados...'),
                          duration: Duration(milliseconds: 987),
                        ),
                      );
                      this.emailController.clear();
                      meuFoco1.requestFocus();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CampoTexto extends StatelessWidget {
  final String nome;
  final TextEditingController textoController;
  final FocusNode foco;
  final bool autoFoco;
  CampoTexto({
    required this.nome,
    required this.textoController,
    required this.foco,
    required this.autoFoco,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.textoController,
      autofocus: this.autoFoco,
      focusNode: this.foco,
      validator: (valor) {
        if (valor == null || valor.isEmpty || !valor.contains('@')) {
          return '${this.nome} não informado.';
        }
        return null;
      },
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () => this.textoController.clear(),
          icon: Icon(Icons.clear),
        ),
        border: OutlineInputBorder(),
        labelText: this.nome,
      ),
    );
  }
}
