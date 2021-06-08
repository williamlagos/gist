//
//  ScannerView.swift
//  Gist
//
//  Created by William Oliveira de Lagos on 18/04/2021.
//

import UIKit
import Foundation
import AVFoundation

protocol ScannerViewDelegate: class {
    func scanningDidFail()
    func scanningSucceededWithCode(_ str: String?)
    func scanningDidStop()
}

class ScannerView: UIView {
    weak var delegate: ScannerViewDelegate?
    
    var captureSession: AVCaptureSession!
    var backCameraInput: AVCaptureInput!
    var backCamera: AVCaptureDevice!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        initialSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    override var layer: AVCaptureVideoPreviewLayer {
        return super.layer as! AVCaptureVideoPreviewLayer
    }
}

extension ScannerView {
    
    var isRunning: Bool {
        return captureSession?.isRunning ?? false
    }
    
    func startScanning() {
        captureSession?.startRunning()
    }
    
    func stopScanning() {
        captureSession?.stopRunning()
        delegate?.scanningDidStop()
    }
    
    private func initialSetup() {
        clipsToBounds = true
        captureSession = AVCaptureSession()
        
        // Setting device and input for the AV capture session
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch let error {
            print(error)
            return
        }
        if (captureSession?.canAddInput(videoInput) ?? false) {
            captureSession?.addInput(videoInput)
        } else {
            return
        }
        
        // Prepare the device for reading QR code format
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession?.canAddOutput(metadataOutput) ?? false) {
            captureSession?.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr, .ean8, .ean13, .pdf417]
        } else {
            return
        }
        
        self.layer.session = captureSession
        self.layer.videoGravity = .resizeAspectFill
        captureSession?.startRunning()
    }
    
    func scanningDidFail() {
        delegate?.scanningDidFail()
        captureSession = nil
    }
    
    func found(code: String) {
        delegate?.scanningSucceededWithCode(code)
    }
}

extension ScannerView: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        stopScanning()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }
}
