//
//  FilesManager.swift
//  MacTextFileSorter
//
//  Created by Templeton, Evan on 8/20/21.
//

import Cocoa

class FilesManager: NSObject {
    
    var fileManager: FileManager
    var inputFilesPath: URL
    var documentsPath: URL
    
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
        self.documentsPath = fileManager.homeDirectoryForCurrentUser.appendingPathComponent("Documents")
        self.inputFilesPath = documentsPath.appendingPathComponent("input_files")
        // inputFilesPath  = /Users/temevan/Library/Containers/com.evantempleton.MacTextFileSorter/Data/Documents/input_files/
        // outputFilesPath = /Users/temevan/Library/Containers/com.evantempleton.MacTextFileSorter/Data/Documents/
        
    }
    
    func parseFile() {
        
        let enumerator = fileManager.enumerator(atPath: inputFilesPath.path)
        var lineArray: [String] = []
        
        while let file = enumerator?.nextObject() {
            
            let fileURL = inputFilesPath.appendingPathComponent(file as! String)
            
            // make sure there's a file
            guard fileManager.fileExists(atPath: fileURL.path) else {
                preconditionFailure("No file at \(fileURL.absoluteString)")
            }
            
            guard let filePointer: UnsafeMutablePointer<FILE> = fopen(fileURL.path, "r") else {
                preconditionFailure("Could not open file at \(fileURL.absoluteString)")
            }
            
            // don't parse the freaking .DS_Store
            guard fileURL.lastPathComponent != ".DS_Store" else { continue }
            
            var lineByteArrayPointer: UnsafeMutablePointer<CChar>? = nil
            var lineCap = 0
            var bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
            
            // close file
            defer { fclose(filePointer) }
            
            // (bytesRead > 1) should get rid of blank lines, but something else is going on
            while (bytesRead > 0) {
                // get the line
                var lineAsString = (String.init(cString: lineByteArrayPointer!))
                // if line doesn't have \n (last line in file), add it
                if !lineAsString.hasSuffix("\n") { lineAsString.append("\n")}
                // filter out whitespace & add line to array
                if lineAsString != "\n" && lineAsString != "" { lineArray.append(lineAsString) }
                
                bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
                
                // TODO: Create a map to store the lineByteArrayPointer's position
            }
        }
        // sort lines & write to output file
        print(lineArray.sorted().joined())
        writeFile(lineArray.sorted().joined())
    }
    
    
    func writeFile(_ outputString: String) {
        
        let outputFile = "output.txt"
        let fileURL = documentsPath.appendingPathComponent(outputFile)
        
        // if output.txt doesn't exist, create it
        if !fileManager.fileExists(atPath: fileURL.path) {
            fileManager.createFile(atPath: fileURL.path, contents:Data("".utf8), attributes: nil)
        } else {
            // TODO: If the file already exists, the program never stops. Figure that out.
        }
        
        do {
            let fileHandle = try FileHandle(forWritingTo: fileURL)
            // navigate to end of file (used for handling infinite input file length)
            fileHandle.seekToEndOfFile()
            // write the line & close file
            fileHandle.write(outputString.data(using: .utf8)!)
            fileHandle.closeFile()
        } catch {
            print(error)
        }
        
    }
}

