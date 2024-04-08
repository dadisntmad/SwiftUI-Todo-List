import SwiftUI

struct SecureTextFieldViewModifier: ViewModifier {
    @Binding var isSecure: Bool
    
    func body(content: Content) -> some View {
        content
        .padding()
        .frame(height: 50)
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(alignment: .trailing) {
            Image(systemName: isSecure ? "eye" : "eye.slash")
                .foregroundStyle(isSecure ? Color.gray : Color.black)
                .padding(.trailing, 16)
                .onTapGesture {
                    withAnimation {
                        isSecure.toggle()
                    }
                }
        }
        .textInputAutocapitalization(.never)
    }
}
