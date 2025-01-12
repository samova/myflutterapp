import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mymoney/models/appnotifier.dart';
import 'package:mymoney/models/category.dart';
import 'package:mymoney/models/enums.dart';
import 'package:mymoney/models/record.dart';
import 'package:provider/provider.dart';

class InputDialog extends StatefulWidget {
  final CardMode cardMode;
  final Map? mapData;
  const InputDialog({super.key, required this.cardMode, this.mapData});

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  final TextEditingController cateController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  String selectedValue = '';

  @override
  void initState() {
    super.initState();
    final appNotifier = context.read<AppNotifier>();
    if (widget.mapData == null) {
      if (widget.cardMode == CardMode.record && appNotifier.categories.isNotEmpty) {
        selectedValue = appNotifier.categories.first.category;
      } else if (widget.cardMode != CardMode.record && appNotifier.emojiicons.isNotEmpty) {
        selectedValue = appNotifier.emojiicons.first.icon;
      }
    } else {
      if (widget.cardMode == CardMode.record) {
        selectedValue = widget.mapData!['category'];
        cateController.text = widget.mapData?['note'];
        numberController.text = widget.mapData?['amount'];
      } else {
        selectedValue = widget.mapData!['icon'];
        cateController.text = widget.mapData?['category'];
        numberController.text = widget.mapData?['budget'];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appNotifier = context.read<AppNotifier>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButton<String>(
          alignment: Alignment.center,
          isExpanded: true,
          value: selectedValue,
          items: myDropItems(widget.cardMode, appNotifier),
          onChanged: (String? newValue) {
            setState(() {
              selectedValue = newValue!;
            });
          },
        ),
        SizedBox(height: 20),
        TextField(
          controller: cateController,
          decoration: InputDecoration(
            hintText: widget.cardMode == CardMode.record ? 'Enter note' : 'Enter category',
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9\s\p{Emoji_Presentation}]*$')),
          ],
        ),
        SizedBox(height: 20),
        if (widget.cardMode != CardMode.income)
          TextField(
            controller: numberController,
            decoration: InputDecoration(
              hintText: widget.cardMode == CardMode.record ? 'Enter amount' : 'Enter budget',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        SizedBox(height: 20),
        TextButton(
          child: Text('OK'),
          onPressed: () {
            if (cateController.text.trim().isEmpty || (widget.cardMode != CardMode.income && numberController.text.trim().isEmpty)) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please fill all fields')),
              );
            } else {
              switch (widget.cardMode) {
                case CardMode.income:
                  appNotifier.addCategory(Category(
                    catetype: CategoryType.income.name,
                    category: cateController.text,
                    budget: 0,
                    icon: selectedValue,
                  ));
                  break;
                case CardMode.expenses:
                  appNotifier.addCategory(Category(
                    catetype: CategoryType.expenses.name,
                    category: cateController.text,
                    budget: int.parse(numberController.text),
                    icon: selectedValue,
                  ));
                  break;
                case CardMode.record:
                  appNotifier.addRecord(RecordData(
                    catetype: CategoryType.expenses.name,
                    category: selectedValue,
                    amount: int.parse(numberController.text),
                    date: DateTime.now().toIso8601String(),
                    note: cateController.text,
                  ));
                  break;
              }
              cateController.clear();
              numberController.clear();
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}

List<DropdownMenuItem<String>> myDropItems(CardMode cardMode, AppNotifier appNotifier) {
  switch (cardMode) {
    case CardMode.record:
      return appNotifier.categories.map((Category item) {
        return DropdownMenuItem(
          value: item.category,
          child: Text('${item.icon} ${item.category}', style: TextStyle(fontSize: 24)),
        );
      }).toList();
    default:
      return appNotifier.emojiicons.map((icon) {
        return DropdownMenuItem(
          value: icon.icon,
          child: Text(icon.icon, style: TextStyle(fontSize: 24)),
        );
      }).toList();
  }
}