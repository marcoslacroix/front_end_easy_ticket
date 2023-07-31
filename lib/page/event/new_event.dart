import 'package:easy_ticket/page/event/event_address.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../util/util_data.dart';

class NewEvent extends StatefulWidget {
  const NewEvent({Key? key}) : super(key: key);

  @override
  State<NewEvent> createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _periodController;
  late TextEditingController _startController;
  late TextEditingController _descriptionController;

  final _nameFocus = FocusNode();
  final _periodFocus = FocusNode();
  final _startFocus = FocusNode();
  final _descriptionFocus = FocusNode();

  @override
  void initState() {
    _nameController = TextEditingController();
    _periodController = TextEditingController();
    _startController = TextEditingController();
    _descriptionController = TextEditingController();
    super.initState();
  }

  var maskFormatterPeriod = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy
  );

  var maskFormatterStart = MaskTextInputFormatter(
      mask: '##:##',
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Novo evento")),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nome"),
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.text,
                focusNode: _nameFocus,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nome obrigatório.";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _periodController,
                decoration: const InputDecoration(labelText: "Período dd/mm/yyyy"),
                textInputAction: TextInputAction.next,
                inputFormatters: [DateInputFormatter(), maskFormatterPeriod],
                keyboardType: TextInputType.number,
                focusNode: _periodFocus,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Período obrigatório.";
                  }
                  if (value.length < 10) {
                    return "Período inválido";
                  }
                  String year = value.substring(6, 10);
                  int? yearInt = int.tryParse(year);
                  int currentYear = DateTime.now().year;
                  if (yearInt! < currentYear) {
                    return "O ano esta incorreto";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _startController,
                decoration: const InputDecoration(labelText: "Horário de início"),
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.sentences,
                inputFormatters: [maskFormatterStart],
                keyboardType: TextInputType.number,
                focusNode: _startFocus,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Horário de início obrigatório.";
                  }
                  if (value.length < 5) {
                    return "Horário inválido";
                  }
                  String hour = value.substring(0,2);
                  int? hourInt = int.tryParse(hour);
                  if (hourInt! > 23) {
                    return "Hora inválida";
                  }

                  String minutes = value.substring(3, 5);
                  int? minutesInt = int.tryParse(minutes);
                  if (minutesInt! > 59) {
                    return "Minutos inválido";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Descrição"),
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.text,
                focusNode: _descriptionFocus,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Descrição  obrigatório.";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => EventAddress(
              event: createEventObject(),
            )));
          }
        },
        child: const Icon(Icons.arrow_right_alt_outlined),
      )
    );
  }

  dynamic createEventObject() {
    return {
      "name": _nameController.text,
      "period": _periodController.text,
      "start": _startController.text,
      "description": _descriptionController.text
    };
  }
}
