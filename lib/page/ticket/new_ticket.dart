import 'package:easy_ticket/page/ticket/ticket_information.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../util/util_data.dart';

class NewTicket extends StatefulWidget {
  final dynamic event;

  const NewTicket({
    required this.event,
    Key? key
  }) : super(key: key);

  @override
  State<NewTicket> createState() => _NewTicketState();
}

class _NewTicketState extends State<NewTicket> {

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _startSalesController;
  late TextEditingController _endSalesController;

  final _descriptionFocus = FocusNode();
  final _startSalesFocus = FocusNode();
  final _endSalesFocus = FocusNode();

  @override
  void initState() {
    _descriptionController = TextEditingController();
    _startSalesController = TextEditingController();
    _endSalesController = TextEditingController();
    super.initState();
  }

  var maskFormatterPeriod = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy
  );

  @override
  Widget build(BuildContext context) {
    print(widget.event);
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Novo lote de ingressos")),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: "Nome", border: OutlineInputBorder()),
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.text,
                  focusNode: _descriptionFocus,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Nome obrigatório.";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _startSalesController,
                  decoration: const InputDecoration(labelText: "Data início das vendas dd/mm/yyyy", border: OutlineInputBorder()),
                  textInputAction: TextInputAction.next,
                  inputFormatters: [DateInputFormatter(), maskFormatterPeriod],
                  keyboardType: TextInputType.number,
                  focusNode: _startSalesFocus,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo obrigatório.";
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
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _endSalesController,
                  decoration: const InputDecoration(labelText: "Data fim das vendas dd/mm/yyyy", border: OutlineInputBorder()),
                  textInputAction: TextInputAction.next,
                  inputFormatters: [DateInputFormatter(), maskFormatterPeriod],
                  keyboardType: TextInputType.number,
                  focusNode: _endSalesFocus,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo obrigatório.";
                    }
                    print("value $value");
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
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => TicketInformation(
              lot: createTicketObject(),
              event: widget.event
            )));
          }
        },
        child: const Icon(Icons.arrow_right_alt_outlined),
      )
    );
  }

  dynamic createTicketObject() {
    return {
      "description": _descriptionController.text,
      "startSales": _startSalesController.text,
      "endSales": _endSalesController.text
    };
  }
}
