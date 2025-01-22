import Foundation
import SwiftUI

public extension Alert {
    init(_ error: Error, _ dismissAction: (() -> Void)? = nil) {
        self.init(
            errorMessage: error.localizedDescription,
            dismissAction
        )
    }

    init(errorMessage: String, _ dismissAction: (() -> Void)? = nil) {
        self.init(
            title: Text("错误提示"),
            message: Text(errorMessage),
            dismissButton: .default(Text("确定")) {
                dismissAction?()
            }
        )
    }
    
    init(title: String = "提示", okMessage: String, _ dismissAction: (() -> Void)? = nil) {
        self.init(
            title: Text(title),
            message: Text(okMessage),
            dismissButton: .default(Text("确定")) {
                dismissAction?()
            }
        )
    }
    
    init(OKORNOtitle: String = "提示", YesOrNOMessage: String, _ primaryAction: (() -> Void)? = nil) {
        self.init(
            title: Text(OKORNOtitle),
            message: Text(YesOrNOMessage),
            primaryButton: .default(Text("确定"), action: {
                primaryAction?()
            }),
            secondaryButton: .cancel(Text("取消"), action: {
            })
        )
    }
    
}

public extension View {
    func alertBinding(_ binding: Binding<Alert?>) -> some View {
        
      alert(isPresented: Binding(get: {
            binding.wrappedValue != nil
        }, set: { newValue, _ in
            if !newValue {
                binding.wrappedValue = nil
            }
        })) {
            binding.wrappedValue!
           
        }

        
    }

    func alertBinding(_ binding: Binding<Alert?>, _ isLoading: Binding<Bool>) -> some View {
        alert(isPresented: Binding(get: {
            binding.wrappedValue != nil
        }, set: { newValue, _ in
            if !newValue, !isLoading.wrappedValue {
                binding.wrappedValue = nil
            }
        })) {
            binding.wrappedValue!
        }
    }
}
