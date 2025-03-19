//
//  First.swift
//  trainig
//
//  Created by omer yildirim on 11.03.2025.
//

import UIKit

class First: UINavigationController {

    let functions = Functions()
    var screen:UIViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        //CacheData.clearAll()
        checkTokenAndNavigate()
    }
    
    func checkTokenAndNavigate() {
        let token = CacheData.getToken()
       
        if token == nil  {
            navigateToRoot()
        } else {
            navigateToHome()
        }
    }
    func checkToken(){
        PostGetBuilder()
            .setHost(Statics.host)
            .setReturn_type(RETURN_TYPE.JSONOBJECT)
            .setUrlType(URL_TYPE.getRelations.description)
            .setToken(CacheData.getToken()!)
            .setMethod(REQUEST_METHODS.GET)
            .createPost()
            .process(){response in
                let statusCode = response?.ResponseCode
                if statusCode == 200 {
                    self.navigateToHome()
                }else{
                    self.navigateToRoot()
                }
            }
    }
    func navigateToRoot() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = scene.delegate as? SceneDelegate {
            let appearance = UINavigationBar.appearance()
            appearance.tintColor = UIColor.lightGray
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let rootVC = storyboard.instantiateViewController(withIdentifier: "loginout") as? ViewController {
                let navController = UINavigationController(rootViewController: rootVC)
                sceneDelegate.window?.rootViewController = navController
                sceneDelegate.window?.makeKeyAndVisible()
            }
        }
    }

    func navigateToHome() {
        let userData=CacheData.getUserData()!
        let isFirst:Bool!
        if userData.object(forKey: "isFirst") != nil {
            isFirst = userData["isFirst"] as? Bool
        } else {
            isFirst = false
        }
       
        let role=userData["role"] as! String
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = scene.delegate as? SceneDelegate {
            let appearance = UINavigationBar.appearance()
            appearance.tintColor = UIColor.lightGray
            var n:UIViewController!
            let role=userData["role"] as! String
            var x:UITabBarController!
            if isFirst {
                n = storyboard?.instantiateViewController(withIdentifier: "vpager") as! ViewPager
            }else{
               
                if role=="user"{
                    n = self.storyboard?.instantiateViewController(withIdentifier: "upage") as! UserTabViewController
                    x = n as? UITabBarController
                }else{
                    n = storyboard?.instantiateViewController(withIdentifier: "tpage") as! TrainerTabViewController
                    x = n as? UITabBarController
                   
                }
                
            }
            let navController = UINavigationController(rootViewController: n)
            sceneDelegate.window?.rootViewController = navController
            sceneDelegate.window?.makeKeyAndVisible()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
