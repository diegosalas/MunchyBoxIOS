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
        sesion.addInput(input)
        sesion.addOutput(output)
        
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
//                 performSegue(withIdentifier: "enviar", sender: self)
                    FirebaseApp.configure()
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
//
//
//                self.window = UIWindow(frame: UIScreen.main.bounds)
//                self.window?.rootViewController = UINavigationController(rootViewController: ATCClassicLandingScreenViewController(nibName: "ATCClassicLandingScreenViewController", bundle: nil))
//                self.window?.makeKeyAndVisible()
//                 print("we are not logged")
//
//
//
//
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














