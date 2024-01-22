//
//  ContentView.swift
//  iExpense
//
//  Created by Luiz Calazans on 21/01/24.
//
import Observation
import SwiftUI

struct ExpenseItem : Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    @State private var showingPersonalExpense = true
    @State private var expenseType = "Personal"
    
    let expenseTypes  = ["Business", "Personal"]
    
    var filteredItems: [ExpenseItem] {
        return expenses.items.filter { $0.type == expenseType }
    }
    
    var body: some View {
        NavigationStack {
                Picker("ExpenseType", selection: $expenseType) {
                    ForEach(expenseTypes, id: \.self) {
                        Text($0)
                    }
                }.pickerStyle(.segmented)
                
                List {
                    ForEach(filteredItems) {
                        item in HStack {
                            VStack(alignment: .leading) {
                                Text(item.name).font(.headline)
                                
                                Text(item.type)
                            }
                            
                            Spacer()
                            
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        }
                    }
                    .onDelete(perform: removeItems)
                }
                .navigationTitle("iExpense")
                .toolbar {
                    Button("Add expense", systemImage: "plus") {
                        showingAddExpense = true
                    }
                }
                .sheet(isPresented: $showingAddExpense) {
                    AddView(expenses: expenses)
                }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        let indicesToRemove = offsets.map { filteredItems[$0] }
        
        expenses.items.removeAll { item in
            indicesToRemove.contains { $0.id == item.id }
        }
    }
    
    func totalAmount() -> String {
        let sum = filteredItems.reduce(0) { $0 + $1.amount }
        return String(format: "%.2f", sum)
    }
}

#Preview {
    ContentView()
}
