//
//  LoginViewController.swift
//  CheckInPlus
//
//  Created by Mark Townsend on 12/10/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//

import UIKit
import AuthenticationServices
import KeychainAccess
import os

final class LoginViewController: UIViewController {

  private let keychain = Keychain(service: Keychain.serviceID)

  override func viewDidLoad() {
    super.viewDidLoad()
    setupSigninWithAppleID()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    performExistingAccountSetupFlow()
  }
}

// MARK: - ASAuthorizationcontrollerDelegate
extension LoginViewController: ASAuthorizationControllerDelegate {
  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {

      let userIdentifier = appleIDCredential.user
      keychain[Keychain.userIdentifierKey] = userIdentifier
    } else if let passwordCredential = authorization.credential as? ASPasswordCredential {

      print("Get credential from keychain for \(passwordCredential.user)")
    }
    dismiss(animated: true, completion: nil)
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    os_log("Error logging in: %s", log: OSLog.default, type: .error, error.localizedDescription)
  }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
  }
}

// MARK: - Private Functions
private extension LoginViewController {
  func setupSigninWithAppleID() {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 25.0

    let titleLabel = UILabel()
    titleLabel.font = .systemFont(ofSize: 25)
    titleLabel.text = NSLocalizedString("CheckIn Plus", comment: "")
    titleLabel.sizeToFit()
    
    let authButton = ASAuthorizationAppleIDButton()
    authButton.addTarget(self, action: #selector(authButtonPressed), for: .touchUpInside)

    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(authButton)

    stackView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
    ])
  }

  @objc
  func authButtonPressed() {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName]

    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
  }

  func performExistingAccountSetupFlow() {
    let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                    ASAuthorizationPasswordProvider().createRequest()]

    let authController = ASAuthorizationController(authorizationRequests: requests)
    authController.delegate = self
    authController.presentationContextProvider = self
    authController.performRequests()
  }
}
