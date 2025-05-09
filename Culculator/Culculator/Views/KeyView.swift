//
//  KeyView.swift
//  Culculator
//
//  Created by Berkan Aydın on 24.04.2025.
//

import SwiftUI

struct KeyView: View {
    
    @State var value = "0"
    @State var runningNumber = 0
    @State var currentOperation: Operation = .none
    @State private var changeColor = false
    @State private var blur: CGFloat = 5
  
    
    let buttons: [[Keys]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .mutliply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal],
    ]
    
    var body: some View {
        VStack {
            Spacer()
         
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(changeColor ? Color("num").opacity(0.4) : Color.blue.opacity(0.2))
                    .scaleEffect(changeColor ? 1.5 : 1.0)
                    .frame(width: 350, height: 280)
                    .animation(Animation.easeInOut.speed(0.17).repeatForever(), value: changeColor).onAppear {
                                self.blur = 20
                            self.changeColor.toggle()
                        }
                    .overlay(
                        Text(value)
                            .bold()
                            .font(.system(size: 100))
                            .foregroundColor(.black)
                            )
            }.padding()
            
        ForEach(buttons, id: \.self) { row in
            HStack(spacing: 12) {
                ForEach(row, id: \.self) { item in
                    Button(action: {
                        self.didTap(button: item)
                    }, label: {
                        Text(item.rawValue)
                            .font(.system(size: 32))
                            .frame(
                                width: self.buttonWidth(item: item),
                                height: self.buttonHeight()
                            )
                            .background(item.buttonColor)
                            .foregroundColor(.black)
                            
                            .cornerRadius(self.buttonWidth(item: item)/2)
                            .shadow(color: .blue.opacity(0.8), radius: 30)
                    })
                }
            }
            .padding(.bottom, 3)
        }
        }
    }

    
    func buttonWidth(item: Keys) -> CGFloat {
        if item == .zero {
            return ((UIScreen.main.bounds.width - (4*12)) / 4) * 2
        }
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }

    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
    
    func didTap(button: Keys) {
        switch button {
        case .add, .subtract, .mutliply, .divide, .equal:
            if button == .add {
                self.currentOperation = .add
                self.runningNumber = Int(self.value) ?? 0
            }
            else if button == .subtract {
                self.currentOperation = .subtract
                self.runningNumber = Int(self.value) ?? 0
            }
            else if button == .mutliply {
                self.currentOperation = .multiply
                self.runningNumber = Int(self.value) ?? 0
            }
            else if button == .divide {
                self.currentOperation = .divide
                self.runningNumber = Int(self.value) ?? 0
            }
            else if button == .equal {
                let runningValue = self.runningNumber
                let currentValue = Int(self.value) ?? 0
                switch self.currentOperation {
                case .add: self.value = "\(runningValue + currentValue)"
                case .subtract: self.value = "\(runningValue - currentValue)"
                case .multiply: self.value = "\(runningValue * currentValue)"
                case .divide: self.value = "\(runningValue / currentValue)"
                case .none:
                    break
                }
            }

            if button != .equal {
                self.value = "0"
            }
        case .clear:
            self.value = "0"
        case .decimal, .negative, .percent:
            break
        default:
            let number = button.rawValue
            if self.value == "0" {
                value = number
            }
            else {
                self.value = "\(self.value)\(number)"
            }
        }
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        KeyView()
    }
}
