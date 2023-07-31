import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../util/util_routes.dart';
import 'checking.dart';

class CheckingManual extends StatefulWidget {
  const CheckingManual({Key? key}) : super(key: key);

  @override
  State<CheckingManual> createState() => _CheckingManualState();
}

class _CheckingManualState extends State<CheckingManual> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _uuidController;
  final _uuidFocus = FocusNode();

  var maskFormatter = MaskTextInputFormatter(
      mask: '########-####-####-####-############',
      filter: { "#": RegExp(r'^[0-9a-z]+$')},
      type: MaskAutoCompletionType.lazy
  );

  @override
  void initState() {
    super.initState();
    _uuidController = TextEditingController();
  }

  @override
  void dispose() {
    _uuidController.dispose();
    super.dispose();
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
            decoration: const InputDecoration(labelText: "Digite o código"),
            controller: _uuidController,
            maxLength: 36,
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
                      moveToChecking(context, _uuidController.text);
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