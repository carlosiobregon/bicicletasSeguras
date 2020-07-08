//
//  PopUpViewController.swift
//  Copa Airlines
//
//  Created by Fredy Mauricio Navarrete Molano on 3/28/19.
//  Copyright © 2019 Copa Airlines. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    
//    MARK: - UI Elements
    @IBOutlet weak var popUpContainer: UIView! {
        didSet{
            popUpContainer.layer.cornerRadius = 24
            popUpContainer.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        willSet{
            if let it = newValue{
                
            }
        }
    }
    @IBOutlet weak var subtitleLabel: UILabel! {
        willSet{
            if let it = newValue{
                
            }
        }
    }
    @IBOutlet weak var header: UIStackView! {
        didSet {
            header.isAccessibilityElement = true
            
            header.accessibilityHint = .none
            header.accessibilityTraits = .staticText
        }
    }
    
    @IBOutlet weak var getNotificationsButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var topCloseButton: UIButton! {
        didSet {
            topCloseButton.isAccessibilityElement = false
            topCloseButton.accessibilityLabel = nil
            topCloseButton.accessibilityHint = nil
        }
    }
    
    @IBOutlet weak var phoneImageView: UIImageView! {
        didSet {
            phoneImageView.isAccessibilityElement = false
        }
    }
    
    @IBOutlet weak var notificationContentView: UIView! {
        didSet {
            notificationContentView.backgroundColor = UIColor.clear
            notificationContentView.isAccessibilityElement = false
        }
    }
    
    @IBOutlet weak var notificationTitleLabel: UILabel! {
        didSet {
            notificationTitleLabel.isAccessibilityElement = false
        }
    }
    
    @IBOutlet weak var notificationMessageLabel: UILabel! {
        didSet {
            notificationMessageLabel.isAccessibilityElement = false
        }
    }
    
//    MARK: - Atributes
    var mustShowNativeRequest: Bool!
    
//    MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAccessibility()
        setupInterface()
    }
    
    private func setupInterface() {
        
    }
    
//    MARK: - Actions
    @IBAction func onGetNotificationsClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func onCancelClick(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupAccessibility() {
        view.accessibilityViewIsModal = true
        UIAccessibility.post(notification: .screenChanged, argument: header)
    }
    
}
