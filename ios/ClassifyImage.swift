import Vision

@objc(ClassifyImage)
class ClassifyImage: NSObject {

    @objc(request:withResolver:withRejecter:)
    func request(options: NSDictionary, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
        if #available(iOS 13.0, *) {
            let path = options["path"] as! String
            let orientation = options["orientation"] as? CGImagePropertyOrientation ?? CGImagePropertyOrientation.up
            let preferBackgroundProcessing = options["preferBackgroundProcessing"] as? Bool ?? false
            let usesCPUOnly = options["usesCPUOnly"] as? Bool ?? false
            let minConfidence = options["minConfidence"] as? Float ?? 0.1

            var results = [[String:Float]]().self
            let result = self.requestClassifyImage(
                path: path,
                orientation: orientation,
                preferBackgroundProcessing: preferBackgroundProcessing,
                usesCPUOnly: usesCPUOnly,
                minConfidence: minConfidence,
                reject: reject)
            if (result != nil) {
                results.append(result!)
            } else {
                return
            }

            resolve(results)
        } else {
            reject("UNKNOWN_ERROR", "'VNClassifyImageRequest' is only available in iOS 13.0 or newer", nil)
        }
    }
    
    @objc(getSupportedIdentifiers:withResolver:withRejecter:)
    func supportedIdentifiers(_:NSDictionary, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
        if #available(iOS 15.0, *) {
            let request = VNClassifyImageRequest()
            do {
                let identifiers = try request.supportedIdentifiers()
                resolve(identifiers)
            } catch {
                reject("UNKNOWN_ERROR", error.localizedDescription, error)
            }
        } else {
            reject("UNKNOWN_ERROR", "'supportedIdentifiers' is only available in iOS 15.0 or newer", nil)
        }
    }

    @available(iOS 13.0, *)
    func requestClassifyImage(path: String,
                              orientation:CGImagePropertyOrientation,
                              preferBackgroundProcessing:Bool,
                              usesCPUOnly:Bool,
                              minConfidence:Float,
                              reject:RCTPromiseRejectBlock) -> [String: Float]? {
        let handler = VNImageRequestHandler(url: URL.init(fileURLWithPath: path, isDirectory: false).absoluteURL, orientation: orientation)
        
        let request = VNClassifyImageRequest()
            request.usesCPUOnly = usesCPUOnly
            request.preferBackgroundProcessing = preferBackgroundProcessing
        do {
            try handler.perform([request])
        } catch {
            reject("UNKNOWN_ERROR", error.localizedDescription, error)
            return nil
        }
            
        var resultDict = [String: Float]()
        let results = request.results?.filter { $0.confidence >= Float.init(minConfidence) } ?? []
            
        for item in results {
            resultDict.updateValue(item.confidence, forKey: item.identifier)
        }

        return resultDict
    }
}
