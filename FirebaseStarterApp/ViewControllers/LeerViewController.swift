//
//  LeerViewController.swift
//  LectorQR
//
//  Created by Jorge M. B. on 19/03/18.
//  Copyright © 2018 Jorge M. B. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import Firebase


class LeerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
  
    @IBOutlet weak var videoPreview: UIView!
    @IBOutlet weak var captureQR: UIImageView!
    @IBOutlet weak var captureLabel: UILabel!
    @IBOutlet weak var banner: UIImageView!
    var account = ""
    var getRef : Firestore!
    var stringURL = String()
    let sesion = AVCaptureSession()
    var window: UIWindow?
    override func viewDidLoad() {
        super.viewDidLoad()
        scanner()
    }
    
    func scanner(){
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return}
        
        guard let input = try? AVCaptureDeviceInput(device: device) else { return }
        
        let output = AVCaptureMetadataOutput()
  
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        if let inputs = sesion.inputs as? [AVCaptureDeviceInput] {
                 for input in inputs {
                     sesion.removeInput(input)
                 }
            }
        
        if let outputs = sesion.outputs as? [AVCaptureOutput] {
                        for output in outputs {
                            sesion.removeOutput(output)
                        }
                   }
 
        if sesion.inputs.isEmpty {
           sesion.addInput(input)
        }
        if sesion.outputs.isEmpty{
         sesion.addOutput(output)
        }
        
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        let preview = AVCaptureVideoPreviewLayer(session: sesion)
        
        preview.videoGravity = AVLayerVideoGravity.resizeAspectFill
        preview.frame = videoPreview.bounds
        videoPreview.layer.addSublayer(preview)
        videoPreview.addSubview(captureQR)
        videoPreview.addSubview(captureLabel)
        videoPreview.addSubview(banner)
        sesion.startRunning()
        
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        sesion.stopRunning()
        if metadataObjects.count > 0 {
            let machine = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            if machine.type == AVMetadataObject.ObjectType.qr {
                stringURL = machine.stringValue!
                print(stringURL)
//                 performSegue(withIdentifier: "enviar", sender: self)
                
                
//                See if qr is at DB
                
                getRef = Firestore.firestore()
                                      getRef.collection("drivers").whereField("id", isEqualTo: stringURL).getDocuments { (querySnapshot, error) in
                                        if (querySnapshot!.documents.count == 0){
                                            print("Driver not found")
                                         
                                            self.viewDidLoad()
                                            
                                        }else{
                                          if let error = error {
                                                        print("hubo un error al traer los datos", error)
                                          }else{
                                               for document in querySnapshot!.documents {
                          
                                                let valores = document.data()
                                                self.account = valores["account"] as! String
                                                Driver().account = valores["account"] as? String
                                                Driver().name = valores["name"] as? String
                                                Driver().id = valores["id"] as? String
                                                Driver().country = valores["country"] as? String

                                                let userDefaults = UserDefaults.standard
                                                userDefaults.set(valores["account"] as! String, forKey: "account")
                                                userDefaults.set(valores["name"] as? String, forKey: "name")
                                                userDefaults.set(valores["id"] as? String, forKey: "id")
                                                userDefaults.set(valores["country"] as? String, forKey: "country")
                                                  
                                                
                                                
                                                
                                                print ("the driver stripe accoun is: " + self.account )
//                                                     completion?()
                                                Auth.auth().addStateDidChangeListener { (auth, user) in
                                                if user == nil{
                                                     self.window = UIWindow(frame: UIScreen.main.bounds)
                                                     self.window?.rootViewController = UINavigationController(rootViewController: ATCClassicLandingScreenViewController(nibName: "ATCClassicLandingScreenViewController", bundle: nil))
                                                     self.window?.makeKeyAndVisible()
                                                     print("we are not logged")
                                                }else{
                                                    print("we are  logged")
                                                    let rootVC = BrowseProductsViewController()
                                                    let navigationController = UINavigationController(rootViewController: rootVC)
                                                    let window = UIWindow(frame: UIScreen.main.bounds)
                                                    window.rootViewController = navigationController;
                                                    window.makeKeyAndVisible()
                                                    self.window = window
                                          }
                                      }
                         
                                }
                    }
                                }
                }
            }
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "enviar" {
//                FirebaseApp.configure()
//                Auth.auth().addStateDidChangeListener { (auth, user) in
//            if user == nil{
//
//                print("we are  logged")
//
//                 let rootVC = BrowseProductsViewController()
//                 let navigationController = UINavigationController(rootViewController: rootVC)
//                 let window = UIWindow(frame: UIScreen.main.bounds)
//                 window.rootViewController = navigationController;
//                 window.makeKeyAndVisible()
//                 self.window = window
//
//            }else{
//                self.window = UIWindow(frame: UIScreen.main.bounds)
//                self.window?.rootViewController = UINavigationController(rootViewController: ATCClassicLandingScreenViewController(nibName: "ATCClassicLandingScreenViewController", bundle: nil))
//                self.window?.makeKeyAndVisible()
//                 print("we are not logged")
//            }
//        }
//        }
//    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if sesion.isRunning == false{
            sesion.startRunning()
        }
    }
}
