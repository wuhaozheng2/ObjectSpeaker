//
//  ViewController.swift
//  拍照识物
//
//  Created by wuhaozheng on 2018/9/27.
//  Copyright © 2018 vmengblog. All rights reserved.
//

import UIKit
import AVFoundation
import CoreML
import Vision


class CameraVC: UIViewController {
    
    internal var captureSession: AVCaptureSession!
    internal var cameraOutput: AVCapturePhotoOutput!
    internal var previewLayer: AVCaptureVideoPreviewLayer!
    
    internal var photoData: Data?
    internal var flashState : FlashState = .off
    internal var speechSynthesizer = AVSpeechSynthesizer()
    internal var voice = AVSpeechSynthesisVoice(language: "zh-CN")
    
    @IBOutlet weak var infoBackgroundView: CustomView!
    @IBOutlet weak var capturedImageView: CustomImageView!
    @IBOutlet weak var toggleFlashButton: CustomButton!
    @IBOutlet weak var objectNameLabel: UILabel!
    @IBOutlet weak var confidenceLabel: UILabel!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
//        spinner.isHidden = true
        speechSynthesizer.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        previewLayer.frame = cameraView.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addTapGestureToCameraView()
        setupCameraOutputPreview()
    }
    
    @IBAction func flashButtonPressed(_ sender: Any) {
        switch flashState {
        case .off:
            toggleFlashButton.setTitle("闪光灯开", for: .normal)
            flashState = .on
        default:
            toggleFlashButton.setTitle("闪光灯关", for: .normal)
            flashState = .off
        }
    }
}
