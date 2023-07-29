import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'checking.dart';

class CheckingManual extends StatefulWidget {
  const CheckingManual({Key? key}) : super(key: key);

  @override
  State<CheckingManual> createState() => _CheckingManualState();
}

class _CheckingManualState extends State<CheckingManual> {
  late final _formKey;
  late final TextEditingController _uuidController;
  late final _uuidFocus;

  var maskFormatter = MaskTextInputFormatter(
      mask: '########-####-####-####-############',
      filter: { "#": RegExp('.') },
      type: MaskAutoCompletionType.lazy
  );

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    super.initState();
    _uuidController = TextEditingController();
    _uuidFocus = FocusNode();
  }

  @override
  Widget build(BuildContext context) {

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
              color: Colors.black), // Definir a cor do ícone de voltar
        ),
        body: Center(
          child: SizedBox(
            width: 350,
            child: TextFormField(
            maxLength: 36,
            decoration: const InputDecoration(labelText: "Digite o código"),
            controller: _uuidController,
            focusNode: _uuidFocus,
            inputFormatters: [maskFormatter], // Adicione o maskFormatter aqui
            textInputAction: TextInputAction.next,
            validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Código obrigatório";
                }
                if (value.length < 36) {
                  return "Código inválido";
                }
            },
          ),
          )),
          bottomNavigationBar: BottomAppBar(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_right_alt_outlined),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (contex) => Checking(ticketUuid: _uuidController.text)
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          )

      ),
    );
  }
}
