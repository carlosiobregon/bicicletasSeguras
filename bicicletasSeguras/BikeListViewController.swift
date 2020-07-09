//
//  BikeListViewController.swift
//  bicicletasSeguras
//
//  Created by Carlos Obregón on 7/7/20.
//  Copyright © 2020 Carlos Obregón. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class BikeCell: UITableViewCell {
    @IBOutlet weak var trademarkLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var bikeImage: UIImage!
    
    static let height = CGFloat(90)
    
    //    MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class BikeListViewController: UIViewController {
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var bikeListTableView: UITableView!
    
    var ref: DatabaseReference!
    var bikeUser: BikeUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        bikeListTableView.tableFooterView = UIView(frame: .zero)
        bikeListTableView.delegate = self
        bikeListTableView.dataSource = self
        bikeListTableView.separatorColor = .lightGray
    }
    
    func loadData() {
        ref = Database.database().reference()
        if bikeUser == nil {
            getUser()
            return
        }
        setupView()
    }
    
    func getUser() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        self.ref.child("Users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary,
                let name = value["fullname"] as? String,
                let email = value["email"] as? String {
                
                let bikes: [Bike]?
                if let dictBikes = value["bikes"] as? [String:Any] {
                    bikes = self.getBikes(bikes: dictBikes)
                } else { bikes = nil }
                
                self.bikeUser = BikeUser(userId: userID ,name: name, email: email, bikes: bikes)
                DispatchQueue.main.async {
                    self.setupView()
                    self.bikeListTableView.reloadData()
                }
            }
        })
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

    func setupView() {
        if let bikes = self.bikeUser?.bikes,
            bikes.count > .zero {
            emptyView.isHidden = true
            bikeListTableView.isHidden = false
        } else {
            emptyView.isHidden = false
            bikeListTableView.isHidden = true
        }
    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bikelist_2_profile",
            let profileVC = segue.destination as? PopUpViewController {
            profileVC.bikeUser = bikeUser
        }
        if segue.identifier == "bikelist_2_addbike",
            let addBikeVC = segue.destination as? PopUpBikeViewController {
            addBikeVC.delegate = self
        }
        if segue.identifier == "bikelist_2_blockbike",
            let blockVC = segue.destination as? AlertBlockViewController,
            let bikeSender = sender as? Bike {
            blockVC.bike = bikeSender
            blockVC.delegate = self
        }
    }

}

//MARK: - UITableViewDelegate
extension BikeListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BikeCell.height;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BikeCell", for: indexPath)
            as! BikeCell
        guard let bike = bikeUser?.bikes?[indexPath.row] else { return cell }
        
        cell.trademarkLabel.text = bike.brandmark
        cell.colorLabel.text = bike.color
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let bike = self.bikeUser?.bikes?[indexPath.row] else {return}
        performSegue(withIdentifier: "bikelist_2_blockbike", sender: bike)
    }
}

//MARK: - UITableViewDataSource
extension BikeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = bikeUser?.bikes?.count else {
            emptyView.isHidden = false
            bikeListTableView.isHidden = true
            return .zero
        }
        return count
    }
    
    
}

//MARK: - PopUpBikeVC Delegate
extension BikeListViewController: PopUpBikeViewControllerDelegate {
    func onAlertBikeClick(bike: Bike) {
        self.ref.child("AlertSignals").child(bike.idBike).setValue(["id_device": bike.idSecure])
    }
    
    func onAddBikeClick(bike: Bike) {
        if bikeUser?.bikes != nil {
            bikeUser?.bikes?.append(bike)
        } else {
            bikeUser?.bikes = [bike]
        }
        guard let user = bikeUser else {return}
        self.ref.child("Users").child(user.userId).child("bikes").child(bike.idBike).setValue(["id_device": bike.idSecure, "brand": bike.brandmark, "color": bike.color])
        DispatchQueue.main.async {
            self.setupView()
            self.bikeListTableView.reloadData()
        }
    }
}
