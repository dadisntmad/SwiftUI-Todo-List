import SwiftUI

struct ButtonView: View {
    var title: String
    var action: () -> Void
    var fillColor: Color
    
    var body: some View {
        Button(action: action, label: {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(fillColor)
                .foregroundStyle(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
        })
    }
}

#Preview {
    ButtonView(title: "Sign In", action: {}, fillColor: Color.black)
}
