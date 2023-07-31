import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/token_manager.dart';
import '../../util/urls.dart';
import '../../util/util_dialog.dart';
import '../../util/util_routes.dart';

class EventAddress extends StatefulWidget {
  final dynamic event;

  EventAddress({
    required this.event,
    Key? key
  }) : super(key: key);

  @override
  State<EventAddress> createState() => _EventAddressState();
}

class _EventAddressState extends State<EventAddress> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _streetController;
  late TextEditingController _numberController;
  late TextEditingController _postalCodeController;
  late TextEditingController _neighborhoodController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late String _selectedAcronymState;
  late SharedPreferences prefs;
  late String token;


  final _nameFocus = FocusNode();
  final _streetFocus = FocusNode();
  final _numberFocus = FocusNode();
  final _postalCodeFocus = FocusNode();
  final _neighborhoodFocus = FocusNode();
  final _cityFocus = FocusNode();
  final _stateFocus = FocusNode();

  late bool _isButtonDisabled;

  @override
  void initState() {
    super.initState();
    _selectedAcronymState = _statesList[0];
    _isButtonDisabled = false;
    _nameController = TextEditingController();
    _streetController = TextEditingController();
    _numberController = TextEditingController();
    _postalCodeController = TextEditingController();
    _neighborhoodController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    token = TokenManager.instance.getToken();

    loadPreferences();
  }

  void loadPreferences() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    setState(() {
      prefs = p;
      if (prefs.getString("name_street") != null && prefs.getString("name_street")!.isNotEmpty) {
        _nameController.text = prefs.getString("name_street").toString();
      }
      if (prefs.getString("event_street") != null && prefs.getString("event_street")!.isNotEmpty) {
        _streetController.text = prefs.getString("event_street").toString();
      }
      if (prefs.getString("event_number") != null && prefs.getString("event_number")!.isNotEmpty) {
        _numberController.text = prefs.getString("event_number").toString();
      }
      if (prefs.getString("event_postal_code") != null && prefs.getString("event_postal_code")!.isNotEmpty) {
        _postalCodeController.text = prefs.getString("event_postal_code").toString();
      }
      if (prefs.getString("event_neighborhood") != null && prefs.getString("event_neighborhood")!.isNotEmpty) {
        _neighborhoodController.text = prefs.getString("event_neighborhood").toString();
      }
      if (prefs.getString("event_city") != null && prefs.getString("event_city")!.isNotEmpty) {
        _cityController.text = prefs.getString("event_city").toString();
      }
      if (prefs.getString("event_state") != null && prefs.getString("event_state")!.isNotEmpty) {
        _stateController.text = prefs.getString("event_state").toString();
      }
      if (prefs.getString("event_acronym") != null && prefs.getString("event_acronym")!.isNotEmpty) {
        _selectedAcronymState = prefs.getString("event_acronym").toString();
      }
    });
  }

  var maskFormatterCep = MaskTextInputFormatter(
      mask: '#####-###',
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy
  );

  final List<String> _statesList = [
    'Selecione o estado', 'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG',
    'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'
  ];

  final Map<String, String> _stateNameMap = {
    'AC': 'Acre',
    'AL': 'Alagoas',
    'AP': 'Amapá',
    'AM': 'Amazonas',
    'BA': 'Bahia',
    'CE': 'Ceará',
    'DF': 'Distrito Federal',
    'ES': 'Espírito Santo',
    'GO': 'Goiás',
    'MA': 'Maranhão',
    'MT': 'Mato Grosso',
    'MS': 'Mato Grosso do Sul',
    'MG': 'Minas Gerais',
    'PA': 'Pará',
    'PB': 'Paraíba',
    'PR': 'Paraná',
    'PE': 'Pernambuco',
    'PI': 'Piauí',
    'RJ': 'Rio de Janeiro',
    'RN': 'Rio Grande do Norte',
    'RS': 'Rio Grande do Sul',
    'RO': 'Rondônia',
    'RR': 'Roraima',
    'SC': 'Santa Catarina',
    'SP': 'São Paulo',
    'SE': 'Sergipe',
    'TO': 'Tocantins',
  };



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Endereço")),
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
                      return "Campo obrigatório.";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _streetController,
                  decoration: const InputDecoration(labelText: "Rua"),
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.text,
                  focusNode: _streetFocus,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo obrigatório.";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _numberController,
                  decoration: const InputDecoration(labelText: "Número"),
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.number,
                  focusNode: _numberFocus,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo obrigatório.";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _postalCodeController,
                  decoration: const InputDecoration(labelText: "CEP"),
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  inputFormatters: [maskFormatterCep],
                  keyboardType: TextInputType.number,
                  focusNode: _postalCodeFocus,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo obrigatório.";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _neighborhoodController,
                  decoration: const InputDecoration(labelText: "Bairro"),
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.text,
                  focusNode: _neighborhoodFocus,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo obrigatório.";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: "Cidade"),
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.text,
                  focusNode: _cityFocus,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo obrigatório.";
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedAcronymState,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedAcronymState = newValue!;
                      _stateController.text = _stateNameMap[newValue] ?? ''; // Use the full state name for the TextFormField.
                    });
                  },
                  items: _statesList.map((state) {
                    return DropdownMenuItem<String>(
                      value: state, // Make sure each state has a unique value.
                      child: Text(state),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Estado',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty || value == "Selecione o estado") {
                      return 'Campo obrigatório.';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _stateController,
                  decoration: const InputDecoration(labelText: "Estado"),
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.sentences,
                  readOnly: true,
                  keyboardType: TextInputType.text,
                  focusNode: _stateFocus,
                ),
              ],
            ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _isButtonDisabled ? null : _saveEvent(),
        child:
        _isButtonDisabled ? const SizedBox( // Show loading indicator when _isButtonDisabled is true
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ) :
        const Icon(Icons.save),
      )
    );
  }

  void _saveEvent() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isButtonDisabled = true;
      });

      prefs.setString("name_street", _nameController.text);
      prefs.setString("event_street", _streetController.text);
      prefs.setString("event_number", _numberController.text);
      prefs.setString("event_postal_code", _postalCodeController.text);
      prefs.setString("event_neighborhood", _neighborhoodController.text);
      prefs.setString("event_city", _cityController.text);
      prefs.setString("event_state", _stateController.text);
      prefs.setString("event_acronym", _selectedAcronymState);

      await requestCreateEvent(context);
      setState(() {
        _isButtonDisabled = false;
      });
    }
  }

  dynamic getBodyEvent() {
    String periodString = widget.event['period']; // Assuming eventData['period'] is a string in the format "dd/MM/yyyy"
    DateTime periodDate = DateFormat('dd/MM/yyyy').parse(periodString);
    String formattedPeriod = DateFormat('yyyy-MM-dd').format(periodDate);
    return {
      "event": {
        "name": widget.event['name'],
        "period": formattedPeriod,
        "start": widget.event['start'],
        "description": widget.event['description'],
        "address": {
          "name": _nameController.text,
          "street": _streetController.text,
          "number": _numberController.text,
          "postalCode": _postalCodeController.text,
          "neighborhood": _neighborhoodController.text,
          "city": _cityController.text,
          "state": _stateController.text,
          "acronymState": _selectedAcronymState
        }
      }
    };
  }

  Future<void> requestCreateEvent(context) async {
    try {
      var body = getBodyEvent();
      String jsonPayload = jsonEncode(body);

      final url = Uri.parse(createEventUrl);
      var response = await http.post(
        url,
        body: jsonPayload,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: token,
        },
      );

      if (response.statusCode == 201) {
        moveToSuccessCreatedEvent(context);
      } else if (response.statusCode == 400) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        showErrorDialog(context, jsonData['error'], "Error");
      }
    } catch(e) {
      print('Error occurred while create event: $e');
    }
  }

}
