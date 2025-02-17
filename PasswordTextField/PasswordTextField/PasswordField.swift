//
//  PasswordField.swift
//  PasswordTextField
//
//  Created by Ben Gohlke on 6/26/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

enum PasswordStrength: String {
    case empty
    case weak
    case medium
    case strong
}

class PasswordField: UIControl {
    
    // Public API - these properties are used to fetch the final password and strength values
    private (set) var password: String = ""
    private (set) var passwordStrength: PasswordStrength = .empty
    
    private let standardMargin: CGFloat = 8.0
    private let textFieldContainerHeight: CGFloat = 50.0
    private let textFieldMargin: CGFloat = 6.0
    private let colorViewSize: CGSize = CGSize(width: 60.0, height: 5.0)
    private let labelTextColor = UIColor(hue: 233.0/360.0, saturation: 16/100.0, brightness: 41/100.0, alpha: 1)
    private let labelFont = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
    private let textFieldBorderColor = UIColor(hue: 208/360.0, saturation: 80/100.0, brightness: 94/100.0, alpha: 1)
    private let bgColor = UIColor(hue: 0, saturation: 0, brightness: 97/100.0, alpha: 1)
    
    // States of the password strength indicators
    private let unusedColor = UIColor(hue: 210/360.0, saturation: 5/100.0, brightness: 86/100.0, alpha: 1)
    private let weakColor = UIColor(hue: 0/360, saturation: 60/100.0, brightness: 90/100.0, alpha: 1)
    private let mediumColor = UIColor(hue: 39/360.0, saturation: 60/100.0, brightness: 90/100.0, alpha: 1)
    private let strongColor = UIColor(hue: 132/360.0, saturation: 60/100.0, brightness: 75/100.0, alpha: 1)

    private var titleLabel: UILabel = UILabel()
    private var textField: UITextField = UITextField()
    private var showHideButton: UIButton = UIButton()
    private var weakView: UIView = UIView()
    private var mediumView: UIView = UIView()
    private var strongView: UIView = UIView()
    private var strengthDescriptionLabel: UILabel = UILabel()
    
