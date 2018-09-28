//
//  ProcessCapturedImageUsingCoreML.swift
//  拍照识物
//
//  Created by wuhaozheng on 2018/9/27.
//  Copyright © 2018 vmengblog. All rights reserved.
//

import UIKit
import AVFoundation
import CoreML
import Vision


public func DispatchAfter(after: Double, handler:@escaping ()->())
{
    DispatchQueue.main.asyncAfter(deadline: .now() + after) {
        handler()
    }
}


extension CameraVC: AVCapturePhotoCaptureDelegate, AVSpeechSynthesizerDelegate {
    
    internal func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            debugPrint(error)
        } else {
            photoData = photo.fileDataRepresentation()
            
            do {
                let model = try VNCoreMLModel(for: SqueezeNet().model)
                let request = VNCoreMLRequest(model: model, completionHandler: resultsMethod)
                let handler = VNImageRequestHandler(data: photoData!)
                try handler.perform([request])
            } catch {
                debugPrint(error)
            }
            
            let image = UIImage(data: photoData!)
            self.capturedImageView.image = image
        }
    }
    
    internal func resultsMethod(request: VNRequest, error: Error?) {
        guard let results = request.results as? [VNClassificationObservation] else { return }
        let translate=Translate()
        
        
        
        for classification in results {
            if classification.confidence <= 0.3 {
                let unknownMessage = "不确定这是什么，请重试"
                self.objectNameLabel.text = unknownMessage
                self.confidenceLabel.text = ""
                
                synthesizeSpeech(from: unknownMessage)
                break
            } else {
                
                var objectIdentifier = classification.identifier
                translate.startTranslate(rawString: objectIdentifier)
                DispatchAfter(after: 0.5) {
                    objectIdentifier = fanyiString
                    print(fanyiString)
                    let confidence = Int(classification.confidence * 100)
                    self.objectNameLabel.text = objectIdentifier
                    self.confidenceLabel.text = "可能性: \(confidence)%"
                    let completeMessage = "我认为有百分之\(confidence) 的可能性是 \(objectIdentifier)"
                    self.synthesizeSpeech(from: completeMessage)
                    
                    
                }
                break
                
            }
        }
    }
    
    internal func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.cameraView.isUserInteractionEnabled = true
        self.spinner.stopAnimating()
        
        //        self.spinner.isHidden = true
    }
    
    internal func synthesizeSpeech(from string: String) {
        let speechUtterance = AVSpeechUtterance(string: string)
        speechUtterance.voice=voice
        speechSynthesizer.speak(speechUtterance)
    }
    
}
