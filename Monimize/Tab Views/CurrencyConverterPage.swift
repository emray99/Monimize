//
//  CurrencyConverterPage.swift
//  Monimize
//
//  Created by Ray Liu on 4/26/21.
//

import SwiftUI

struct CurrencyConverterPage: View {

    @State private var textFieldValue = ""
    @State private var amountEntered = ""

    @State private var selectedIndexFrom = 156  // USD
    @State private var selectedIndexTo = 50     // EUR

    var body: some View {

        
            ZStack {

                Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)

            Form {

                Section(header: Text("Select Currency to Convert From")) {

                    Picker("From", selection: $selectedIndexFrom) {

                        ForEach(0 ..< listOfAllCurrencies.count, id: \.self) {

                            Text(listOfAllCurrencies[$0])

                        }

                    }
                    .frame(minWidth: 300, maxWidth: 500)

                }

                Section(header: Text("Select Currency to Convert To")) {

                    Picker("To", selection: $selectedIndexTo) {

                        ForEach(0 ..< listOfAllCurrencies.count, id: \.self) {

                            Text(listOfAllCurrencies[$0])

                        }

                    }
                    .frame(minWidth: 300, maxWidth: 500)

                }

                Section(header: Text("Enter Amount to Convert")) {
                    HStack {

                        TextField("Enter Amount to Convert", text: $textFieldValue,

                            onCommit: {

                                // Record entered value after Return key is pressed

                                self.amountEntered = self.textFieldValue

                            }

                        )
                        .keyboardType(.numbersAndPunctuation)

                       

                        // Button to clear the text field

                        Button(action: {

                            self.textFieldValue = ""
                            self.amountEntered = ""

                        }) {

                            Image(systemName: "clear")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))

                        }

                    }   // End of HStack
                        .frame(minWidth: 300, maxWidth: 500)

                }

               

                // Show this section only after Return key is pressed

                if !amountEntered.isEmpty {
                    Section(header: Text("Conversion Result")) {

                        conversionResult

                    }

                }

               

            }   // End of Form
                .navigationBarTitle(Text("Currency Conversion"), displayMode: .inline)

            }   // End of ZStack

           

       
            .customNavigationViewStyle()  // Given in NavigationStyle.swift

    }

   

    var conversionResult: Text {

        let convertFrom = listOfAllCurrencies[selectedIndexFrom]

        let convertTo = listOfAllCurrencies[selectedIndexTo]

       

        // convertFrom = "United States Dollar (USD)"
        let array1 = convertFrom.components(separatedBy: "(")

        // array1 = ["United States Dollar ", "USD)"]

        let array2 = array1[1].components(separatedBy: ")")

        // array2 = ["USD", ""]

        let currencyIdFrom = array2[0]

        // currencyIdFrom = "USD"

       

        let arrayOne = convertTo.components(separatedBy: "(")

        let arrayTwo = arrayOne[1].components(separatedBy: ")")

        let currencyIdTo = arrayTwo[0]

       

        // currencyConversionRate public function is given in CurrencyApiData.swift

        let conversionRate = currencyConversionRate(from: currencyIdFrom, to: currencyIdTo)

        if !(conversionRate == 0.0) {

           

            if let amount = Double(amountEntered) {

                let result = conversionRate * amount

                let message = amountEntered + " " + convertFrom + " = " + String(result) + " " + convertTo

                return Text(message)

            } else {

                return Text("Entered amount is not a number!")

            }

           

        } else {

            return Text("Unable to get currency conversion rate from API!")

        }

    }

   

}

 
