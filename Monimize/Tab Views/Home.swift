//
//  Home.swift
//  Monimize
//
//  Created by Eric Li on 4/27/21.
//

import SwiftUI
import SwiftUICharts
import WidgetKit


extension Double {
    /// Rounds the double to decimal places value
    func roundedtoPlaces( places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}
struct Home: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(fetchRequest: SavingItem.allSavingItemsFetchRequest()) var allSavingItems: FetchedResults<SavingItem>
    

    @EnvironmentObject var userData: UserData
    
    //var totalSum = userData.budgetsList.map({$0.amount}).reduce(0, +)
    var body: some View {
        
        NavigationView {
            
        Form{
            Text("Total Expense: $\(String(format: "%.2f", totalSum))")
                .font(.title)
                .padding()
            HStack {
                Spacer()
                BarChartView(data: ChartData(values: [("Jan",sumMonthly(month: "01")), ("Feb",sumMonthly(month:"02")), ("Mar",sumMonthly(month:"03")), ("Apr",sumMonthly(month:"04")), ("May",sumMonthly(month:"05")),("Jun",sumMonthly(month:"06")),("July",sumMonthly(month:"07")),("Aug",sumMonthly(month:"08")),("Sept",sumMonthly(month:"09")),("Oct",sumMonthly(month:"10")),("Nov",sumMonthly(month:"11")),("Dec",sumMonthly(month:"12"))]), title: "Expense 2021", legend: "Monthly", form: ChartForm.medium, dropShadow: false)
                
                Spacer()
            }
           
            
            
            if (allSavingItems.count == 0)
            {
                
                Text("No saving plans.")
            }
            else
            {
                Section(header: Text("My Saving Plan recorded")) {
                    
                        List {
                            /*
                             Each NSManagedObject has internally assigned unique ObjectIdentifier
                             used by ForEach to display the Songs in a dynamic scrollable list.
                             */
                            let first3 = self.allSavingItems.prefix(3)
                            ForEach(first3) { aSaving in
                                NavigationLink(destination: SavingDetails(saving: aSaving)) {
                                    SavingListItem(saving: aSaving)
                                }
                            }
                            
                           
                        }   // End of List
                       
                        
                       
                    }   // End of NavigationView
                    .navigationBarHidden(true)
                    .navigationViewStyle(StackNavigationViewStyle())
                
            }
        
        }
        }
  
    }
//    var cateList: [Doube] {
//        let list = userData.budgetsList
//        var dList =
//        for bud in list {
//            dList.append(bud.amount)
//        }
//        return dList
//    }
    func sumMonthly(month: String)->Double {
        let list = userData.budgetsList
        var sum = 0.0
        
        for item in list {
            if item.date.substring(with: 5..<7) == month {
                
                sum += item.amount
            }
        }
        return sum
    }
    
    var totalSum: Double {
        let list = userData.budgetsList
        let userDefaults = UserDefaults(suiteName: "group.dataCache")
        userDefaults?.setValue("Total Expense: $\(list.reduce(0, {$0 + $1.amount}))", forKey: "text")
        WidgetCenter.shared.reloadAllTimelines()
        
        return list.reduce(0, {$0 + $1.amount * currencyConversionRate(from: $1.currency, to: "USD")})
    }
    
        
}
    

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
