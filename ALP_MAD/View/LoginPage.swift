import SwiftUI

struct LoginPage: View {
    @StateObject private var viewModel = LoginVM()
    @State private var isSignInSuccess = false
    @State private var navigateToSignUp = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .padding(.bottom, 40)
                
                Text("Log In")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                    .padding(.bottom, 20)
                
                ZStack(alignment: .leading){
                    if viewModel.email.isEmpty {
                        Text("Email")
                            .foregroundColor(.purple)
                    }
                    TextField("", text: $viewModel.email)
                }
                .padding()
                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.secondary, lineWidth: 1)
                )
                .padding(.horizontal, 40)
                
                
                ZStack(alignment: .leading) {
                    if viewModel.password.isEmpty {
                        Text("Password")
                            .foregroundColor(.purple)
                    }
                    SecureField("", text: $viewModel.password)
                }
                .padding()
                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.secondary, lineWidth: 1)
                )
                .padding(.horizontal, 40)
                .padding(.top, 20)
                
                Button {
                    viewModel.signIn() { success in
                        if success {
                            isSignInSuccess = true
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                } label: {
                    Text("Sign In")
                        .bold()
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(.purple)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }
                .padding(.top, 30)
                
                Text("Or")
                    .foregroundColor(.purple)
                    .bold()
                    .padding(10)
                
//                 SignInWithAppleButton { request in
//                     // Handle request
//                 } onCompletion: { result in
//                     // Handle result
//                 }
                
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.gray)
                    Button {
                        navigateToSignUp = true
//                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Sign Up")
                            .foregroundColor(.purple)
                    }
                }
                .padding(.bottom, 20)
                
                Spacer()
            }
            .padding()
            .navigationDestination(isPresented: $isSignInSuccess) {
                MainPage(showSignInView: .constant(true))
            }
            .navigationDestination(isPresented: $navigateToSignUp) {
                SignUpPage()
            }
            .navigationBarHidden(true)
        }
        .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    LoginPage()
}
