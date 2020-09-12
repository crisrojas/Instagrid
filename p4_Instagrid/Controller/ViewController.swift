//
//  ViewController.swift
//  p4_Instagrid
//
//  Created by Cristian Rojas on 18/08/2020.
//  Copyright © 2020 Cristian Rojas. All rights reserved.
//

import UIKit

//todo: refactor
class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet var layoutCollection: [UIButton]!
    @IBOutlet var GridButtonCollection: [GridButton]!
    @IBOutlet weak var gridView: UIView!
    @IBOutlet weak var swipeLabel: UILabel!
    
    let selectedImage = UIImage(named: "Selected")
    var imagePicker = UIImagePickerController()
    var pressedGridButton: GridButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(shareOnSwipeUp(_:)))
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(shareOnSwipeUp(_:)))
        view.addGestureRecognizer(swipeUp)
        view.addGestureRecognizer(swipeLeft)
        swipeUp.direction = .up
        swipeLeft.direction = .left
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if fromInterfaceOrientation.isLandscape {
            swipeLabel.text = "Swipe left to share"
        } else {
            swipeLabel.text = "Swipe up to share"
        }
    }
    @objc func shareOnSwipeUp(_ sender: UISwipeGestureRecognizer) {
        guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else { return }
        let image = gridView.asImage()
        let ac = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        //todo: Fix [sharesheet] connection invalidated error ?
        ac.isModalInPresentation = true
        if sender.direction == .up && orientation.isPortrait {
            present(ac, animated: true)
        } else if sender.direction == .left && orientation.isLandscape {
             present(ac, animated: true)
        }
    }
    
    @IBAction func gridButtonPressed(_ sender: UIButton) {
        if let sender = sender as? GridButton {
            pressedGridButton = sender
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func layoutButtonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            hideButton(with: 1, sender: sender)
        case 2:
            hideButton(with: 3, sender: sender)
        case 3:
            resetLayout()
            clearLayoutButton()
            sender.setImage(selectedImage, for: .normal)
        default:
            break
        }
    }
    
    func clearLayoutButton() {
        for button in layoutCollection {
            button.setImage(nil, for: .normal)
        }
    }
    func hideButton(with tag: Int, sender: UIButton) {
        clearLayoutButton()
        resetLayout()
        sender.setImage(selectedImage, for: .normal)
        for button in GridButtonCollection {
            if button.tag == tag {
                button.isHidden = true
            }
        }
    }
    func resetLayout() {
        for button in GridButtonCollection {
            if button.isHidden {
                button.isHidden = false
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


