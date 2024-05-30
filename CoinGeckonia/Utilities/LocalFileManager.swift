//
//  LocalFileManager.swift
//  CoinGeckonia
//
//  Created by Enchappolis on 4/13/24.
//

import UIKit

class LocalFileManager {
    
    static let shared = LocalFileManager()
    
    private init () {}
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {

        createFolder(folderName: folderName)
        
        guard let data = image.pngData(),
              let url = getURLForImage(imageName: imageName, folderName: folderName)
        else { return }
        
        do {
            
            try data.write(to: url, options: .atomic)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        
        guard let url = getURLForImage(imageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path())
        else { return nil }
        
        return UIImage(contentsOfFile: url.path())
    }
    
    private func createFolder(folderName: String) {
        
        guard let url = getURLForFolder(folderName: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path()) {
            
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
                
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    private func getURLForFolder(folderName: String) -> URL? {
        
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        
        guard let folderURL = getURLForFolder(folderName: folderName) else { return nil }
        
        return folderURL.appendingPathComponent(imageName + ".png")
    }
}
