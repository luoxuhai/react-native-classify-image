import Vision

@objc(ClassifyImage)
class ClassifyImage: NSObject {

    @objc(request:withResolver:withRejecter:)
    func request(options: NSDictionary, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
        if #available(iOS 13.0, *) {
            let path = options["path"] as! String
            let orientation = CGImagePropertyOrientation.init(rawValue: options["orientation"] as? UInt32 ?? CGImagePropertyOrientation.up.rawValue)!
            let preferBackgroundProcessing = options["preferBackgroundProcessing"] as? Bool ?? false
            let usesCPUOnly = options["usesCPUOnly"] as? Bool ?? false
            let minConfidence = options["minConfidence"] as? Float ?? 0.1

            do {
                let result = try self.requestClassifyImage(
                    path: path,
                    orientation: orientation,
                    preferBackgroundProcessing: preferBackgroundProcessing,
                    usesCPUOnly: usesCPUOnly,
                    minConfidence: minConfidence)
                
                    resolve(result)
            } catch {
                reject("ERROR", error.localizedDescription, error)
            }
        } else {
            reject("ERROR", "'VNClassifyImageRequest' is only available in iOS 13.0 or newer", nil)
        }
    }

    @available(iOS 13.0, *)
    func requestClassifyImage(path: String,
                              orientation:CGImagePropertyOrientation,
                              preferBackgroundProcessing:Bool,
                              usesCPUOnly:Bool,
                              minConfidence:Float) throws -> [[String : Any]] {
        let handler = VNImageRequestHandler(url: URL.init(fileURLWithPath: path, isDirectory: false).absoluteURL, orientation: orientation)
        
        let request = VNClassifyImageRequest()
            request.usesCPUOnly = usesCPUOnly
            request.preferBackgroundProcessing = preferBackgroundProcessing
        
        do {
            try handler.perform([request])
        } catch {
            throw error
        }
        
        let results = request.results?.filter { $0.confidence >= Float.init(minConfidence) }
            .sorted { $0.confidence > $1.confidence }
            .map { ["identifier": $0.identifier, "confidence": $0.confidence] } ?? []
        
        return results
    }
}
