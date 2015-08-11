//
//  StaffProfileViewController.swift
//  MediBand
//
//  Created by Kehinde Shittu on 7/7/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit

class StaffProfileViewController: UIViewController, ENSideMenuDelegate {
    
    
    @IBOutlet weak var staffImageView: UIImageView!
    @IBOutlet weak var staffNameLabel: UILabel!
    
    @IBOutlet weak var staffIDLabel: UILabel!
    @IBOutlet weak var specialityLabel: UILabel!
    @IBOutlet weak var generlPracticeLabel: UILabel!
    @IBOutlet weak var generalPractitionerIDLabel: UILabel!
    var staff = Staff()
    
    
    @IBAction func slideMenuToggle(sender: UIBarButtonItem) {
        toggleSideMenuView()
    }
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        return true
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.sideMenuController()?.sideMenu?.delegate = self
        
//        let imageData:NSData = NSData(base64EncodedString: staff["staffImage"]!, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
//        staffImageView.image = UIImage(data: imageData)
//        staffIDLabel.text = staff["staffID"]
//        staffNameLabel.text = staff["name"]
//        generalPractitionerIDLabel.text = staff["generalPractitionerID"]
//        generlPracticeLabel.text = staff["generalPracticeID"]
//        specialityLabel.text = staff["speciality"]

    }
    
    override func viewWillAppear(animated: Bool) {
        self.setScreeName("Staff Profile")
    }
    
    override func viewDidLayoutSubviews() {
        staffImageView.clipsToBounds = true
        staffImageView.layer.cornerRadius = staffImageView.frame.size.height/2
    }
    
    
    @IBAction func viewHistory(sender: UIButton) {
        
        self.trackEvent("UX", action:"View Staff History" , label: "Staff history button", value: nil)
    }
    
    
    
}

extension StaffProfileViewController {
    
    func setScreeName(name: String) {
        self.title = name
        self.sendScreenView(name)
    }
    
    func sendScreenView(screenName: String) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: self.title)
        let build = GAIDictionaryBuilder.createScreenView().set(screenName, forKey: kGAIScreenName).build() as NSDictionary
        
        tracker.send(build as [NSObject: AnyObject])
    }
    
    func trackEvent(category: String, action: String, label: String, value: NSNumber?) {
        let tracker = GAI.sharedInstance().defaultTracker
        let trackDictionary = GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: value).build()
        tracker.send(trackDictionary as [NSObject: AnyObject])
    }
    
}
