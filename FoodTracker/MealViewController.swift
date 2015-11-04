//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Davy, Martin on 9/28/15.
//  Copyright © 2015 Mandi. All rights reserved.
//

import UIKit
import Photos

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    // MARK: Properties

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     *   This value is either passed by'MealTableViewController' in 'prepareForSegue(_:sender:)'
     *   or constructed as part of adding a new meal
     */
    
    var meal:Meal?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
       
        // Handle the text field's user input through delegate callbacks.
        nameTextField.delegate = self
        
        
        // Set up views if editing an existing Meal.
        if let meal = meal
        {
            navigationItem.title = meal.name
            nameTextField.text   = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        // Enable the Save buttone only if the text field has a valid meal name
        checkValidMealName()

    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        // Hide the Keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func checkValidMealName()
    {
        // Disable the Save button if the text field is empty
        let text = nameTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        checkValidMealName()
        navigationItem.title = textField.text
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        // The info dictionary contains mulitple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageUrl = info[UIImagePickerControllerReferenceURL] as! NSURL
        
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        updateImageMetaData(imageUrl)
        
        // Dismiss the picker
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func updateImageMetaData(imageUrl: NSURL)
    {
      
        
        let results = PHAsset.fetchAssetsWithALAssetURLs([imageUrl], options: nil)
        let count = results.count
        
        if count > 0
        {
            let asset = results[0] as! PHAsset
            let location = asset.location
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            let date = dateFormatter.stringFromDate(asset.creationDate!)
        
            //meal?.location =  location
            meal?.date = date

        }

    }
    
    
    // MARK: Navigation
    
    @IBAction func cancel(sender: UIBarButtonItem)
    {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode
        {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else
        {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if saveButton === sender
        {
            let name = nameTextField.text ?? ""
            let photo = photoImageView.image
            let rating = ratingControl.rating
            
            // Set the meail to be passed to MealTableViewController after the unwind segue
            
            meal = Meal(name: name, photo: photo, rating: rating)
        }
        
    }

    
    // MARK: Actions

    @IBAction func selectImageFromPhotoLibrary(sender: UITapGestureRecognizer)
    {
        // Hide the keyboard
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picke, not taken
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
  }

