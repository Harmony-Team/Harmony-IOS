//
//  ServicesViewController.swift
//  Harmony
//
//  Created by Macbook Pro on 04.02.2021.
//

import UIKit
import VK_ios_sdk
import ok_ios_sdk

class ServicesViewController: UIViewController, VKSdkDelegate, VKSdkUIDelegate {

    var viewModel: ServicesViewModel!
    let vk_app_id = "7750806"
    var sdkInstance: VKSdk?
    var scope = ["email", "photos", "offline"]
    var okScope = ["VALUABLE_ACCESS", "LONG_ACCESS_TOKEN", "PHOTO_CONTENT"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sdkInstance = VKSdk.initialize(withAppId: vk_app_id)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }
    
    /* Spotify Authorisation */
    @IBAction func spotifySignUp(_ sender: UIButton) {
    }
    
    /* VK Authorisation */
    @IBAction func vkSignUp(_ sender: UIButton) {
        sdkInstance?.register(self)
        sdkInstance?.uiDelegate = self
        VKSdk.wakeUpSession(scope) { (state, error) in
            if state == .authorized {
                print("User authorized")
            } else {
                VKSdk.authorize(self.scope)
            }
            return
        }
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print(result)
    }
    
    func vkSdkUserAuthorizationFailed() {
        print("Auth failed")
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print("VK Should present")
        present(controller, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print("Show captcha")
    }
    
    /* OK Authorisation */
    @IBAction func okSignUp(_ sender: UIButton) {
        OKSDK.authorize(withPermissions: okScope) { data in
            print(data)
        } error: { error in
            print(error)
        }

    }
    
    /* End registration. Go to profile */
    @IBAction func endRegistration(_ sender: UIButton) {
        viewModel.endRegistration()
    }
}
