//
//  ContentView.swift
//  BetterRest
//
//  Created by Luiz Calazans on 15/01/24.
//
import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var calculatedBedTime: Date? {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60  * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Int64(hour + minute), estimatedSleep: sleepAmount, coffee: Int64(coffeeAmount))
            
            return wakeUp - prediction.actualSleep
        } catch {
            return nil
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                VStack(alignment: .leading, spacing: 0) {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    
                    DatePicker("Please, enter a time", selection: $wakeUp,
                               displayedComponents: .hourAndMinute)
                    .labelsHidden()
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                    
                }
                VStack(alignment: .leading, spacing: 0) {
                    Picker("Daily coffee intake", selection: $coffeeAmount) {
                        ForEach(0..<21) {
                            Text("^[\($0) cup](infletcion: true)")
                        }
                    }.pickerStyle(.navigationLink)
                }
                VStack {
                    Text("Calculated Bedtime: \(calculatedBedTime?.formatted(date: .omitted, time: .shortened) ?? "N/A")")
                }
            }
            .navigationTitle("BetterRest")
        }
    }
    
    
}

#Preview {
    ContentView()
}
