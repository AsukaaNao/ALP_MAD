import SwiftUI

struct SignUpPage: View {
    
    @StateObject private var viewModel = SignUpVM()
    
    @State private var isSignUpSuccess = false
    @State private var navigateToLogIn = false
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
                
                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                    .padding(.bottom, 20)
                
                ZStack(alignment: .leading){
                    if viewModel.username.isEmpty {
                        Text("Username")
                            .foregroundColor(.purple)
                    }
                    TextField("", text: $viewModel.username)
                }
                .padding()
                .foregroundColor(.black)
                .background(Color.white)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.secondary, lineWidth: 1)
                )
                .padding(.horizontal, 40)
                
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
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.secondary, lineWidth: 1)
                )
                .padding(.horizontal, 40)
                .padding(.top, 20)
                
                
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
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.secondary, lineWidth: 1)
                )
                .padding(.horizontal, 40)
                .padding(.top, 20)
                
                Button {
                    viewModel.signUp() { success in
                        if success {
                            isSignUpSuccess = true
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                } label: {
                    Text("Sign Up")
                        .bold()
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: 290)
                        .background(.purple)
                        .cornerRadius(20)
                        .padding(.horizontal, 40)
                }
                .padding(.top, 30)
                
                Text("Or")
                    .foregroundColor(.purple)
                    .bold()
                    .padding(10)
                
                HStack {
                    Text("Already have an account?")
                        .foregroundColor(.gray)
                    Button {
                        navigateToLogIn = true
//                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Log In")
                            .foregroundColor(.purple)
                    }
                }
                .padding(.bottom, 20)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Sign Up With Email")
            .navigationDestination(isPresented: $isSignUpSuccess) {
                LandingPage(showSignInView: .constant(true))
            }
            .navigationDestination(isPresented: $navigateToLogIn) {
                LoginPage(showSignInView: .constant(true))
            }
            .background(Color.white)
        }
    }
}

struct SignUpPage_Previews: PreviewProvider {
    static var previews: some View {
        SignUpPage()
    }
}
