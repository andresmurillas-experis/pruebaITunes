//
//  SettingsViewController.swift
//  PruebaItunes
//
//  Created by Andrés Murillas on 10/7/23.
//

import Foundation
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
        scrollView.backgroundColor = .blue
        
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 25).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        stackView.backgroundColor = .green
        
        stackView.addArrangedSubview({
            let imageView = UIImageView(image: UIImage(systemName: "paperplane"))
            imageView.contentMode = .scaleAspectFit
            return imageView
        }())
        stackView.addArrangedSubview({
            let textView = UITextView()
            textView.heightAnchor.constraint(equalToConstant: 30).isActive = true
            textView.text = "hello"
            return textView
        }())
    }
}
