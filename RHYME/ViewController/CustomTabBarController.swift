//
//  CustomTabBarController.swift
//  RHYME
//
//  Created by Silstone on 13/10/21.
//

import UIKit

class CustomTabBarController: UITabBarController {

    let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMiddleButton()
        NotificationCenter.default.addObserver(self, selector: #selector(self.removeMenuBtn(_:)), name: NSNotification.Name(rawValue: "removeMenuBtn"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.addMenuBtn(_:)), name: NSNotification.Name(rawValue: "addMenuBtn"), object: nil)
    }

    @objc func removeMenuBtn(_ notification: NSNotification) {
        self.menuButton.isHidden = true
    }
    
    @objc func addMenuBtn(_ notification: NSNotification) {
        self.menuButton.isHidden = false
    }
    // MARK: - Setups

    func setupMiddleButton() {
//        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))

//        var hasTopNotch: Bool {
//            if #available(iOS 14.0, tvOS 14.0, *) {
//                return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
//            }
//            return false
//        }
        var menuButtonFrame = menuButton.frame
//        if hasTopNotch {
//
//        }else{
//
//        }
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
                case 1136:
                    print("iPhone 5 or 5S or 5C")
                    menuButtonFrame.origin.y = view.bounds.height+30 - menuButtonFrame.height*1.7
                    menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
                    menuButton.frame = menuButtonFrame
                
                case 1334:
                    print("iPhone 6/6S/7/8")
                    menuButtonFrame.origin.y = view.bounds.height+30 - menuButtonFrame.height*1.7
                    menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
                    menuButton.frame = menuButtonFrame
                
                case 1920, 2208:
                    print("iPhone 6+/6S+/7+/8+")
                    menuButtonFrame.origin.y = view.bounds.height+30 - menuButtonFrame.height*1.7
                    menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
                    menuButton.frame = menuButtonFrame
                
                case 2436:
                    print("iPhone X/XS/11 Pro")
                    menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height*1.7
                    menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
                    menuButton.frame = menuButtonFrame
                
                case 2688:
                    print("iPhone XS Max/11 Pro Max")
                    menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height*1.7
                    menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
                    menuButton.frame = menuButtonFrame
                
                case 1792:
                    print("iPhone XR/ 11 ")
                    menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height*1.7
                    menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
                    menuButton.frame = menuButtonFrame
                
                default:
                    print("Unknown")
                    menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height*1.7
                    menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
                    menuButton.frame = menuButtonFrame
                }
            }

        menuButton.backgroundColor = UIColor.red
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        view.addSubview(menuButton)
        //self.tabBarController?.tabBar.addSubview(menuButton)

        menuButton.setImage(UIImage(named: "Group 4484"), for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)

        view.layoutIfNeeded()
    }


    // MARK: - Actions

    @objc private func menuButtonAction(sender: UIButton) {
        selectedIndex = 2
        self.tabBarController?.selectedIndex = 2
    }
}
