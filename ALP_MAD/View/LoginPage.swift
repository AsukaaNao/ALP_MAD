import SwiftUI
import AuthenticationServices

struct LoginPage: View {
    @StateObject private var viewModel = LoginVM()
    @State private var isSignInSuccess = false
    @State private var navigateToSignUp = false
    @Binding var showSignInView: Bool
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
                    RoundedRectangle(cornerRadius: 20)
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
                    RoundedRectangle(cornerRadius: 20)
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
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background(.purple)
                        .cornerRadius(20)
                        .padding(.horizontal, 40)
                }
                .padding(.top, 30)
                
                Text("Or")
                    .foregroundColor(.purple)
                    .bold()
                    .padding(10)
                
                ZStack {
                    SignInWithAppleButton { request in
                        viewModel.handleSignInWithAppleRequest(request)
                    } onCompletion: { result in
                        viewModel.handleSignInWithAppleCompletion(result)
                    }
                    .signInWithAppleButtonStyle(.black)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .padding(.horizontal, 40)
                }
                .frame(maxWidth: 285)
                .background(Color.black)
                .cornerRadius(20)
                .clipped()

                
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
            .onAppear() {
                viewModel.checkCoupleId()
            }
            .navigationDestination(isPresented: $isSignInSuccess) {
                CoupleStatusView(viewModel: MainPageViewModel(), showSignInView: $showSignInView)
            }
            .navigationDestination(isPresented: $navigateToSignUp) {
                SignUpPage()
            }
            .background(Color.white)
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    LoginPage(showSignInView: .constant(true))
}
