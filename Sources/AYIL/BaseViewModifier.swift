//
//  BaseViewModifier.swift
//
//  Created by Anushka Samarasinghe on 2024-01-19.
//


import Foundation
import SwiftUI

@available(iOS 15.0, *)
public struct BaseViewModifier: ViewModifier {
    let includesDecimalKeyboard: Bool

    init(includesDecimalKeyboard: Bool = false) {
        self.includesDecimalKeyboard = includesDecimalKeyboard
    }
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .center) {
            Color.clear
                .ignoresSafeArea()

            content
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                keyboardTopToolbar()
            }
        }
        .navigationBarHidden(true)
    }

    public func keyboardTopToolbar() -> some View {
        Button(action: {
            UIApplication.shared.endEditing()
        }, label: {
            Text("Done")
                .font(.system(size: 16))
        })
        .frame(maxWidth: .infinity, alignment: .trailing)
        .keyboardType(includesDecimalKeyboard ? .decimalPad : .default)
    }
}

// To dismiss keyboard when touched outside
@available(iOS 15.0, *)
public struct DismissingKeyboard: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .onTapGesture {
                let keyWindow = UIApplication.shared.connectedScenes
                    .filter({ $0.activationState == .foregroundActive })
                    .map({ $0 as? UIWindowScene })
                    .compactMap({ $0 })
                    .first?.windows
                    .filter({ $0.isKeyWindow }).first
                keyWindow?.endEditing(true)
            }
    }
}

@available(iOS 15.0, *)
extension View {
    public func dismissingKeyboard() -> some View {
        self.modifier(DismissingKeyboard())
    }

    public func withBaseViewMod(includesDecimalKeyboard: Bool = false) -> some View {
        modifier(BaseViewModifier(includesDecimalKeyboard: includesDecimalKeyboard))
    }
}

extension UIApplication {
    public func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder),
                   to: nil,
                   from: nil,
                   for: nil)
    }
}
