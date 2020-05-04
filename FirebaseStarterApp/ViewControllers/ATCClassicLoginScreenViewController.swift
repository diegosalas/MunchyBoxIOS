//
//  ATCClassicLoginScreenViewController.swift
//  DashboardApp
//
//  Created by Florian Marcu on 8/9/18.
//  Copyright © 2018 Instamobile. All rights reserved.
//

import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import UIKit
import AuthenticationServices

import CryptoKit


class ATCClassicLoginScreenViewController: UIViewController, ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        var window: UIWindow?
        return window!
      
    }
    
  
    
  var window: UIWindow?
    
  
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var passwordTextField: ATCTextField!
  @IBOutlet var contactPointTextField: ATCTextField!
  @IBOutlet var loginButton: UIButton!

  @IBOutlet var facebookButton: UIButton!
  @IBOutlet weak var appleButton: UIButton!
  @IBOutlet var backButton: UIButton!
  
  private let backgroundColor = HelperDarkMode.mainThemeBackgroundColor
  private let tintColor = UIColor(hexString: "#ff5a66")
  
  private let titleFont = UIFont.boldSystemFont(ofSize: 16)
  private let buttonFont = UIFont.boldSystemFont(ofSize: 19)
  
  private let textFieldFont = UIFont.systemFont(ofSize: 16)
  private let textFieldColor = UIColor(hexString: "#B0B3C6")
  private let textFieldBorderColor = UIColor(hexString: "#B0B3C6")
  
  private let separatorFont = UIFont.boldSystemFont(ofSize: 14)
  private let separatorTextColor = UIColor(hexString: "#464646")
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = backgroundColor
    backButton.setImage(UIImage.localImage("arrow-back-icon", template: true), for: .normal)
    backButton.tintColor = UIColor(hexString: "#ff5a66")
    backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
    
    titleLabel.font = titleFont
    titleLabel.text = "Sign In"
    titleLabel.textColor = tintColor
    
    contactPointTextField.configure(color: textFieldColor,
                                    font: textFieldFont,
                                    cornerRadius: 55/2,
                                    borderColor: textFieldBorderColor,
                                    backgroundColor: backgroundColor,
                                    borderWidth: 1.0)
    contactPointTextField.placeholder = "E-mail"
    contactPointTextField.textContentType = .emailAddress
    contactPointTextField.clipsToBounds = true
    
    passwordTextField.configure(color: textFieldColor,
                                font: textFieldFont,
                                cornerRadius: 55/2,
                                borderColor: textFieldBorderColor,
                                backgroundColor: backgroundColor,
                                borderWidth: 1.0)
    passwordTextField.placeholder = "Password"
    passwordTextField.isSecureTextEntry = true
    passwordTextField.textContentType = .emailAddress
    passwordTextField.clipsToBounds = true
    
//    separatorLabel.font = separatorFont
//    separatorLabel.textColor = separatorTextColor
//    separatorLabel.text = "OR"
    
    loginButton.setTitle("  Sign In with Email", for: .normal)
    loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
    loginButton.configure(color: UIColor.white,
                          font: buttonFont,
                          cornerRadius: 55/2,
                          backgroundColor: tintColor)
    
    facebookButton.setTitle("  Sign In with Facebook", for: .normal)
    facebookButton.addTarget(self, action: #selector(didTapFacebookButton), for: .touchUpInside)
    facebookButton.configure(color: UIColor.white,
                             font: buttonFont,
                             cornerRadius: 55/2,
                             backgroundColor: UIColor(hexString: "#334D92"))
 
    
    if #available(iOS 13, *) {
        appleButton.setTitle("Sign In with Apple", for: .normal)
         appleButton.addTarget(self, action: #selector(didTapAppleButton), for: .touchUpInside)

         appleButton.configure(color: UIColor.white ,
                                  font: buttonFont,
                                  cornerRadius: 55/2,
                                  backgroundColor: UIColor(hexString: "000000"  ))
      
    } else {
        appleButton.isHidden = true
    }
     
    
    
    self.hideKeyboardWhenTappedAround()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: false)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    self.navigationController?.setNavigationBarHidden(false, animated: false)
  }
  
  @objc func didTapBackButton() {
    self.navigationController?.popViewController(animated: true)
  }
  
  @objc func didTapLoginButton() {
    let loginManager = FirebaseAuthManager()
    guard let email = contactPointTextField.text, let password = passwordTextField.text else { return }
    loginManager.signIn(email: email, pass: password) {[weak self] (success) in
      self?.showPopup(isSuccess: success)
    }
  }
  
  @objc func didTapFacebookButton() {
    let loginManager = LoginManager()
    loginManager.logIn(permissions: ["email"], from: self) { (result, error) in
      if error != nil {
        self.showPopup(isSuccess: false)
        return
      }
      guard let token = AccessToken.current else {
        print("Failed to get access token")
        self.showPopup(isSuccess: false)
        return
      }
      
      FirebaseAuthManager().login(credential: FacebookAuthProvider.credential(withAccessToken: token.tokenString)) {[weak self] (success) in
        self?.showPopup(isSuccess: true)
      }
    }
  }
    
    @objc func didTapAppleButton() {

   
        if #available(iOS 13, *) {
            startSignInWithAppleFlow()
        } else {
            // Fallback on earlier versions
        }
        
       
      
    }
      
    
    
  
    func display(alertController: UIAlertController) {
      self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: Array<Character> =
          Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
          }
          return random
        }

        randoms.forEach { random in
          if length == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    // Unhashed nonce.
    fileprivate var currentNonce: String?

    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
      let nonce = randomNonceString()
      currentNonce = nonce
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      request.nonce = sha256(nonce)

      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
   
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    
    
    
    
  }
  
  extension ATCClassicLoginScreenViewController {
    
    func showPopup(isSuccess: Bool) {
       
        
        if isSuccess{
             let rootVC = BrowseProductsViewController()
             let navigationController = UINavigationController(rootViewController: rootVC)
             let window = UIWindow(frame: UIScreen.main.bounds)
             window.rootViewController = navigationController;
             window.makeKeyAndVisible()
             self.window = window
        }else{
          let successMessage = "User was sucessfully logged in."
          let errorMessage = "Something went wrong. Please try again"
          let alert = UIAlertController(title: isSuccess ? "Success": "Error", message: isSuccess ? successMessage: errorMessage, preferredStyle: UIAlertController.Style.alert)
          alert.addAction(UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: nil))
          self.present(alert, animated: true, completion: nil)
            
        }
        
        
    }
}


@available(iOS 13.0, *)
extension ATCClassicLoginScreenViewController: ASAuthorizationControllerDelegate {

  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = currentNonce else {
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        return
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
      }
      // Initialize a Firebase credential.
      let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                idToken: idTokenString,
                                                rawNonce: nonce)
      // Sign in with Firebase.
      Auth.auth().signIn(with: credential) { (authResult, error) in
        if (error != nil) {
          // Error. If error.code == .MissingOrInvalidNonce, make sure
          // you're sending the SHA256-hashed nonce as a hex string with
          // your request to Apple.
            print(error?.localizedDescription)
          return
        }
        // User is signed in to Firebase with Apple.
        // ...
      }
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    print("Sign in with Apple errored: \(error)")
  }

}
