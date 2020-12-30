//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Cassey Shao on 2020-12-19.
//  Copyright © 2020 Cassey Shao. All rights reserved.
//

import UIKit
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Mark: Properties
    @IBOutlet weak var nameTextField: UITextField!
    /*@IBOutlet weak var mealNameLabel: UILabel!*/
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem! // to identify the Save button
    
    /*
     This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new meal.
     */
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Handle the text field's user input through delegate callbacks.
        // self refers to ViewController class because it is referenced inside scope of ViewController class
        nameTextField.delegate = self
        
        // Set up views if editing an existing Meal.
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text   = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Mark: UITextFieldDelegate
    
    // resign first responder status
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    // read info in text field and change value of label to that info
    func textFieldDidEndEditing(_ textField: UITextField) {
        /*mealNameLabel.text = textField.text*/
        
        // check if the text field has text in it->enable Save button if it does
        updateSaveButtonState()
        
        // set title of the scene to that text
        navigationItem.title = textField.text
    }
    
    // called when an editing session begins or when keyboard gets displayed
    // disables the Save button while the user is editing the text field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    //Mark: UIImagePickerControllerDelegate
    
    // called when user taps the image picker's Cancel button
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    // called when a user selects a photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the image picker.
        dismiss(animated: true, completion: nil)
    }
    
    //Mark: Navigation
    // to indicate method related to navigation flow of the app
    
    // cancel a new meal addition
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode { // adding a new meal
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController { // editing a meal
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    
    //Mark: Actions
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        // executed on an implicit self object
        present(imagePickerController, animated: true, completion: nil)
    }
    
    /*@IBAction func setDefaultLabelText(_ sender: UIButton) {
        mealNameLabel.text = "Default Text"
    }*/
    
    //Mark: Private Methods
    
    // helper method to disable the Save button if the text field is empty
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }

}

