import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'dart:math' as Math;

class QuadraticCalc extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new QuadraticCalcState();
  }
}

class QuadraticCalcState extends State<QuadraticCalc>{
  //Declare all variables needed by UI here
  final TextEditingController aVal = new TextEditingController();
  final TextEditingController bVal = new TextEditingController();
  final TextEditingController cVal = new TextEditingController();
  String factorization = "";
  String answer = "";
  String denominator = "";
  String underscores = "";
  String factorUnder = "";
  String factorDenom = "";

//Our main calculation method, which will calculate the answers and set the strings to their respective values in the UI
  void _calculate() {
    setState(() {
      //Make sure no textfields are empty to prevent errors further on
      if (aVal.text.isNotEmpty &&
          bVal.text.isNotEmpty &&
          cVal.text.isNotEmpty) {
        //Parse the three values entered by the user into the 'Decimal' class (made for precision calculations)
        Decimal a = Decimal.parse("${aVal.text}");
        Decimal b = Decimal.parse("${bVal.text}");
        Decimal c = Decimal.parse("${cVal.text}");
        //Calculate the main values of the quadratic formula
        Decimal negB = b * Decimal.parse("-1");
        Decimal ac = a * c;
        Decimal finalAc = ac * Decimal.parse("4");
        Decimal bSquared = b * b;
        Decimal divisionVal = a * Decimal.parse("2");
        Decimal sqrtNum = bSquared - finalAc;
        //Declare other values needed in order to format input and make sure all is calculated/simplified correctly (currently uninitialized but will be further on
        Decimal sqrtPos, sqrtNeg;
        String posFactor, negFactor, posAnswer, negAnswer;
        //Set all under strings to empty so there are no unncessary fractions
        resetUnder();
        //Check whether we will be working with imaginary numbers or not (radicand is positive or negative)
        if (sqrtNum >= Decimal.parse("0")) {
          double sqrt = Math.sqrt(double.parse("$sqrtNum"));
          //Check if the square root came to be a whole number
          if (sqrt % 1 == 0) {
            //Check if it was greater than 0 so we know if we will have 2 or one answer (necessary so we do not show 2 answers on the UI
            if (sqrt > 0) {
              //Get the two answers that a quadratic can be
              sqrtPos = negB + Decimal.parse("$sqrt");
              sqrtNeg = negB - Decimal.parse("$sqrt");
              //Get the simplified answer using a self-made method
              posAnswer = simplifyAnswer(sqrtPos, divisionVal, "", false);
              negAnswer = simplifyAnswer(sqrtNeg, divisionVal, "", false);
              //Make it into a single answer variable
              answer = "$posAnswer, $negAnswer";
              //Get the factored form using a self-made method
              posFactor = produceFactor(sqrtPos, divisionVal, false);
              negFactor = produceFactor(sqrtNeg, divisionVal, false);
              factorization = "$posFactor$negFactor";
            } else if (sqrt == 0) {
              //For single-answer equations we can use the same base factorization methods and produce just a single answer and a (x+a)^2 factorization
              answer = simplifyAnswer(negB, divisionVal, "", false);
              factorization = "${produceFactor(negB, divisionVal, false)}\u00B2";
            }
          } else {
            //Since these are non-perfect answers we need to manipulate them a bit to make them look nice and presentable, as well as to show the answer/factorization
            String simplify = sqrtSimplify(sqrtNum);
            //Call the non-perfect factoring method and answer gen method
            factorization = sqrtFactor(negB, divisionVal, simplify, false);
            answer = simplifyAnswer(negB, divisionVal, simplify, false);
          }
        } else {
          //Get the positive square root number for simplification purposes
          Decimal newNum = sqrtNum * Decimal.parse("-1");
          String simplify = sqrtSimplify(newNum);
          //Check whether the number is still a radical without i
          if (simplify.contains("√")) {
            //If so, factorize as a normal radical with imaginary to true (appends i to result as needed)
            factorization = sqrtFactor(negB, divisionVal, simplify, true);
            answer = simplifyAnswer(negB, divisionVal, simplify, true);
          } else {
            //Check whether it will be a single imaginary number and not a complex number if b is 0
            if (negB == Decimal.parse("0")) {
              //Get both positive and negative factors as if this was a normal problem and append i to the end
              posFactor =
                  produceFactor(Decimal.parse(simplify), divisionVal, true);
              negFactor =
                  produceFactor(Decimal.parse("-$simplify"), divisionVal, true);
              //Return the combined factorized problem
              factorization = "$posFactor$negFactor";
              //Get both positive and negative answers as if this was a normal problem and append i to the end
              posAnswer = simplifyAnswer(Decimal.parse(simplify), divisionVal, "", true);
              negAnswer = simplifyAnswer(Decimal.parse("-$simplify"), divisionVal, "", true);
              //Make it into a single answer variable
              answer = "$posAnswer, $negAnswer";
            } else {
              //TODO: Setup complex solutions
            }
          }
        }
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text("Quadratic Calculator"),),
      backgroundColor: Colors.black,
      body: new Container(
          child: new ListView(
            children: <Widget>[
              new Padding(padding: new EdgeInsets.all(15.0)),
              new Text(
                "Enter the \"a\", \"b\", and \"c\" values of the Quadratic equation in the textfields below.",
                style: new TextStyle(fontSize: 15.0, color: Colors.white),
              ),
              new Padding(padding: new EdgeInsets.all(10.0)),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      width: 62.0,
                      height: 50.0,
                      color: Colors.white,
                      child: new TextField(
                        controller: aVal,
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                            hintText: "'A' Value",
                            border: new UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.black))),
                      ),
                    ),
                    new Padding(padding: new EdgeInsets.all(40.0)),
                    new Container(
                      width: 62.0,
                      height: 50.0,
                      color: Colors.white,
                      child: new TextField(
                        controller: bVal,
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                            hintText: "'B' Value",
                            border: new UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.black))),
                      ),
                    ),
                    new Padding(padding: new EdgeInsets.all(40.0)),
                    new Container(
                      width: 62.0,
                      height: 50.0,
                      color: Colors.white,
                      child: new TextField(
                        controller: cVal,
                        keyboardType: TextInputType.number,
                        decoration: new InputDecoration(
                            hintText: "'C' Value",
                            border: new UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.black))),
                      ),
                    ),
                  ]),
              new Padding(padding: new EdgeInsets.all(25.0)),
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new RaisedButton(
                    onPressed: _calculate,
                    child: new Text(
                      "Calculate!",
                      style: new TextStyle(color: Colors.white, fontSize: 24.0),
                    ),
                    color: Colors.blue,
                  )
                ],
              ),
              new Padding(padding: new EdgeInsets.all(20.0)),
              new Text(
                "Answer(s):",
                textAlign: TextAlign.center,
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                ),
              ),
              new Padding(padding: new EdgeInsets.all(10.0)),
              new Text(
                "$answer",
                textAlign: TextAlign.center,
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              new Text(
                "$underscores",
                textAlign: TextAlign.center,
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 10.0,
                ),
              ),
              new Padding(padding: new EdgeInsets.all(5.0)),
              new Text(
                "$denominator",
                textAlign: TextAlign.center,
                style: new TextStyle(
                    color: Colors.white,
                    fontSize: 20.0
                ),
              ),

              new Padding(padding: new EdgeInsets.all(20.0)),
              new Text(
                "Factorization",
                textAlign: TextAlign.center,
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                ),
              ),
              new Padding(padding: new EdgeInsets.all(10.0)),
              new Text(
                "$factorization",
                textAlign: TextAlign.center,
                style: new TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              new Text(
                "$factorUnder",
                textAlign: TextAlign.center,
                style: new TextStyle(
                    color: Colors.white,
                    fontSize: 10.0
                ),
              ),
              new Padding(padding: new EdgeInsets.all(5.0)),
              new Text(
                "$factorDenom",
                textAlign: TextAlign.center,
                style: new TextStyle(
                    color: Colors.white,
                    fontSize: 20.0
                ),
              ),

            ],
          )),
    );
  }

  //Method to simplify the values we get from the user into a nice, presentable answer
  String simplifyAnswer(Decimal wholeNumRoot, Decimal divisor, String nonPerfectRoot, bool imaginary) {
    //Declare initial returning var as well
    String ansReturn = "";
    //Check if we have an imperfect root
    if (nonPerfectRoot != "") {
      //If so, check if we have a b value or if it is just a root answer
      bool needNegB = wholeNumRoot != Decimal.parse("0");
      //Split the square root (it alreaady has been simplified for us)
      List<String> nums = nonPerfectRoot.split("√");
      //Check if it contains a front number
      if (nums[0] != "") {
        //If so, find a gcd between all numbers as there may be a potential for simplification of the entire problem
        Decimal gcdAllNums = gcd(
            gcd(Decimal.parse(nums[0]), wholeNumRoot), divisor);
        //Check if we need the number in front still (in case gcd made it 1)
        bool needFrontSqrtNum = Decimal.parse(nums[0])/gcdAllNums != Decimal.parse("1");
        //Declare our returned factorization using multiple inline ternaries to give a clean answer
        ansReturn = "${needNegB ? wholeNumRoot/gcdAllNums : ""}±${needFrontSqrtNum ? Decimal.parse(nums[0])/gcdAllNums: ""}√${nums[1]}${imaginary ? "i" : ""}";

      } else {
        //Return an answer without simplification but some checks as to what is needed
        ansReturn = "${needNegB ? wholeNumRoot : ""}±√${nums[1]}${imaginary ? "i" : ""}";
      }
      return ansReturn;
    }
    //Check if the whole number root (no irregular roots now) can be evenly divided
    if (wholeNumRoot % divisor == Decimal.parse("0")) {
      //If so, return the value of it divided plus an 'i' if necessary
      ansReturn = "${wholeNumRoot/divisor}${imaginary ? "i" : ""}";
    } else {
      //Check if there is any way to simplify and return the simplified answer
      Decimal divisionVal = gcd(wholeNumRoot, divisor);
      ansReturn = "${wholeNumRoot/divisionVal}/${divisor/divisionVal}${imaginary ? "i" : ""}";
    }
    return ansReturn;
  }

  //Method t make the underscores(fraction bars)
  String makeUnderscores(String value, double multiplier) {
    String underscore = "";
    for (int i = 0; i < (value.length * multiplier); i++) {
      underscore += "_";
    }
    return underscore;
  }
  //Method to produce the factorization of a non-square root problem
  String produceFactor(Decimal root, Decimal divisor, bool imaginary) {
    //Check if the numbers go in evenly
    if (root % divisor == Decimal.parse("0")) {
      //Check positive/negative and return a nice, formatted answer
      return root >= Decimal.parse("0") ? "(x-${root/divisor}${imaginary ? "i" : ""})" : "(x+${(root * Decimal.parse("-1"))/divisor}${imaginary ? "i" : ""})";
    } else {
      //Get a gcd and try to simplify
      Decimal divisionVal = gcd(root, divisor);
      Decimal simplifiedRoot = root/divisionVal;
      Decimal simplifiedDivisor = divisor/divisionVal;
      //Return the potentially simplified answer in a clean method (like normal factorization)
      return root >= Decimal.parse("0") ? "(${simplifiedDivisor}x-$simplifiedRoot${imaginary ? "i" : ""})" : "(${simplifiedDivisor}x+${simplifiedRoot * Decimal.parse("-1")}${imaginary ? "i" : ""})" ;
    }
  }

  //Method to factor a square-root problem
  String sqrtFactor(Decimal wholeNumRoot, Decimal divisor, String nonPerfectRoot, bool imaginary) {
    //Reset all values in case of any failures
    resetUnder();
    //Split the square root (simplified) into its root and front number
    List<String> nums = nonPerfectRoot.split("√");
    String factoredAns = "";
    //Check whether the front num is 0
    if (nums[0] != "") {
      //Get a gcf if possible and simplify all whole numbers by it
      Decimal gcfAllNums = gcd(
          gcd(Decimal.parse(nums[0]), wholeNumRoot), divisor);
      Decimal newB = wholeNumRoot / gcfAllNums;
      Decimal newRoot = Decimal.parse(nums[0]) / gcfAllNums;
      Decimal newDivVal = divisor / gcfAllNums;
      //Declare factoring string vars for future use
      String finalFact = "";
      String frontFact = "";
      String reboundFront = "1";
      //Check if the divisor is 2, or doesn't equal it
      if (divisor / Decimal.parse("2") != Decimal.parse("1")) {
        //Set the front number as in the 'a' in a(bx - c)
        frontFact = "${divisor / Decimal.parse("2")}";
        //Set the rebound number as in a(bx - c)
        reboundFront = "${divisor / Decimal.parse("2")}";
      }
      //Get a newVal and check that it isn't 1
      String newerVal = "";
      if (newDivVal != Decimal.parse("1")) {
        newerVal = "$newDivVal";
      }
      //Declare the final factoring denominator
      finalFact = "${newDivVal * Decimal.parse("2")}";
      //Get another gcf between they new generated numbers and if not 1, simplify all new numbers
      Decimal gcfAnother = gcd(newDivVal * Decimal.parse("2"), Decimal.parse(reboundFront));
      if (gcfAnother != Decimal.parse("1")) {
        frontFact = "${Decimal.parse(frontFact)/gcfAnother}";
        if (frontFact == "1") {
          frontFact = "";
        }
        //Final denominator if gcf is not 1
        finalFact = "${Decimal.parse(finalFact)/gcfAnother}";
      }
      //Check if we need the frontal sqrt number after simplification
      bool needFrontSqrtNum = newRoot != Decimal.parse("1");
      //Check if 'b' is 0 for cleanliness
      bool otherIsZero = newB == Decimal.parse("0");
      //Make different answers on whether b is greater than or equal to 0
      if (newB >= Decimal.parse("0")) {
        //Return a nice cleaned up factorization of an irregular answer (imaginary if needed)
        factoredAns = "$frontFact($newerVal" + "x${otherIsZero ? "" : "-$newB"}+${needFrontSqrtNum ? newRoot : ""}√${nums[1]}${imaginary ? "i" : ""})($newerVal" + "x${otherIsZero ? "" : "-$newB"}-${needFrontSqrtNum ? newRoot : ""}√${nums[1]}${imaginary ? "i" : ""})";
      } else {
        //Return a nice cleaned up factorization of an irregular answer (imaginary if needed) with the correct signs for a negative numebr
        factoredAns = "$frontFact($newerVal" + "x${otherIsZero ? "" : "+${newB * Decimal.parse("-1")}"}+${needFrontSqrtNum ? newRoot : ""}√${nums[1]}${imaginary ? "i" : ""})($newerVal" + "x${otherIsZero ? "" : "+${newB * Decimal.parse("-1")}"}-${needFrontSqrtNum ? newRoot : ""}√${nums[1]}${imaginary ? "i" : ""})";
      }
      //Check if the factorization denominator is not 1, and if not, make underscores as a fraction bar
      if (finalFact != "1") {
        factorUnder = makeUnderscores(factorization, 2.3);
        factorDenom = "$finalFact";
      }
      //Check if the answer denominator is not 1, and if not, make underscores as a fraction bar
      if (newDivVal != Decimal.parse("1")) {
        underscores = makeUnderscores(answer, 3);
        denominator = "$newDivVal";
      }
    } else {
      //Check whether the number to return is negative or not and return a nicely formatted value in factored form
      if (wholeNumRoot >= Decimal.parse("0")) {
        factoredAns = "(x-$wholeNumRoot+√${nums[1]}${imaginary ? "i" : ""})(x-$wholeNumRoot-√${nums[1]}${imaginary ? "i" : ""})";
      } else {
        factoredAns = "(x+${wholeNumRoot * Decimal.parse("-1")}+√${nums[1]}${imaginary ? "i" : ""})(x+${wholeNumRoot * Decimal.parse("-1")}-√${nums[1]}${imaginary ? "i" : ""})";
      }
      //Check if the shared division is not 1 and make underscores if so as a fraction bar for both
      if (divisor != Decimal.parse("1")) {
        underscores = makeUnderscores(answer, 3);
        factorUnder = makeUnderscores(factorization, 2.3);
        denominator = "$divisor";
        factorDenom = "$divisor";
      }
    }
    return factoredAns;
  }
  //Method setting all UI answer values to empty other than main answer and factorization
  void resetUnder() {
    underscores = "";
    denominator = "";
    factorUnder = "";
    factorDenom = "";
  }
  //Method to get the gcd of a number
  Decimal gcd(Decimal a, Decimal b) {
    //Get teh gcf through modulus and a loop
    while (b != Decimal.parse("0")) {
      Decimal temp = b;
      b = a % b;
      a = temp;
    }
    return a;
  }
  //Method to simplify a square root into a potential number in front then root
  String sqrtSimplify(Decimal num) {
    //Declare both outside and inside root values
    Decimal outside_root = Decimal.parse("1");
    Decimal inside_root = num;
    //Division number for simplifying the number (as lowest non-1 perfect square is 4)
    Decimal d = Decimal.parse("2");
    //Recursively divide by the next perfect square as long as it is under the root and check if it is divisible
    while (d * d <= inside_root) {
      if (inside_root % (d * d) == Decimal.parse("0")) {
        inside_root = inside_root ~/ (d * d);
        outside_root = outside_root * d;
      } else {
        d = d + Decimal.parse("1");
      }
    }
    //Return the set value based on what numbers are 1 and which numbers are not 1 (either just root, num and root, just num, or 1
    if(outside_root == Decimal.parse("1") && inside_root != Decimal.parse("1")) {
      debugPrint("√$inside_root");
      return "√$inside_root";
    } else if (outside_root != Decimal.parse("1") && inside_root == Decimal.parse("1")) {
      debugPrint("$outside_root");
      return "$outside_root";
    } else if (outside_root == Decimal.parse("1") && inside_root == Decimal.parse("1")) {
      debugPrint("1");
      return "1";
    } else {
      debugPrint("$outside_root√$inside_root");
      return "$outside_root√$inside_root";
    }
  }
}