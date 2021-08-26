//
//  ViewController.swift
//  MacTextFileSorter
//
//  Created by Templeton, Evan on 8/20/21.
//

import Cocoa

class ViewController: NSViewController {

    let filesManager: FilesManager = FilesManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filesManager.parseFile()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

