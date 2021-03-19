//
//  LocalStorage().swift
//  Sportbeats
//
//  Created by Marlo Kessler on 09.11.19.
//  Copyright © 2019 Marlo Kessler. All rights reserved.
//

import UIKit
import AVKit

public class LocalStorage {
    
    private enum FileNames: String {
        ///The name is just a random combination of letters to avoid overwriting trough duplicates.
        case profileImageName = "neJEUjtEmkiSBQwdeEHN_profileImage"
    }
    
    public enum FileType: String {
        ///Alway stored as PNG
        case image = "png"
        ///Alway stored as MP4
        case video = "mp4"
        ///Alway stored as MP3
        case music = "mp3"
    }
    
    //MARK: - Images
    ///Saves an image from an download URL to the local storage. Overwrites an existing one with the same name. Is asynchronous. Completion handler gives back: (Succeeded, imiageURL?)
    public static func downloadImageFromURL(imageDownloadLink: String, name: String, completionHandler: ((Bool, URL?) -> Void)?) {
        guard let imageURL = URL(string: imageDownloadLink) else {
            completionHandler?(false, nil)
            print("IMG URL is nil")
            return
        }
        
        URLSession.shared.downloadTask(with: imageURL) { (location, response, error) -> Void in

            guard let location = location else {
                completionHandler?(false, nil)
                print("Location is nil")
                return
            }
            
            let fileManager = FileManager.default
            guard let imagesURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                completionHandler?(false, nil)
                print("imagesURL URL IS Nil")
                return
            }
            let imageFileURL = imagesURL
                .appendingPathComponent("pictures")
                .appendingPathComponent(name)
                .appendingPathExtension(FileType.image.rawValue)
            print("IMAGEFILEURL: \(imageFileURL)")
            print("IMAGEFILEURLPATH: \(imageFileURL.path)")
            //Proofs if file is already in correct format
            if location.pathExtension.lowercased() == imageFileURL.pathExtension.lowercased() {
                //Moves Item to the correct place
                do {
                    print("WAY: 19")
                    try fileManager.moveItem(at: location, to: imageFileURL)
                    completionHandler?(true, imageFileURL)
                } catch {
                    do {
                        try fileManager.removeItem(at: location)
                    } catch {print("ERROR: 19")}
                    completionHandler?(false, nil)
                    return
                }
            } else {
                guard let image = UIImage(contentsOfFile: location.path) else {
                    do {
                        try fileManager.removeItem(at: location)
                    } catch {print("ERROR: 20")}
                    completionHandler?(false, nil)
                    return
                }
                if saveImageWithResult(image: image, name: name) {
                    completionHandler?(true, imageFileURL)
                    print("WAY: 20")
                } else {
                    completionHandler?(false, nil)
                    print("ERROR: 21")
                }
                do {
                    print("WAY: 21")
                    try fileManager.removeItem(at: location)
                } catch {print("Error: 22")}
            }
        }.resume()
    }
    
    ///Saves an image in the local storage and returns true, if the image was saved successfully. Overwrites an existing one with the same name.
    public static func saveImageWithResult(image: UIImage, name: String) -> Bool {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error: 30")
            return false }
        let picturesURL = documentsURL.appendingPathComponent("pictures")
        let imageFileURL = picturesURL.appendingPathComponent(name).appendingPathExtension(FileType.image.rawValue)
        do{
            if let pngImageData = image.pngData() {
                try fileManager.createDirectory(at: picturesURL, withIntermediateDirectories: true, attributes: nil)
                try pngImageData.write(to: imageFileURL, options: .atomic)
                print("Way: 24")
                return true
            } else {
                print("Error: 23")
                return false
            }
        } catch {
            print("Error: 24")
            return false
        }
    }
    
    ///Saves an image in the local storage. Overwrites an existing one with the same name.
    public static func saveImage(image: UIImage, name: String) {
        _ = saveImageWithResult(image: image, name: name)
    }
    
    ///Returns an image from the local storage.
    public static func getImage(name: String) -> UIImage? {
        let fileManager = FileManager.default
        guard let picturesURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let imageFileURL = picturesURL
            .appendingPathComponent("pictures")
            .appendingPathComponent(name)
            .appendingPathExtension(FileType.image.rawValue)
        return UIImage(contentsOfFile: imageFileURL.path)
    }
    
    ///Deletes an image from the local storage and returns true, if the image was deleted successfully. Returns also false, if there was no image with that name.
    public static func deleteImageWithResult(name: String) -> Bool {
        let fileManager = FileManager.default
        guard let picturesURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first  else { return false }
        let imageFileURL = picturesURL
            .appendingPathComponent("pictures")
            .appendingPathComponent(name)
            .appendingPathExtension(FileType.image.rawValue)
        
        do {
            try fileManager.removeItem(at: imageFileURL)
            return true
        } catch {
            return false
        }
    }
    
    ///Deletes an image from the local storage.
    public static func deleteImage(name: String) {
        _ = deleteImageWithResult(name: name)
    }
    
    //ProfileImage
    ///Saves the profile  image from an download URL to the local storage. Overwrites an existing one with the same name. Is asynchronous.
    public static func downloadProfileImageFromURL(imageDownloadLink: String, completionHandler: ((Bool, URL?) -> Void)?) {
        downloadImageFromURL(imageDownloadLink: imageDownloadLink, name: FileNames.profileImageName.rawValue) { (succeeded, url) in
            print("PID Status: \(succeeded)")
            completionHandler?(succeeded, url)
        }
    }
    ///Saves the profile image in the local storage and returns true, if the image was saved successfully. Overwrites the existing profile image.
    public static func saveProfileImageWithResult(image: UIImage) -> Bool {
        return saveImageWithResult(image: image, name: FileNames.profileImageName.rawValue)
    }
    
    ///Saves the profile image in the local storage. Overwrites the existing profile image.
    public static func saveProfileImage(image: UIImage) {
        saveImage(image: image, name: FileNames.profileImageName.rawValue)
    }

    ///Returns the profile image from the local storage.
    public static func getProfileImage() -> UIImage? {
        return getImage(name: FileNames.profileImageName.rawValue)
    }
    
    ///Deletes the profile image from the local storage and returns true, if the image was deleted successfully. Returns also false, if there was no profile image with that name.
    public static func deleteProfileImageWithResult() -> Bool {
        return deleteImageWithResult(name: FileNames.profileImageName.rawValue)
    }
    
    ///Deletes the profile image from the local storage.
    public static func deleteProfileImage() {
        deleteImage(name: FileNames.profileImageName.rawValue)
    }
    
    //MARK: - Videos
    ///Saves a video from an download URL to the local storage. Overwrites an existing one with the same name. Is asynchronous. Completion handler gives back: (Succeeded, videoURL?)
    public static func downloadVideoFromURL(videoDownloadLink: String, name: String, completionHandler: ((Bool, URL?) -> Void)?) {
        guard let videoURL = URL(string: videoDownloadLink) else {
            completionHandler?(false, nil)
            return
        }
        
        URLSession.shared.downloadTask(with: videoURL) { (location, response, error) -> Void in

            guard let location = location else {
                completionHandler?(false, nil)
                return
            }
            
            let fileManager = FileManager.default
            guard let videosURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                completionHandler?(false, nil)
                return
            }
            let videoFileURL = videosURL
                .appendingPathComponent("movies")
                .appendingPathComponent(name)
                .appendingPathExtension(FileType.video.rawValue)
            
            //Proofs if file is already in correct format
            if location.pathExtension.lowercased() == videoFileURL.pathExtension.lowercased() {
                do {
                    try fileManager.moveItem(at: location, to: videoFileURL)
                    completionHandler?(true, videoFileURL)
                } catch {
                    do {
                        try fileManager.removeItem(at: location)
                    } catch {}
                    completionHandler?(false, nil)
                    return
                }
            } else {
                encodeVideo(at: location) { (succeeded) in
                    if succeeded {
                        do {
                            try fileManager.moveItem(at: location, to: videoFileURL)
                            completionHandler?(true, videoFileURL)
                        } catch {
                            do {
                                try fileManager.removeItem(at: location)
                            } catch {}
                            completionHandler?(false, nil)
                        }
                    } else {
                        completionHandler?(false, nil)
                    }
                }
            }
        }.resume()
    }
    
    ///Returns a videoURL from the local storage. Returns nil, if there was no URL found or  if the video is not stored locally or an error occured.
    public static func videoURL(name: String) -> URL? {
        let fileManager = FileManager.default
        guard let videosURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let videoURL = videosURL
            .appendingPathComponent("movies")
            .appendingPathComponent(name)
            .appendingPathExtension(FileType.video.rawValue)
        return fileManager.fileExists(atPath: videoURL.path) ? videoURL : nil
    }
    
    ///Returns a new video URL for the local storage. Returns nil, if there already exists a file or an error occured.
    public static func urlForNewVideo(name: String) -> URL? {
        let fileManager = FileManager.default
        guard let videosURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let videoURL = videosURL
            .appendingPathComponent("movies")
            .appendingPathComponent(name)
            .appendingPathExtension(FileType.video.rawValue)
        return fileManager.fileExists(atPath: videoURL.path) ? nil : videoURL
    }
    
    ///Deletes a video from the local storage and returns true, if the video was deleted successfully. Returns also false, if there was no video with that name.
    public static func deleteVideoWithResult(name: String) -> Bool {
        let fileManager = FileManager.default
        guard let videosURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return false }
        let videoFileURL = videosURL
            .appendingPathComponent("movies")
            .appendingPathComponent(name)
            .appendingPathExtension(FileType.video.rawValue)
        
        do {
            try fileManager.removeItem(at: videoFileURL)
            return true
        } catch {
            return false
        }
    }

    ///Deletes a video from the local storage.
    public static func deleteVideo(name: String) {
        _ = deleteVideoWithResult(name: name)
    }
    
    ///Converts a video to an .mp4 file.   Completion handler gives back: (Succeeded).
    private static func encodeVideo(at videoURL: URL, completionHandler: ((Bool) -> Void)?)  {
        //Creating temp path to save the converted video
        let fileManager = FileManager.default
        guard let videosURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            completionHandler?(false)
            return
        }
        let tempName = "\(UUID().uuidString)\(FileType.video.rawValue)"
        let tempVideoFileURL = videosURL.appendingPathComponent("movies").appendingPathComponent(tempName)
        //Check if the file already exists then remove the previous file
        if FileManager.default.fileExists(atPath: tempVideoFileURL.path) {
            do {
                try FileManager.default.removeItem(at: tempVideoFileURL)
            } catch {
                completionHandler?(false)
                return
            }
        }
        let avAsset = AVURLAsset(url: videoURL, options: nil)
        //Create Export session
        guard let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough) else {
            completionHandler?(false)
            return
        }
        exportSession.outputURL = tempVideoFileURL
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
        let range = CMTimeRangeMake(start: start, duration: avAsset.duration)
        exportSession.timeRange = range
        exportSession.exportAsynchronously() {
            switch exportSession.status {
            case .failed:
                print(exportSession.error ?? "NO ERROR")
                completionHandler?(false)
            case .cancelled:
                print("Export canceled")
                completionHandler?(false)
            case .completed:
                do {
                    try fileManager.moveItem(at: tempVideoFileURL, to: videoURL)
                    print("Export completed")
                    completionHandler?(true)
                } catch {
                    do {
                        try fileManager.removeItem(at: tempVideoFileURL)
                    } catch {}
                    print("File move failed")
                    completionHandler?(false)
                }
            default:
                break
            }
        }
    }
    
    
    
    //MARK: - Music
    ///Saves a music file from an download URL to the local storage. Overwrites an existing one with the same name. Is asynchronous.
    public static func downloadMusicFileFromURL(musicDownloadLink: String, name: String, completionHandler: ((Bool, URL?) -> Void)?) {
        guard let musicURL = URL(string: musicDownloadLink) else {
            completionHandler?(false, nil)
            return
        }
        
        URLSession.shared.downloadTask(with: musicURL) { (location, response, error) -> Void in

            guard let location = location else {
                completionHandler?(false, nil)
                return
            }
            
            let fileManager = FileManager.default
            guard let musicFilesURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                completionHandler?(false, nil)
                return
            }
            let musicFileURL = musicFilesURL
                .appendingPathComponent("music")
                .appendingPathComponent(name)
                .appendingPathExtension(FileType.music.rawValue)
            
            if location.pathExtension.lowercased() == musicFileURL.pathExtension.lowercased() {
                do {
                    try fileManager.moveItem(at: location, to: musicFileURL)
                    completionHandler?(true, musicFileURL)
                } catch {
                    do {
                        try fileManager.removeItem(at: location)
                    } catch {}
                    completionHandler?(false, nil)
                    return
                }
            } else {
                encodeMusicFile(at: location) { (succeeded) in
                    if succeeded {
                        do {
                            try fileManager.moveItem(at: location, to: musicFileURL)
                            completionHandler?(true, musicFileURL)
                        } catch {
                            do {
                                try fileManager.removeItem(at: location)
                            } catch {}
                            completionHandler?(false, nil)
                            return
                        }
                    } else {
                        do {
                            try fileManager.removeItem(at: location)
                        } catch {}
                        completionHandler?(false, nil)
                    }
                }
            }
        }.resume()
    }
    
    ///Returns a music file URL of the local storage. Returns nil, if there was no URL found.
    public static func getMusicFileURL(name: String) -> URL? {
        let fileManager = FileManager.default
        guard let videosURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return videosURL
            .appendingPathComponent("music")
            .appendingPathComponent(name)
            .appendingPathExtension(FileType.music.rawValue)
    }
    
    ///Deletes a music file from the local storage and returns true, if the music file was deleted successfully. Returns also false, if there was no music file with that name.
    public static func deleteMusicFileWithResult(name: String) -> Bool {
        let fileManager = FileManager.default
        guard let videosURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return false }
        let videoFileURL = videosURL
            .appendingPathComponent("music")
            .appendingPathComponent(name)
            .appendingPathExtension(FileType.music.rawValue)
        
        do {
            try fileManager.removeItem(at: videoFileURL)
            return true
        } catch {
            return false
        }
    }

    ///Deletes a music file from the local storage.
    public static func deleteMusicFile(name: String) {
        _ = deleteVideoWithResult(name: name)
    }
    
    ///Converts a music file  to an .mp4 file.   Completion handler gives back: (Succeeded).
    private static func encodeMusicFile(at musicFileURL: URL, completionHandler: ((Bool) -> Void)?)  {
        //Creating temp path to save the converted video
        let fileManager = FileManager.default
        guard let musicFilesURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            completionHandler?(false)
            return
        }
        let tempName = "\(UUID().uuidString)\(FileType.music.rawValue)"
        let tempMusicFileURL = musicFilesURL.appendingPathComponent("music").appendingPathComponent(tempName)
        //Check if the file already exists then remove the previous file
        if FileManager.default.fileExists(atPath: tempMusicFileURL.path) {
            do {
                try FileManager.default.removeItem(at: tempMusicFileURL)
            } catch {
                completionHandler?(false)
                return
            }
        }
        let avAsset = AVURLAsset(url: musicFileURL, options: nil)
        //Create Export session
        guard let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough) else {
            completionHandler?(false)
            return
        }
        exportSession.outputURL = tempMusicFileURL
        exportSession.outputFileType = AVFileType.mp3
        exportSession.shouldOptimizeForNetworkUse = true
        let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
        let range = CMTimeRangeMake(start: start, duration: avAsset.duration)
        exportSession.timeRange = range
        exportSession.exportAsynchronously() {
            switch exportSession.status {
            case .failed:
                print(exportSession.error ?? "NO ERROR")
                completionHandler?(false)
            case .cancelled:
                print("Export canceled")
                completionHandler?(false)
            case .completed:
                do {
                    try fileManager.moveItem(at: tempMusicFileURL, to: musicFileURL)
                    print("Export completed")
                    completionHandler?(true)
                } catch {
                    do {
                        try fileManager.removeItem(at: tempMusicFileURL)
                    } catch {}
                    print("File move failed")
                    completionHandler?(false)
                }
            default:
                break
            }
        }
    }
}
