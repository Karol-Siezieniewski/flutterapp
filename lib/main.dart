import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bill Splitter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BillSplitterScreen(),
    );
  }
}

class BillSplitterScreen extends StatefulWidget {
  @override
  _BillSplitterScreenState createState() => _BillSplitterScreenState();
}

class _BillSplitterScreenState extends State<BillSplitterScreen> {
  double billAmount = 0.0;
  int numOfPeople = 1;
  double tipPercentage = 0.0;

  Color getSliderColor(double percentage) {
    final red = 255 * (1 - percentage);
    final green = 255 * percentage;
    return Color.fromRGBO(red.toInt(), green.toInt(), 0, 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill Splitter'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Bill Amount'),
                onChanged: (value) {
                  setState(() {
                    billAmount = double.parse(value);
                  });
                },
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('People: $numOfPeople'),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            numOfPeople = (numOfPeople - 1).clamp(0, 99);
                          });
                        },
                        child: Text('-'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            numOfPeople = (numOfPeople + 1).clamp(0, 99);
                          });
                        },
                        child: Text('+'),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text('Tip Percentage: ${tipPercentage.toInt()}%'),
              Slider(
                value: tipPercentage,
                min: 0,
                max: 100,
                divisions: 20,
                onChanged: (value) {
                  setState(() {
                    tipPercentage = value;
                  });
                },
                activeColor: getSliderColor(tipPercentage / 100),
                inactiveColor: getSliderColor(tipPercentage / 100).withOpacity(0.5),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (numOfPeople > 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultScreen(
                          totalAmount: calculateTotalAmount(),
                          numOfPeople: numOfPeople,
                        ),
                      ),
                    );
                  } else {
                    _showWarningDialog(context);
                  }
                },
                child: Text('Sum it up!'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double calculateTotalAmount() {
    double tipAmount = billAmount * (tipPercentage / 100);
    return (billAmount + tipAmount) / numOfPeople;
  }

  Future<void> _showWarningDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning'),
          content: Text('The number of people should be greater than 0.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class ResultScreen extends StatelessWidget {
  final double totalAmount;
  final int numOfPeople;

  ResultScreen({required this.totalAmount, required this.numOfPeople});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Each person should pay \$${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back to Input'),
            ),
          ],
        ),
      ),
    );
  }
}
