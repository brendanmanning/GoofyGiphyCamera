//
//  ViewController.swift
//  GoofyGiphyCamera
//
//  Created by Brendan Manning on 9/8/18.
//  Copyright © 2018 Brendan Manning. All rights reserved.
//

import AVFoundation
import CoreML
import UIKit
import Vision

class ViewController: UIViewController, AVCapturePhotoCaptureDelegate {

    // MARK: - Interface Builder Connections
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var searchLabel: UILabel!
    
    @IBOutlet weak var shutterButton: ShutterButton!
    @IBOutlet weak var closeViewModeButton: UIButton!
    
    // MARK: - Instance Variables
    var request: VNCoreMLRequest!;
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var photoCaptureOutput: AVCapturePhotoOutput?;
    
    // MARK: - State Variables
    var state: ViewControllerState = .Camera;
    var query: String = "dab";
    
    var gifViews: [GIFView] = [GIFView]();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Detect shake gestures
        self.becomeFirstResponder();
        
        // Configure the search bar's style
        searchLabel!.layer.cornerRadius = 8;
        
        // Setup the Model
        guard let visionModel = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Well fuck :(");
        }
        request = VNCoreMLRequest(model: visionModel, completionHandler: requestDidComplete);
        request.imageCropAndScaleOption = .centerCrop;
        
        // Setup the camera view
       let captureDevice = AVCaptureDevice.default(for: AVMediaType.video);
        do {
        
            let input = try AVCaptureDeviceInput(device: captureDevice!);
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            // Allow us to see the camera preview onscreen
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill;
            videoPreviewLayer?.frame = view.layer.bounds;
            cameraView.layer.addSublayer(videoPreviewLayer!);
            
            // Add an output for taking photos
            photoCaptureOutput = AVCapturePhotoOutput();
            photoCaptureOutput?.isHighResolutionCaptureEnabled = true;
            captureSession?.addOutput(photoCaptureOutput!);
            
            captureSession?.startRunning()
        
        } catch {
            fatalError("Oh buns! The camera isn't working *sad face* :(")
        }
        
    }

    @IBAction func capturePhoto(_ sender: Any) {
        guard let photoCaptureOutput = self.photoCaptureOutput else {
            return;
        }
        
        let photoSettings = AVCapturePhotoSettings();
        photoSettings.isHighResolutionPhotoEnabled = true;
        photoSettings.isAutoStillImageStabilizationEnabled = true;
        photoSettings.flashMode = .auto;
        
        photoCaptureOutput.capturePhoto(with: photoSettings, delegate: self);
    }
    
    @IBAction func nextGif(_ sender: Any) {
        
        if state == .Camera {
            return;
        }
        
        print("Query: " + self.query);
        Giphy.random(query: self.query) { (url: URL?) in
            
            print("Earl of HTTP: ");
            print(url);
            
            if url == nil {
                return;
            }
            
            let randX = CGFloat(arc4random_uniform(UInt32(self.view!.frame.width))) - 20;
            let randY = CGFloat(arc4random_uniform(UInt32(self.view!.frame.height))) - 20;
            let gifView = GIFView(frame: CGRect(x: randX, y: randY, width: GIFView.INTENDED_SIZE.width, height: GIFView.INTENDED_SIZE.height));
            gifView.enableGestures(target: self, selector: #selector(ViewController.draggedGif(_:)));
            gifView.show(gif: url!);
            
            self.gifViews.append(gifView);
            self.view.addSubview(gifView);
        }
    }
    @IBAction func closeViewGifs(_ sender: Any) {
        setState(state: .Camera);
    }
    
    func predict(image: UIImage) {
        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:]);
        try? handler.perform([request]);
    }
    
    func requestDidComplete(request: VNRequest, error: Error?) {
        if let observations = request.results as? [VNClassificationObservation] {
            for i in 0..<5 {
                print(observations[i].identifier + " " + String(observations[i].confidence));
            }
            self.query = observations[0].identifier
            self.searchLabel!.text = "\"" + self.query + "\"";
            self.nextGif(self);
        }
    }
    
    func setState(state: ViewControllerState) {
        if state == .Camera {
            self.cameraView!.isHidden = false;
            self.shutterButton!.isHidden = false;
            self.closeViewModeButton!.isHidden = true;
            self.searchLabel!.isHidden = true;
            
            for view in gifViews {
                view.removeFromSuperview();
            }
            gifViews.removeAll();
        }
        if state == .GIFs {
            self.cameraView!.isHidden = true;
            self.shutterButton!.isHidden = true;
            self.closeViewModeButton!.isHidden = false;
            self.searchLabel!.isHidden = false;
            self.searchLabel.text = "Loading...";
        }
        self.state = state;
    }
    
    @IBAction func invertCamera(_ sender: Any) {
        
        captureSession!.beginConfiguration();
        
        if let currentCamera = captureSession!.inputs.first {
            
            captureSession!.removeInput(currentCamera);
            
            var newOrientation = AVCaptureDevice.Position.front;
            if let currentDevice = currentCamera as? AVCaptureDeviceInput {
                if currentDevice.device.position == .front {
                    newOrientation = .back;
                }
            }
            
            print("Now using " + ((newOrientation == .front) ? "front" : "back") + " camera.");
            
            try? captureSession?.addInput(AVCaptureDeviceInput(device: cameraWithOrientation(orientation: newOrientation)!));
            
            captureSession?.commitConfiguration()
        }
    }
    
    @objc
    func draggedGif(_ sender: UIPanGestureRecognizer) {
        self.view.bringSubview(toFront: sender.view!);
        let trans = sender.translation(in: self.view);
        sender.view!.center = CGPoint(x: sender.view!.center.x + trans.x, y: sender.view!.center.y + trans.y);
        sender.setTranslation(CGPoint.zero, in: self.view);
    }
    
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {

        // Make sure we get some photo sample buffer
        guard error == nil,
            let photoSampleBuffer = photoSampleBuffer else {
                print("Error capturing photo: \(String(describing: error))")
                return
        }
        // Convert photo same buffer to a jpeg image data by using // AVCapturePhotoOutput
        guard let imageData =
            AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
                return
        }
        // Initialise a UIImage with our image data
        guard let image = UIImage.init(data: imageData , scale: 1.0) else {
            fatalError("Couldn't translate image data");
        };
        
        /* *************************** */
        /* Now that we have the image  */
        /*                             */
        /* Show the image in still     */
        /* Update the state of the VC  */
        /*                             */
        /* Let's see what objects we   */
        /* can pull out of it...       */
        /*                             */
        /* Then we'll search the Giphy */
        /* API for gifs to match this  */
        /* *************************** */

        self.imageView!.image = image;
        setState(state: .GIFs);
        predict(image: image);

    }
    
    func cameraWithOrientation(orientation: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discovery = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: orientation);
        
        for d in discovery.devices {
            print("returning")
            return d;
        }
        
        return nil;
    }

    
    // We are willing to become first responder to get shake motion
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            if state == .GIFs {
                setState(state: .Camera);
            }
        }
    }
}
