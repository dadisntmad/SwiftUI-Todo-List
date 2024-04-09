import SwiftUI

struct ErrorView: View {
    var error: String
    
    var body: some View {
        Text(error)
            .font(.caption)
            .foregroundStyle(.red)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.red.opacity(0.17))
            )
    }
}

#Preview {
    ErrorView(error: "Invalid email or password. Please try again.")
}
