import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mammba/common/widgets/input-dropdown.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';

class CountryPickerDropdowns extends StatelessWidget {
  const CountryPickerDropdowns({
    Key key,
    this.labelText,
    this.selectCountry,
    this.selectedCountry,
    this.isCountryCode,
    this.isShowFlag
  }) : super(key: key);

  final String labelText;
  final bool isCountryCode;
  final bool isShowFlag;
  final ValueChanged<Country> selectCountry;
  final Country selectedCountry;

  void _openCountryPickerDialog(context) => showDialog(
    context: context,
    builder: (context) => Theme(
        data: Theme.of(context).copyWith(primaryColor: Colors.pink),
        child: CountryPickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            title: Text('Select country'),
            onValuePicked: (Country country) => 
              selectCountry(country),
            itemBuilder: _buildDialogItem)),
  );

  Widget _buildDialogItem(Country country) => Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(width: 8.0),
        Flexible(child: Text(country.name)),
      ],
  );

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: InputDropdown(
            labelText: labelText,
            valueText: isCountryCode ? selectedCountry.phoneCode : selectedCountry.name,
            valueStyle: valueStyle,
            onPressed: () { _openCountryPickerDialog(context); },
          ),
        ),
        const SizedBox(width: 12.0),
      ],
    );
  }
}