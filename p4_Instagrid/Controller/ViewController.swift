//
//  ViewController.swift
//  p4_Instagrid
//
//  Created by Cristian Rojas on 18/08/2020.
//  Copyright © 2020 Cristian Rojas. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet var layoutCollection: [UIButton]!
    @IBOutlet var gridButtonCollection: [GridButton]!
    @IBOutlet weak var gridView: UIView!
    @IBOutlet weak var swipeLabel: UILabel!
    
    private let selectedCheckboxImage = UIImage(named: "Selected")
    private var imagePicker = UIImagePickerController()
    
    /// Retrieves the pressed button. Useful for changing it's image with the image picker delegate methods
    private var pressedGridButton: GridButton!
    
    /// Retrieves one of the three selected layotus
    private var selectedLayout: Int = 2
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSwipeGestures()
        setSwipeLabelOnLaunch()
        
    }
    
    /// Changes swipelabel text on rotation
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        swipeLabel.text = fromInterfaceOrientation.isLandscape ? "Swipe up to share" : "Swipe left to share"
    }
    
    /// Allows user to pick an image for the grid by using the imagePicker
    @IBAction func gridButtonPressed(_ sender: UIButton) {
        if let sender = sender as? GridButton {
            pressedGridButton = sender
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)
        }
    }
    
    /// Allows user to chose the layout
    @IBAction func layoutButtonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            selectedLayout = 1
            hideButton(with: 1, sender: sender)
        case 2:
            selectedLayout = 2
            hideButton(with: 3, sender: sender)
        case 3:
            selectedLayout = 3
            clearLayoutButtons()
            clearGridButtons()
            sender.setImage(selectedCheckboxImage, for: .normal)
        default:
            break
        }
    }
}

// MARK: Private methods
private extension ViewController {
    
    func setSwipeGestures() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(shareOnSwipe(_:)))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(shareOnSwipe(_:)))
        
        swipeUp.direction = .up
        swipeLeft.direction = .left
        
        view.addGestureRecognizer(swipeUp)
        view.addGestureRecognizer(swipeLeft)
    }
    
    /// Creates an activity controller on swipe left or up
    @objc func shareOnSwipe(_ sender: UISwipeGestureRecognizer) {
        switch selectedLayout {
        case 1, 2:
            itemsWithPicture() == 3 ? sharerActivityController(sender: sender) : emptyItemsAlert(sender: sender)
        case 3:
            itemsWithPicture() == 4 ? sharerActivityController(sender: sender) : emptyItemsAlert(sender: sender)
        default:
            break
        }
    }
    
    /// Changes swipe label text if the app is launched in landscape mode
    private func setSwipeLabelOnLaunch() {
        let orientation = UIApplication.shared.statusBarOrientation
        if orientation.isLandscape {
            swipeLabel.text = "Swipe left to share"
        }
    }
    
    /// Returns the number of items of the grid that have a picture (UIButton.backgroundImage != nil)
    func itemsWithPicture() -> Int {
        var buttonsWithBackground = [GridButton]()
        gridButtonCollection.forEach {
            if $0.backgroundImage(for: .normal) != nil {
                buttonsWithBackground.append($0)
            }
            
        }
        return buttonsWithBackground.count
    }
    
    /// Presents an activity controller that allows the user to share a picture of the grid collage
    func sharerActivityController(sender: UISwipeGestureRecognizer) {
        guard let image = gridView.asImage()
        else { return }
        
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        
        presentView(sender: sender, view: activityController)
    }
    
    /// Presents an alert controller if there are empty items of the grid (no picture provided by the user)
    func emptyItemsAlert(sender: UISwipeGestureRecognizer) {
        let alert = UIAlertController(title: "Empty items", message: "Some of the the grid items haven't a picture yet. Please provide a picture for all the items", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        presentView(sender: sender, view: alert)
    }
    
    private func presentView(sender: UISwipeGestureRecognizer, view: UIViewController) {
        let orientation = UIApplication.shared.statusBarOrientation
        if sender.direction == .up && orientation.isPortrait {
            self.present(view, animated: true)
        } else if sender.direction == .left && orientation.isLandscape {
            self.present(view, animated: true)
        }
    }
    
    /// Clear checkbox image every time user changes layout
    func clearLayoutButtons() {
        layoutCollection.forEach {
            $0.setImage(nil, for: .normal)
        }
    }
    
    /// Clears grid button image every time user changes layout
    func clearGridButtons() {
        gridButtonCollection.forEach {
            $0.setImage(UIImage(named: "Combined Shape"), for: .normal)
            $0.setBackgroundImage(nil, for: .normal)
            $0.isHidden = false
        }
    }
    
    /// Hides a buttton on the grid in order to adapt to the selected layout
    func hideButton(with tag: Int, sender: UIButton) {
        clearLayoutButtons()
        clearGridButtons()
        
        sender.setImage(selectedCheckboxImage, for: .normal)
        
        gridButtonCollection.forEach {
            if $0.tag == tag {
                $0.isHidden = true
            }
        }
    }
}

// MARK: UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        pressedGridButton.setPicture(backgroundImage: image)
        pressedGridButton.layoutIfNeeded()
        pressedGridButton.subviews.first?.contentMode = .scaleAspectFill
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


