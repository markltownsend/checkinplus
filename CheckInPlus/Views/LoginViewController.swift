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
        let alert = UIAlertController(title: NSLocalizedString("Authentication Error", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Dismiss", comment: ""), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
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
        let authButton = ASAuthorizationAppleIDButton()
        authButton.addTarget(self, action: #selector(authButtonPressed), for: .touchUpInside)
        authButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(authButton)
        authButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        authButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
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

// MARK: - Keychain extension that holds constants for the keychain
extension Keychain {
    static var serviceID: String {
        "com.checkinplus.service"
    }
    static var userIdentifierKey: String {
        "userIdentifier"
    }
    static var currentUserIdentifier: String? {
        do {
            return try Keychain(service: serviceID).get(userIdentifierKey)
        } catch {
            print("Error getting user identifier from keychain: \(error)")
            return nil
        }
    }
}