    //MARK: - Initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
        textField.delegate = self
    }
    
    //MARK: - View Setup
    func setup() {
        
        //Create New UIView
        self.backgroundColor = bgColor
        self.layer.cornerRadius = 10.0
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor),
            self.heightAnchor.constraint(equalToConstant: 120.0)
        ])
        
        //Create UILabel's custom label
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = labelTextColor
        titleLabel.text = "ENTER PASSWORD"
        titleLabel.font = labelFont
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: standardMargin),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: standardMargin),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -standardMargin)
        ])
        
        //Create textField UITextField below the titleLabel
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        textField.placeholder = "PASSWORD"
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        textField.layer.borderColor = textFieldBorderColor.cgColor
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: textFieldMargin),
            textField.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -textFieldMargin),
            textField.heightAnchor.constraint(equalToConstant: textFieldContainerHeight)
        ])
        
        //Create showHideButton UIButton within textField view
        addSubview(showHideButton)
        showHideButton.translatesAutoresizingMaskIntoConstraints = false
        showHideButton.setImage(UIImage.init(named: "eyes-closed"), for: .normal)
        showHideButton.imageView?.contentMode = .left
        showHideButton.addTarget(self, action: #selector(showHideTapped), for: .touchUpInside)
        textField.rightView = showHideButton
        textField.rightViewMode = .always
        NSLayoutConstraint.activate([
            showHideButton.heightAnchor.constraint(equalTo: textField.heightAnchor, multiplier: 0.9),
            showHideButton.widthAnchor.constraint(equalToConstant: 40.0)
        ])
        
        //Create password strength indicator
        addSubview(weakView)
        addSubview(mediumView)
        addSubview(strongView)
        addSubview(strengthDescriptionLabel)
        
        weakView.translatesAutoresizingMaskIntoConstraints = false
        mediumView.translatesAutoresizingMaskIntoConstraints = false
        strongView.translatesAutoresizingMaskIntoConstraints = false
        strengthDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        strengthDescriptionLabel.font = labelFont
        strengthDescriptionLabel.textColor = labelTextColor
        
        weakView.backgroundColor = unusedColor
        mediumView.backgroundColor = unusedColor
        strongView.backgroundColor = unusedColor
        
        weakView.layer.cornerRadius = colorViewSize.height / 2
        mediumView.layer.cornerRadius = colorViewSize.height / 2
        strongView.layer.cornerRadius = colorViewSize.height / 2
        
        NSLayoutConstraint.activate([
            //weakView Constraints
            weakView.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: standardMargin * 2),
            weakView.leadingAnchor.constraint(equalTo: self.textField.leadingAnchor),
            weakView.widthAnchor.constraint(equalToConstant: self.colorViewSize.width),
            weakView.heightAnchor.constraint(equalToConstant: self.colorViewSize.height),
            
            //mediumView Constraints
            mediumView.topAnchor.constraint(equalTo: self.weakView.topAnchor),
            mediumView.leadingAnchor.constraint(equalTo: self.weakView.trailingAnchor, constant: standardMargin / 2),
            mediumView.widthAnchor.constraint(equalToConstant: self.colorViewSize.width),
            mediumView.heightAnchor.constraint(equalToConstant: self.colorViewSize.height),
            
            //strongView Constraints
            strongView.topAnchor.constraint(equalTo: self.weakView.topAnchor),
            strongView.leadingAnchor.constraint(equalTo: self.mediumView.trailingAnchor, constant: standardMargin / 2),
            strongView.widthAnchor.constraint(equalToConstant: self.colorViewSize.width),
            strongView.heightAnchor.constraint(equalToConstant: self.colorViewSize.height),
            
            //strengthDescriptionLabel Constraints
            strengthDescriptionLabel.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: standardMargin),
            strengthDescriptionLabel.leadingAnchor.constraint(equalTo: self.strongView.trailingAnchor, constant: standardMargin),
            strengthDescriptionLabel.trailingAnchor.constraint(equalTo: self.textField.trailingAnchor)
        ])
        
    }
    
    
    //MARK: - Private Functions
    
    //Function to control showHideButton
    @objc private func showHideTapped() {
        textField.isSecureTextEntry.toggle()
        
        if textField.isSecureTextEntry {
            showHideButton.setImage(UIImage(named: "eyes-closed"), for: .normal)
        } else {
            showHideButton.setImage(UIImage(named: "eyes-open"), for: .normal)
        }
    }
    
    //Function to update password strength indicators
    private func evaluatePassword(for string: String) {
        
        if string.isEmpty {
            passwordStrength = .empty
            weakView.backgroundColor = unusedColor
            mediumView.backgroundColor = unusedColor
            strongView.backgroundColor = unusedColor
            strengthDescriptionLabel.text = ""
        }
        
        switch string.count {
        case 0:
            passwordStrength = .empty
            weakView.backgroundColor = unusedColor
            mediumView.backgroundColor = unusedColor
            strongView.backgroundColor = unusedColor
            strengthDescriptionLabel.text = ""
            
        case 1...7:
            passwordStrength = .weak
            if weakView.backgroundColor != weakColor {
                weakView.transform = CGAffineTransform(scaleX: 1.0, y: 2)
                UIView.animate(withDuration: 0.4) {
                    self.weakView.transform = .identity
                }
            }
            weakView.backgroundColor = weakColor
            mediumView.backgroundColor = unusedColor
            strongView.backgroundColor = unusedColor
            strengthDescriptionLabel.text = "Too Weak"
            
        case 8...15:
            passwordStrength = .medium
            if mediumView.backgroundColor != mediumColor {
                mediumView.transform = CGAffineTransform(scaleX: 1.0, y: 2)
                UIView.animate(withDuration: 0.4) {
                    self.mediumView.transform = .identity
                }
            }
            weakView.backgroundColor = weakColor
            mediumView.backgroundColor = mediumColor
            strongView.backgroundColor = unusedColor
            strengthDescriptionLabel.text = "Could Be Stronger"
            
        default:
            passwordStrength = .strong
            if strongView.backgroundColor != strongColor {
                strongView.transform = CGAffineTransform(scaleX: 1.0, y: 2)
                UIView.animate(withDuration: 0.4) {
                    self.strongView.transform = .identity
                }
            }
            weakView.backgroundColor = weakColor
            mediumView.backgroundColor = mediumColor
            strongView.backgroundColor = strongColor
            strengthDescriptionLabel.text = "Strong Password"
            
        }
    }
}


//MARK: - Extensions

extension PasswordField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        evaluatePassword(for: newText)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let password = textField.text, !password.isEmpty {
            self.password = password
            sendActions(for: .valueChanged)
        }
        return true
    }
}
