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
    func showBikeList(bikeUser: BikeUser) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BikeListViewController") as! BikeListViewController
        vc.bikeUser = bikeUser
        self.show(vc, sender: nil)
    }

    //MARK: - Database
    func userIsAlreadyRegistered() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        self.ref.child("Users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            let user: BikeUser
            if let value = snapshot.value as? NSDictionary,
                let name = value["fullname"] as? String,
                let email = value["email"] as? String {
                let bikes: [Bike]?
                if let dictBikes = value["bikes"] as? [String:Any] {
                    bikes = self.getBikes(bikes:  dictBikes)
                } else { bikes = nil }
                user = BikeUser(userId: userID ,name: name, email: email, bikes: bikes)
            } else if let name = Auth.auth().currentUser?.displayName,
                let email = Auth.auth().currentUser?.email {
                user = BikeUser(userId: userID ,name: name, email: email, bikes: nil)
                self.userRegister(bikeUser: user)
            } else { return }
            DispatchQueue.main.async {
                self.showBikeList(bikeUser: user)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getBikes(bikes: [String:Any]) -> [Bike] {
        var bikesArray:[Bike] = Array()
        for bike in bikes {
            let attributes = bike.value as! Dictionary<String, String>
            print(attributes)
            let idSecure = attributes["id_device"] ?? ""
            let brandmark = attributes["brand"] ?? ""
            let color = attributes["color"] ?? ""
            let bike = Bike(idBike: bike.key, idSecure: idSecure, brandmark: brandmark, color: color)
            bikesArray.append(bike)
        }
        return bikesArray
    }
    
    func userRegister(bikeUser: BikeUser) {
        self.ref.child("Users").child(bikeUser.userId).setValue(["fullname": bikeUser.name,
                                                                 "email" : bikeUser.email])
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
