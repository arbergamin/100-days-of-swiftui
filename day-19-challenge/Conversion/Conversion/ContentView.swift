//
//  ContentView.swift
//  Conversion
//
//  Created by Amelio Bergamin on 2020-04-22.
//  Copyright © 2020 Amelio Bergamin. All rights reserved.
//

import SwiftUI

let timeUnit = [(name: "Seconds", unit: UnitDuration.seconds),
                (name: "Minutes", unit: UnitDuration.minutes),
                (name: "Hours", unit: UnitDuration.hours),
                (name: "Days", unit: UnitDuration.days)]

let temperatureUnit = [(name: "Celsius", unit: UnitTemperature.celsius),
                       (name: "Fahrenhiet", unit: UnitTemperature.fahrenheit),
                       (name: "Kelvin", unit: UnitTemperature.kelvin)]

let lenghtUnit = [(name: "Meters", unit: UnitLength.meters),
                  (name: "Kilometers", unit: UnitLength.kilometers),
                  (name:"Feet", unit: UnitLength.feet),
                  (name: "Yards", unit: UnitLength.yards),
                  (name: "Miles", unit: UnitLength.miles)]

let volumeUnit = [(name: "Millileters", unit: UnitVolume.milliliters),
                  (name: "Liters", unit: UnitVolume.liters),
                  (name: "Cups", unit: UnitVolume.cups),
                  (name: "Pints", unit: UnitVolume.pints),
                  (name: "Gallons", unit: UnitVolume.gallons)]

struct ContentView: View {
    enum ConversionType: String, CaseIterable {
        case Len, Temp, Time, Vol
    }
    
    @State private var conversionTypeSelected = ConversionType.Len {
        didSet {
            inputType = 0
            outputType = 0
        }
    }
    
    @State private var inputType = 1
    @State private var outputType = 0
    @State private var inputValue = ""
    
    var selectedUnits: [(name: String, unit: Dimension)] {
        switch conversionTypeSelected {
        case .Len:
            return lenghtUnit
        case .Temp:
            return temperatureUnit
        case .Time:
            return timeUnit
        case .Vol:
            return volumeUnit
        }
    }
    
    var outputValue: Double {
        switch conversionTypeSelected {
        case .Len:
            return convertLength()
        case .Temp:
            return convertTemprature()
        case .Time:
            return convertTime()
        case .Vol:
            return convertVolume()
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Select conversion type")) {
                    Picker("Conversion Type", selection: $conversionTypeSelected) {
                        ForEach(ConversionType.allCases, id: \.self) {
                            Text("\($0.rawValue)")
                        }
                    }
                .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Select input unit type")) {
                    Picker("Input Type", selection: $inputType) {
                        ForEach(0 ..< selectedUnits.count, id: \.self) {
                            Text("\(self.selectedUnits[$0].name)")
                        }
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Section(header: Text("Select output unit type")) {
                    Picker("Input Type", selection: $outputType) {
                        ForEach(0 ..< selectedUnits.count, id: \.self) {
                            Text("\(self.selectedUnits[$0].name)")
                        }
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Section(header: Text("Input value")) {
                    TextField("Input value", text: $inputValue)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Output value")) {
                    Text("\(outputValue)")
                }
            }
            .navigationBarTitle("Conversion")
        }
    }
    
    //"Seconds", "Minutes", "Hours", "Days"
    func convertTime() -> Double {
        let inputUnit = timeUnit[inputType].unit
        let outputUnit = timeUnit[outputType].unit
        
        return convertInputValue(from: inputUnit, to: outputUnit)
    }
    
    //"Meters", "Kilometers", "Feet", "Yards", "Miles"
    func convertLength() -> Double {
        let inputUnit = lenghtUnit[inputType].unit
        let outputUnit = lenghtUnit[outputType].unit
        
        return convertInputValue(from: inputUnit, to: outputUnit)
    }
    
    //"Millileters", "Liters", "Cups", "Pints", "Gallons"
    func convertVolume() -> Double {
        let inputUnit = volumeUnit[inputType].unit
        let outputUnit = volumeUnit[outputType].unit
        
        return convertInputValue(from: inputUnit, to: outputUnit)
    }
    
    //"Celsius", "Fahrenhiet", "Kelvin"
    func convertTemprature() -> Double {
        let inputUnit = temperatureUnit[inputType].unit
        let outputUnit = temperatureUnit[outputType].unit
        
        return convertInputValue(from: inputUnit, to: outputUnit)
    }
    
    func convertInputValue(from inputUnit: Dimension, to outputUnit: Dimension) -> Double {
        let input = Double(inputValue) ?? 0
        let inputMesurement = Measurement(value: input, unit: inputUnit)
        let outputMeasurement = inputMesurement.converted(to: outputUnit)
        
        return outputMeasurement.value
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//Found this in john-mueller's solution on gihut.  I understand the solution.
//What I don't understand is how to come up with this solution.
extension UnitDuration {
    static var days: UnitDuration {
        return UnitDuration(symbol: "day", converter: UnitConverterLinear(coefficient: 3600 * 24))
    }
}
