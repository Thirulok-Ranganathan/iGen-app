//
//  ViewController.swift
//  ImageGenerator
//
//  Created by RITSJC-017 on 30/03/23.
//

import UIKit

class ViewController: UIViewController {
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "searching")
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()

    let promptTextField: UITextField={
       let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.cornerRadius = 10
        field.clipsToBounds = true
        field.backgroundColor = .systemGray6
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        field.returnKeyType = .done
        field.placeholder = "Enter text for Image generation"
        field.contentVerticalAlignment = .top
        return field
    }()
    
    lazy var submitButton:UIButton={
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Generate", for: .normal)
        button.backgroundColor = .systemMint
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(tapSubmit), for: .touchUpInside)
        return button
    }()
    
    let indicatorView = UIView()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(promptTextField)
        view.addSubview(submitButton)
        view.addSubview(indicatorView)
        indicatorView.isHidden = true
        indicatorView.frame = view.bounds
        indicatorView.backgroundColor = .systemGray6
        indicatorView.alpha = 0.95
        indicatorView.addSubview(activityIndicator)
        activityIndicator.center = view.center
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 350),
            imageView.heightAnchor.constraint(equalToConstant: 350),
            
            promptTextField.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            promptTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            promptTextField.widthAnchor.constraint(equalToConstant: 300),
            promptTextField.heightAnchor.constraint(equalToConstant: 80),
            
            submitButton.topAnchor.constraint(equalTo: promptTextField.bottomAnchor, constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 300),
            submitButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    private func fetchImageForprompt(gImage: String) {
        indicatorView.isHidden = false
        activityIndicator.startAnimating()
        Task {
            do {
                let image = try await APIService().fetchImageForPrompt(gImage)
                
                await MainActor.run {
                    indicatorView.isHidden = true
                    activityIndicator.stopAnimating()
                    imageView.image = image
                }
            } catch {
                indicatorView.isHidden = true 
                activityIndicator.stopAnimating()
                print("Errrrorrrr")
            }
            
        }
    }
    
    @objc func tapSubmit(){
        promptTextField.resignFirstResponder()
        if let GenImg=promptTextField.text, GenImg.count > 3{
            fetchImageForprompt(gImage: GenImg)
        }else {
            print("Check your words")
        }
    }
    
}

