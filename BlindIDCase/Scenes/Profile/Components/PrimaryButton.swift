import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false

    var body: some View {
        Button(action: {
            if !isDisabled, !isLoading {
                action()
            }
        }) {
            ZStack {
                // Button background
                RoundedRectangle(cornerRadius: 8)
                    .fill(isDisabled ? Color.gray.opacity(0.5) : Color.blue)
                    .frame(height: 50)

                if isLoading {
                    // Loading indicator
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.2)
                } else {
                    // Button text
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
        }
        .disabled(isDisabled || isLoading)
    }
}

#Preview {
    VStack(spacing: 20) {
        PrimaryButton(title: "Sign In", action: {})
        PrimaryButton(title: "Loading...", action: {}, isLoading: true)
        PrimaryButton(title: "Disabled", action: {}, isDisabled: true)
    }
    .padding()
    .background(Color(.appMain))
}
