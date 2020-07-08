//
//  LoginViewController.swift
//  bicicletasSeguras
//
//  Created by Carlos Obregón on 6/23/20.
//  Copyright © 2020 Carlos Obregón. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var appNameLabel: UILabel!
    var ref: DatabaseReference!

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createAuthButton()
        ref = Database.database().reference()
    }
    
    private func createAuthButton() {
        let loginButton = FBLoginButton()
        loginButton.delegate = self
        loginButton.permissions = ["public_profile", "email"]
        loginButton.center = view.center
        loginButton.frame = CGRect(x: 32, y:appNameLabel.frame.origin.y + 80 , width: view.frame.size.width - 64, height: 52)
        view.addSubview(loginButton)
    }
    
    
    //MARK: - Navegation
    func showBikeList() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "BikeListViewController") as! BikeListViewController
            self.show(vc, sender: nil)
        }
    }
    
    //MARK: - Auth Firebase
    func authFirebase() {
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                let authError = error as NSError
                if (authError.code == AuthErrorCode.secondFactorRequired.rawValue) {
                    let resolver = authError.userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
                    print(resolver)
                }
                return
            }
            self.userIsAlreadyRegistered()
        }
    }
    
    //MARK: - Database
    func userIsAlreadyRegistered() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        self.ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                // Almacenar
                print(value)
            } else {
                self.userRegister(userID: userID)
            }
            self.showBikeList()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func userRegister(userID: String) {
        let name = Auth.auth().currentUser?.displayName
        let correo = Auth.auth().currentUser?.email
        self.ref.child("users").child(userID).setValue(["username": name ?? "anonimo", "correo" : correo ?? "noRegistra"])
    }
       
}

extension LoginViewController: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error = error {
          print(error.localizedDescription)
          return
        }
        authFirebase()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print(loginButton.description)
    }

}
