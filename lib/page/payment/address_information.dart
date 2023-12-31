import 'package:easy_ticket/page/payment/credit_card.dart';
import 'package:easy_ticket/page/payment/total_tickets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressInformation extends StatefulWidget {
  final dynamic tickets;
  final double totalTicketValue;
  final int totalTicketCount;
  final dynamic customer;

  const AddressInformation({
    required this.tickets,
    required this.totalTicketValue,
    required this.totalTicketCount,
    required this.customer,
    Key? key
  }) : super(key: key);

  @override
  State<AddressInformation> createState() => _AddressInformationState();
}

class _AddressInformationState extends State<AddressInformation> {
  late final _formKey;
  late dynamic customer;
  late dynamic tickets;
  late SharedPreferences prefs;

  late TextEditingController _streetController;
  late TextEditingController _streetNumberController;
  late TextEditingController _neighborhoodController;
  late TextEditingController _zipcodeController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  final _streetFocus = FocusNode();
  final _streetNumberFocus = FocusNode();
  final _neighborhoodFocus = FocusNode();
  final _zipcodeFocus = FocusNode();
  final _cityFocus = FocusNode();
  late String _selectedState;

  late final double totalTicketValue;
  late final int totalTicketCount;

  late final List<String> _statesList;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    customer = widget.customer;
    tickets = widget.tickets;

    _streetController = TextEditingController();
    _streetNumberController = TextEditingController();
    _neighborhoodController = TextEditingController();
    _zipcodeController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();

    totalTicketValue = widget.totalTicketValue;
    totalTicketCount = widget.totalTicketCount;
    _statesList = [
      'Selecione o estado', 'AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG',
      'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO'
    ];
    _selectedState = _statesList[0];
    loadPreferences();
    
    super.initState();
  }

  void loadPreferences() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    setState(() {
      prefs = p;
      if (prefs.getString("address_information_street") != null && prefs.getString("address_information_street")!.isNotEmpty) {
        _streetController.text = prefs.getString("address_information_street").toString();
      }
      if (prefs.getString("address_information_street_number") != null && prefs.getString("address_information_street_number")!.isNotEmpty) {
        _streetNumberController.text = prefs.getString("address_information_street_number").toString();
      }
      if (prefs.getString("address_information_neighborhood") != null && prefs.getString("address_information_neighborhood")!.isNotEmpty) {
        _neighborhoodController.text = prefs.getString("address_information_neighborhood").toString();
      }
      if (prefs.getString("address_information_zipcode") != null && prefs.getString("address_information_zipcode")!.isNotEmpty) {
        _zipcodeController.text = prefs.getString("address_information_zipcode").toString();
      }
      if (prefs.getString("address_information_city") != null && prefs.getString("address_information_city")!.isNotEmpty) {
        _cityController.text = prefs.getString("address_information_city").toString();
      }
      if (prefs.getString("address_information_state") != null && prefs.getString("address_information_state")!.isNotEmpty) {
        _selectedState = prefs.getString("address_information_state").toString();
      }
      
    });
  }

  var maskFormatterCep = MaskTextInputFormatter(
      mask: '#####-###',
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy
  );

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            title: const Center(child: Text("Endereço")),
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 0
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: ListTile(
                  title: const Center(child: Text("Endereço")),
                  subtitle: Column(
                    children: [
                      TextFormField(
                        controller: _streetController,
                        decoration: const InputDecoration(labelText: "Rua"),
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.text,
                        focusNode: _streetFocus,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Rua obrigatório.";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _streetNumberController,
                        decoration: const InputDecoration(labelText: "Número"),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _streetNumberFocus,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Número do endereço é obrigatório.";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _neighborhoodController,
                        decoration: const InputDecoration(labelText: "Bairro"),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        focusNode: _neighborhoodFocus,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Bairro obrigatório.";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _zipcodeController,
                        decoration: const InputDecoration(labelText: "CEP"),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [maskFormatterCep],
                        focusNode: _zipcodeFocus,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "CEP obrigatório";
                          }
                          if (value.length < 8) {
                            return "CEP inválido";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _cityController,
                        decoration: const InputDecoration(labelText: "Cidade"),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.sentences,
                        focusNode: _cityFocus,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Cidade obrigatório";
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField<String>(
                        value: _selectedState,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedState = newValue!;
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
                            return 'Estado obrigatório.';
                          }
                          print("value: $value");
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              TotalTickets(totalTicketValue: totalTicketValue, totalTicketCount: totalTicketCount),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (contex) => CreditCard(
                        totalTicketValue: totalTicketValue,
                        totalTicketCount: totalTicketCount,
                        tickets: tickets,
                        customer: customer,
                        address: generateAddressObject()
                    )
                ),
              );
            }
          },
          child: const Icon(Icons.arrow_right_alt_outlined),
        ),

      ),
    );
  }

  dynamic generateAddressObject() {
    prefs.setString("address_information_street", _streetController.text);
    prefs.setString("address_information_street_number", _streetNumberController.text);
    prefs.setString("address_information_neighborhood", _neighborhoodController.text);
    prefs.setString("address_information_zipcode", _zipcodeController.text);
    prefs.setString("address_information_city", _cityController.text);
    prefs.setString("address_information_state", _selectedState);

    var params = {
      "street": _streetController.text,
      "number": _streetNumberController.text,
      "neighborhood": _neighborhoodController.text,
      "zipcode": _zipcodeController.text,
      "city": _cityController.text,
      "state": _selectedState
    };
    return params;
  }

}
