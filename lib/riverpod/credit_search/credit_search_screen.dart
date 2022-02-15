import 'package:flutter/material.dart';

import '../bank_search/bank_search_result_screen.dart';

import 'credit_search_result_screen.dart';

import '../../utilities/utility.dart';
import '../../utilities/CustomShapeClipper.dart';

class CreditSearchScreen extends StatelessWidget {
  const CreditSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Utility _utility = Utility();
    Map _bankName = _utility.getBankName();

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Bank & Credit'),
        centerTitle: true,

        //-------------------------//これを消すと「←」が出てくる（消さない）
        leading: const Icon(
          Icons.check_box_outline_blank,
          color: Color(0xFF2e2e2e),
        ),
        //-------------------------//これを消すと「←」が出てくる（消さない）

        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
            color: Colors.greenAccent,
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          _utility.getBackGround(),
          ClipPath(
            clipper: CustomShapeClipper(),
            child: Container(
              height: size.height * 0.7,
              width: size.width * 0.7,
              margin: const EdgeInsets.only(top: 5, left: 6),
              color: Colors.yellowAccent.withOpacity(0.2),
              child: Text(
                '■',
                style: TextStyle(color: Colors.white.withOpacity(0.1)),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Table(
                children: [
                  TableRow(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pinkAccent.withOpacity(0.3),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const BankSearchResultScreen(
                                ginkou: 'bank_a',
                              ),
                            ),
                          );
                        },
                        child: Text(_bankName['bank_a']),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pinkAccent.withOpacity(0.3),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const BankSearchResultScreen(
                                ginkou: 'bank_b',
                              ),
                            ),
                          );
                        },
                        child: Text(_bankName['bank_b']),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pinkAccent.withOpacity(0.3),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const BankSearchResultScreen(
                                ginkou: 'bank_c',
                              ),
                            ),
                          );
                        },
                        child: Text(_bankName['bank_c']),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pinkAccent.withOpacity(0.3),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const BankSearchResultScreen(
                                ginkou: 'bank_d',
                              ),
                            ),
                          );
                        },
                        child: Text(_bankName['bank_d']),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pinkAccent.withOpacity(0.3),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const BankSearchResultScreen(
                                ginkou: 'bank_e',
                              ),
                            ),
                          );
                        },
                        child: Text(_bankName['bank_e']),
                      ),
                      Container(),
                    ],
                  ),
                ],
              ),
              const Divider(
                color: Colors.white,
                thickness: 2,
              ),
              Table(
                children: [
                  TableRow(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pinkAccent.withOpacity(0.3),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const BankSearchResultScreen(
                                ginkou: 'pay_a',
                              ),
                            ),
                          );
                        },
                        child: Text(_bankName['pay_a']),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pinkAccent.withOpacity(0.3),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const BankSearchResultScreen(
                                ginkou: 'pay_b',
                              ),
                            ),
                          );
                        },
                        child: Text(_bankName['pay_b']),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pinkAccent.withOpacity(0.3),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const BankSearchResultScreen(
                                ginkou: 'pay_c',
                              ),
                            ),
                          );
                        },
                        child: Text(_bankName['pay_c']),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pinkAccent.withOpacity(0.3),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const BankSearchResultScreen(
                                ginkou: 'pay_d',
                              ),
                            ),
                          );
                        },
                        child: Text(_bankName['pay_d']),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pinkAccent.withOpacity(0.3),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const BankSearchResultScreen(
                                ginkou: 'pay_e',
                              ),
                            ),
                          );
                        },
                        child: Text(_bankName['pay_e']),
                      ),
                      Container(),
                    ],
                  ),
                ],
              ),
              const Divider(
                color: Colors.white,
                thickness: 2,
              ),
              Table(
                children: [
                  TableRow(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pinkAccent.withOpacity(0.3),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CreditSearchResultScreen(
                                company: 'uc',
                              ),
                            ),
                          );
                        },
                        child: const Text('UC'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pinkAccent.withOpacity(0.3),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CreditSearchResultScreen(
                                company: 'rakuten',
                              ),
                            ),
                          );
                        },
                        child: const Text('Rakuten'),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pinkAccent.withOpacity(0.3),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CreditSearchResultScreen(
                                company: 'sumitomo',
                              ),
                            ),
                          );
                        },
                        child: const Text('Sumitomo'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pinkAccent.withOpacity(0.3),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CreditSearchResultScreen(
                                company: 'amex',
                              ),
                            ),
                          );
                        },
                        child: const Text('Amex'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
