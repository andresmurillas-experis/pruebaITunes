//
//  SettingsViewController.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 10/7/23.
//

import Foundation
import SwiftUI
import UIKit

public class SettingsViewController: UIViewController {
    let vm: SettingsViewModel
    lazy private var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    lazy private var stackView: UIStackView = {
        var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.contentMode = .scaleToFill
        return stackView
    }()
    lazy private var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.circle"))
        imageView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 100.0
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    init(vm: SettingsViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scrollView)

        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.addSubview(stackView)

        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 25).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        stackView.backgroundColor = .green

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        stackView.addArrangedSubview(imageView)
        imageView.addGestureRecognizer(tapGestureRecognizer)

        stackView.addArrangedSubview({
            let textView = UITextView()
            textView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            textView.text = "hello"
            return textView
        }())
    }
}

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        print("hello")
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        picker.dismiss(animated: true)
        imageView.image = image
    }
}
