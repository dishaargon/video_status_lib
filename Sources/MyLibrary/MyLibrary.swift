import Foundation
import mobileffmpeg

public var JSONDIC = NSDictionary()
public var videoId = String()
public var EDITVIDEOPATH = String()
public var UNZIPPATH = String()

public enum NetworkError: Error {
    case badRequest
    case decodingError
}

public struct MyLibrary {

    public init() {
    }
    
    public func unZipFolder(){
    }
    
    public func callback(jsonDic : NSDictionary, VideoId : String, editVideoPath : String, unzipPath : String,  completion: (Bool)->()) {
        JSONDIC = jsonDic
        videoId = VideoId
        EDITVIDEOPATH = editVideoPath
        UNZIPPATH = unzipPath
        
        let rc = MobileFFmpeg.execute(withArguments: getString())

        if rc == RETURN_CODE_SUCCESS {
            completion(true)
            print("Command execution completed successfully.\n")
        } else if rc == RETURN_CODE_CANCEL {
            completion(false)
            print("Command execution cancelled by user.\n")
        } else {
            completion(false)
            print("Command execution failed with rc=\(rc) and output=\("").\notesn")
        }
    }
    
    public func getString() -> [AnyHashable]? {//process
        
        let imageArray = JSONDIC.value(forKey: "images") as? [AnyHashable]
        var mainArray: [AnyHashable] = []
        for i in 0..<(imageArray?.count ?? 0) {
            let preArray = (imageArray?[i] as NSObject?)?.value(forKey: "prefix") as? [AnyHashable]
            if preArray!.count > 0 {
                for j in 0..<(preArray?.count ?? 0) {
                    mainArray.append(preArray![j])
                }
            }
            let postArray = (imageArray?[i] as NSObject?)?.value(forKey: "postfix") as? [AnyHashable]
            if postArray!.count > 0 {
                for k in 0..<(postArray?.count ?? 0) {
                    mainArray.append(postArray![k])
                }
            }
            let imgstr = (imageArray?[i] as NSObject?)?.value(forKey: "name") as? String
            let path = URL(fileURLWithPath: EDITVIDEOPATH).appendingPathComponent(imgstr ?? "").absoluteString
            mainArray.append(path)
        }
        
        let inputVideoArray = JSONDIC.value(forKey: "static_inputs") as? [AnyHashable]
        for i in 0..<(inputVideoArray?.count ?? 0) {
            let preArray = (inputVideoArray?[i] as NSObject?)?.value(forKey: "prefix") as? [AnyHashable]
            if preArray!.count > 0 {
                for j in 0..<(preArray?.count ?? 0) {
                    mainArray.append(preArray![j])
                }
            }
            let postArray = (inputVideoArray?[i] as NSObject?)?.value(forKey: "postfix") as? [AnyHashable]
            if postArray!.count > 0 {
                for k in 0..<(postArray?.count ?? 0) {
                    mainArray.append(postArray![k])
                }
            }
            
            let imgstr = (inputVideoArray?[i] as NSObject?)?.value(forKey: "name") as? String

            let pppp = "\(UNZIPPATH)/\(videoId)"
            let path = URL(fileURLWithPath: pppp).appendingPathComponent(imgstr!).absoluteString
            mainArray.append(path)
        }
        
        let main = Bundle.main.path(forResource: "watermark", ofType: "jpg")
        mainArray.append("-i")
        mainArray.append(main)
        
        let aArray = JSONDIC.value(forKey: "m") as? [AnyHashable]
        let bArray = JSONDIC.value(forKey: "i") as? [AnyHashable]
        let cArray = JSONDIC.value(forKey: "o") as? [AnyHashable]
        let dArray = JSONDIC.value(forKey: "d") as? [AnyHashable]
        
        for a in 0..<aArray!.count {
            var str = aArray![a] as! String
            str = str.replacingOccurrences(of: "{pythoncomplex}", with: "filter_complex", options: .literal, range: nil)
            mainArray.append(str)
        }
        
        for b in 0..<bArray!.count {
            var str = bArray![b] as! String
            str = str.replacingOccurrences(of: "{pythonmerge}", with: "alphamerge", options: .literal, range: nil)
            str = str.replacingOccurrences(of: "{pythonz}", with: "zoom", options: .literal, range: nil)
            str = str.replacingOccurrences(of: "{pythonf}", with: "fade", options: .literal, range: nil)
            str = str.replacingOccurrences(of: "{pythono}", with: "overlay", options: .literal, range: nil)
            mainArray.append(str)
        }
        
        mainArray.append(contentsOf: cArray!)
        mainArray.append(contentsOf: dArray!)
        
        let outputPath = URL(fileURLWithPath: EDITVIDEOPATH).appendingPathComponent("file2.mp4").absoluteString
        mainArray.append(outputPath)
        
        return mainArray
    }
    
    
}
