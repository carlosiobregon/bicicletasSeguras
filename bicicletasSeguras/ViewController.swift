//
//  ViewController.swift
//  bicicletasSeguras
//
//  Created by Carlos Obregón on 6/23/20.
//  Copyright © 2020 Carlos Obregón. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {
    
    @IBOutlet weak var appNameLabel: UILabel!
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        /*if let token = AccessToken.current, !token.isExpired {
            // User is logged in, do work such as go to next view controller.
        } else {*/
            let loginButton = FBLoginButton()
            loginButton.delegate = self
            loginButton.permissions = ["public_profile", "email"]
            loginButton.center = view.center
        loginButton.frame = CGRect(x: 32, y:appNameLabel.frame.origin.y + 80 , width: view.frame.size.width - 64, height: 52)
            view.addSubview(loginButton)
            // Do any additional setup after loading the view.
        //}
    }
    

    // Swift // // Extend the code sample from 6a. Add Facebook Login to Your Code // Add to your viewDidLoad method: loginButton.permissions = ["public_profile", "email"]
    
}

extension ViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
          print(error.localizedDescription)
          return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        print(credential)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                let authError = error as NSError
                if (/*isMFAEnabled &&*/ authError.code == AuthErrorCode.secondFactorRequired.rawValue) {
                    // The user is a multi-factor user. Second factor challenge is required.
                    let resolver = authError.userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
                    var displayNameString = ""
                    for tmpFactorInfo in (resolver.hints) {
                        displayNameString += tmpFactorInfo.displayName ?? ""
                        displayNameString += " "
                    }
                    /*self.showTextInputPrompt(withMessage: "Select factor to sign in\n\(displayNameString)", completionBlock: { userPressedOK, displayName in
                        var selectedHint: PhoneMultiFactorInfo?
                        for tmpFactorInfo in resolver.hints {
                            if (displayName == tmpFactorInfo.displayName) {
                                selectedHint = tmpFactorInfo as? PhoneMultiFactorInfo
                            }
                        }
                        PhoneAuthProvider.provider().verifyPhoneNumber(with: selectedHint!, uiDelegate: nil, multiFactorSession: resolver.session) { verificationID, error in
                            if error != nil {
                                print("Multi factor start sign in failed. Error: \(error.debugDescription)")
                            } else {
                                self.showTextInputPrompt(withMessage: "Verification code for \(selectedHint?.displayName ?? "")", completionBlock: { userPressedOK, verificationCode in
                                    let credential: PhoneAuthCredential? = PhoneAuthProvider.provider().credential(withVerificationID: verificationID!, verificationCode: verificationCode!)
                                    let assertion: MultiFactorAssertion? = PhoneMultiFactorGenerator.assertion(with: credential!)
                                    resolver.resolveSignIn(with: assertion!) { authResult, error in
                                        if error != nil {
                                            print("Multi factor finanlize sign in failed. Error: \(error.debugDescription)")
                                        } else {
                                            self.navigationController?.popViewController(animated: true)
                                        }
                                    }
                                })
                            }
                        }
                    })*/
                } else {
                    //self.showMessagePrompt(error.localizedDescription)
                    return
                }
                // ...
                return
            }
            // User is signed in
            // ...
            //Como obtengo la información de la autenticación
            print("User is signed in")
            let userID = Auth.auth().currentUser?.uid
            /*let name = Auth.auth().currentUser?.displayName
            let other = Auth.auth().currentUser?.metadata
            let correo = Auth.auth().currentUser?.email
            self.ref.child("users").child(userID ?? "").setValue(["username": name ?? "anonimo", "others":[other], "correo" : correo ?? "noRegistra"])*/
            
            
            self.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
              //Si existe, configure perfil
                guard let value = snapshot.value as? NSDictionary else {
                    let name = Auth.auth().currentUser?.displayName
                    let other = Auth.auth().currentUser?.metadata
                    let correo = Auth.auth().currentUser?.email
                    self.ref.child("users").child(userID ?? "").setValue(["username": name ?? "anonimo", "correo" : correo ?? "noRegistra"])
                    
                    return
                }
                
                print(value)
              // ...
              }) { (error) in
                //registre usuario
                print(error.localizedDescription)
            }
            
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print(loginButton.description)
    }
    
    
}
