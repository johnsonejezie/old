//
//  AddStaffViewController.swift
//  MediBand
//
//  Created by Johnson Ejezie on 7/7/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
import SwiftValidator
import SwiftSpinner


protocol addStaffControllerDelegate: class {
    func addStaffViewController(controller: AddStaffViewController,
        finishedAddingStaff staff: Staff)
}

class AddStaffViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ValidationDelegate, UITextFieldDelegate, popUpTableViewControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    weak var delegate: addStaffControllerDelegate!
    let validator = Validator()
    let constant = Contants()
    var recognizer:UITapGestureRecognizer!
    
    var roleID = ""
    var specialistID = ""
    
    @IBOutlet var roleView: UIView!
    //
    
    @IBOutlet var specialityView: UIView!
    @IBOutlet var navBar: UIBarButtonItem!
    var tap:UITapGestureRecognizer!
    var roleTap:UITapGestureRecognizer!
    
    var imagePicker = UIImagePickerController()
    var isUpdatingStaff = false
    var staff = Staff()
    var staffImage:UIImage?
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var staffImageView: UIImageView!
    
    @IBOutlet weak var editPicButton: UIButton!
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var generalPracIDTextView: UITextField!
    @IBOutlet var roleIDTextView: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var specialityTextField: UITextField!
    @IBOutlet weak var staffID: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBAction func editButtonAction(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            println("Button capture")
            
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func saveButtonAction(sender: AnyObject) {
        validator.validate(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if isUpdatingStaff == true {
            
            let array:[String] = constant.role as! [String]
            if let i = find(array, staff.role) {
                println("Jason is at index \(i)")
                let index = i + 1
                self.roleID = String(index)
            } else {
                println("Jason isn't in the array")
            }
            
            let array1:[String] = constant.specialist as! [String]
            if let i = find(array1, staff.speciality) {
                println("Jason is at index \(i)")
                let index = i + 1
                self.specialistID = String(index)
            } else {
                println("Jason isn't in the array")
            }
            
            
            firstNameTextField.text = staff.firstname
            lastNameTextField.text = staff.surname
            emailTextField.text = staff.email
            roleIDTextView.text = staff.role
            generalPracIDTextView.text = staff.general_practional_id
            specialityTextField.text = staff.speciality
            staffID.text = staff.member_id
            if staff.image != "" {
                let URL = NSURL(string: staff.image)!
                staffImageView.hnk_setImageFromURL(URL)
            }else {
                staffImageView.image = UIImage(named: "defaultImage")
            }
        }
        
        firstNameTextField.delegate = self
        emailTextField.delegate = self
        roleIDTextView.delegate = self
        generalPracIDTextView.delegate = self
        lastNameTextField.delegate = self
        specialityTextField.delegate = self
        staffID.delegate = self
        
        validator.styleTransformers(success:{ (validationRule) -> Void in
            // clear error label
            validationRule.errorLabel?.hidden = true
            validationRule.errorLabel?.text = ""
            validationRule.textField.layer.borderColor = UIColor.greenColor().CGColor
            validationRule.textField.layer.borderWidth = 0.5
            
            }, error:{ (validationError) -> Void in
                println("error")
                validationError.errorLabel?.hidden = false
                validationError.errorLabel?.text = validationError.errorMessage
                validationError.textField.layer.borderColor = UIColor.redColor().CGColor
                validationError.textField.layer.borderWidth = 1.0
        })
        
        
        
        validator.registerField(firstNameTextField, rules: [RequiredRule(), FullNameRule()])
        validator.registerField(lastNameTextField, rules: [RequiredRule(), FullNameRule()])
        validator.registerField(specialityTextField, rules: [RequiredRule(), FullNameRule()])
        validator.registerField(emailTextField, rules: [RequiredRule(), EmailRule()])
        validator.registerField(generalPracIDTextView, rules: [RequiredRule(), FullNameRule()])
        //        validator.registerField(roleIDTextView, rules: [RequiredRule(), FullNameRule()])
        validator.registerField(staffID, rules: [RequiredRule(), FullNameRule()])
        
        
        
        navBar.target = self.revealViewController()
        navBar.action = Selector("revealToggle:")
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        recognizer = UITapGestureRecognizer(target: self, action: "popUp:")
        recognizer.cancelsTouchesInView = false
        specialityView.addGestureRecognizer(recognizer)
        
        roleTap = UITapGestureRecognizer(target: self, action: "popUp:")
        roleView.addGestureRecognizer(roleTap)
        
        tap = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        firstNameTextField.layer.cornerRadius = 5
        emailTextField.layer.cornerRadius = 5
        roleView.layer.cornerRadius = 5
        
        roleIDTextView.layer.cornerRadius = 5
        generalPracIDTextView.layer.cornerRadius = 5
        lastNameTextField.layer.cornerRadius = 5
        specialityView.layer.cornerRadius = 5
        
        specialityTextField.layer.cornerRadius = 5
        staffID.layer.cornerRadius = 5
        
        firstNameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        lastNameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        specialityTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        emailTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        generalPracIDTextView.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        roleIDTextView.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        staffID.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        
        
        
        saveButton.layer.cornerRadius = 4
        
        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        
        
    }
    
    func popUp(sender:UITapGestureRecognizer) {
        if sender.view == self.roleView {
            self.displayPopOver(roleView)
        }else {
            self.displayPopOver(self.specialityView)
        }
    }
    
    
    func displayPopOver(sender: UIView){
        
        let storyboard : UIStoryboard = UIStoryboard(name:"Main", bundle: nil)
        var contentViewController : PopUpTableViewController = storyboard.instantiateViewControllerWithIdentifier("PopUpTableViewController") as! PopUpTableViewController
        
        let height:CGFloat?
        
        if sender == self.roleView{
            contentViewController.list = constant.role
            height = 44 *  CGFloat(constant.role.count)
        }else {
            contentViewController.list = constant.specialist
            height = 44 *  CGFloat(constant.specialist.count)
        }
        
        contentViewController.delegate = self
        contentViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
        contentViewController.preferredContentSize = CGSizeMake(self.view.frame.size.width * 0.6, height!)
        var detailPopover: UIPopoverPresentationController = contentViewController.popoverPresentationController!
        detailPopover.sourceView = sender
        detailPopover.sourceRect.origin.x = 50
        detailPopover.permittedArrowDirections = UIPopoverArrowDirection.Any
        detailPopover.delegate = self
        presentViewController(contentViewController, animated: true, completion: nil)
        
    }
    
    func popUpTableViewControllerDidCancel(controller: PopUpTableViewController) {
        
    }
    
    func popUpTableViewController(controller: PopUpTableViewController, didSelectItem item: String, inRow: String, fromArray: [AnyObject]) {
        if fromArray[0] === self.constant.specialist[0] {
            self.specialityTextField.text = item
            self.specialistID = inRow
            println(inRow)
        }else {
            self.roleID = inRow
            println(inRow)
            roleIDTextView.text = item
        }
        
        
    }
    func popUpTableViewwController(controller: PopUpTableViewController, selectedStaffs staff: [Staff], withIDs ids: [String]) {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        setScreeName("Add staff")
    }
    
    override func viewWillLayoutSubviews() {
        staffImageView.layer.masksToBounds = false
        staffImageView.layer.cornerRadius = staffImageView.frame.size.width / 2
        staffImageView.clipsToBounds = true
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            println("done")
        })
        staffImageView.image = image
        self.staffImage = image
    }
    
    
    func handleSingleTap(sender:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    func validationFailed(errors: [UITextField : ValidationError]) {
        setErrors()
    }
    
    private func setErrors(){
        for (field, error) in validator.errors {
            field.layer.borderColor = UIColor.redColor().CGColor
            field.layer.borderWidth = 1.0
            error.errorLabel?.text = error.errorMessage
            error.errorLabel?.hidden = false
        }
    }
    
    func validationSuccessful() {
        // submit the form
        
        var message:String = ""
        if isUpdatingStaff == true {
            message = "Updating Staff"
        }else {
            message = "Creating Staff"
        }
        
        SwiftSpinner.show(message, animated: true)
        
        var firstname:String = firstNameTextField.text!
        var surname:String = lastNameTextField.text!
        var gpID:String = generalPracIDTextView.text!
        var specialityID:String = specialistID
        var member_id:String = staffID.text!
        var role_id:String = self.roleID
        var email:String = emailTextField.text!
        
        
        
        staff.medical_facility_id = sharedDataSingleton.user.medical_facility
        staff.speciality = specialityID
        staff.general_practional_id = gpID
        staff.member_id = member_id
        staff.role = role_id
        staff.email = email
        staff.surname=surname
        staff.firstname = firstname
        
        var staffMethods = StaffNetworkCall()
        staffMethods.create(staff, image: staffImage, isCreatingNewStaff: !isUpdatingStaff) { (success) -> Void in
            if success == true {
                SwiftSpinner.hide(completion: { () -> Void in
                    //                                self.delegate.addStaffViewController(self, finishedAddingStaff: self.staff)
                    let staffProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("StaffProfileViewController") as! StaffProfileViewController
                    self.navigationController?.pushViewController(staffProfileViewController, animated: true)
                })
            }else {
                SwiftSpinner.hide(completion: { () -> Void in
                    let alertView = SCLAlertView()
                    alertView.showError("Erro", subTitle: "An error occurred. Please try again later", closeButtonTitle: "Ok", duration: 200)
                    alertView.alertIsDismissed({ () -> Void in
                        
                    })
                })
                
            }
        }
        
        self.trackEvent("UX", action: "Create new staff", label: "Save button: create new staff", value: nil)
        
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle
    {
        return UIModalPresentationStyle.None
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= keyboardSize.height/2
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += keyboardSize.height/2
        }
    }
    
    
}

extension AddStaffViewController {
    
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





