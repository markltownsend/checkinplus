//
//  SceneDelegate.swift
//  CheckInPlus
//
//  Created by Mark Townsend on 10/19/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//

import UIKit
import SwiftUI
import AuthenticationServices
import KeychainAccess
import FoursquareAPI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  let fqManager = FoursquareAPIManager()
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    
    // Get the managed object context from the shared persistent container.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
    // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
    let contentView = CheckInVenueListView().environment(\.managedObjectContext, context)
    
    // Use a UIHostingController as window root view controller.
    if let windowScene = scene as? UIWindowScene {
      let window = UIWindow(windowScene: windowScene)
      window.rootViewController = UIHostingController(rootView: contentView)
      window.tintColor = .systemGreen
      self.window = window
      window.makeKeyAndVisible()
    }
    
    showLogin()
  }
  
  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
  }
  
  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }
  
  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }
  
  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }
  
  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
    
    // Save changes in the application's managed object context when the application transitions to the background.
    (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
  }
  
  func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
    if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
      fqManager.generateAuthToken(with: userActivity.webpageURL!, callbackURI: Constants.callbackURI) { (authToken, error) in
        if let token = authToken {
          self.fqManager.saveAuthToken(token)
        } else {
          print("No auth token")
        }
      }
    }
  }
}

// MARK: - Utility Functions
private extension SceneDelegate {
  func showLogin() {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    appleIDProvider.getCredentialState(forUserID: Keychain.currentUserIdentifier ?? "")
    { (credentialState, error) in
      switch credentialState {
      case .authorized:
        // Apple ID valid
        break
      case .revoked:
        fallthrough
      case .notFound:
        DispatchQueue.main.async {
          let loginViewController = LoginViewController()
          loginViewController.modalPresentationStyle = .formSheet
          loginViewController.isModalInPresentation = true
          self.window?.rootViewController?.present(loginViewController, animated: true, completion: nil)
        }
      default:
        break
      }
    }
  }
}
