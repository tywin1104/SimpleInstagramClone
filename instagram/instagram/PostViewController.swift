 //
//  PostViewController.swift
//  instagram
//
//  Created by Tianyi Zhang on 2018-01-06.
//  Copyright © 2018 Tianyi Zhang. All rights reserved.
//

import UIKit
import Parse
 
class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageToPost: UIImageView!
    @IBOutlet weak var comment: UITextField!
    func displayAlert(_ title: String, _ message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func postImage(_ sender: Any) {
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        activityIndicator.center = self.view.center
        
        activityIndicator.hidesWhenStopped = true
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        if let image = imageToPost.image {
            let post = PFObject(className:"Post")
            post["message"] = comment.text
            post["userid"] = PFUser.current()?.objectId
            
            if let imageData = UIImagePNGRepresentation(image) {
                let imageFile = PFFile(name: "image.png", data: imageData)
                post["imageFile"] = imageFile
                post.saveInBackground(block: {
                    (success, error) in
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if success {
                        self.displayAlert("Image posted", "your image has been posted successfully!")
                        self.comment.text = ""
                        self.imageToPost.image = nil
                    }else {
                        self.displayAlert("image upload failed", "please check again")
                    }
                    
                })
            }
            
            
        }
       
        
    }
    @IBAction func chooseImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageToPost.image  = image
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
