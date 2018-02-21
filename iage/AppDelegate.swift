//
//  AppDelegate.swift
//  iage
//
//  Created by Александр Комаров on 20.02.2018.
//  Copyright © 2018 Александр Комаров. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength:100)
    weak var timer: Timer?
    var birthYear: Int = UserDefaults().integer(forKey: "year") {
        didSet {
            UserDefaults().set(birthYear, forKey: "year")
        }
    }
    var birthMonth: Int = UserDefaults().integer(forKey: "month") {
        didSet {
            UserDefaults().set(birthMonth, forKey: "month")
        }
    }
    var birthDay: Int = UserDefaults().integer(forKey: "date") {
        didSet {
            UserDefaults().set(birthDay, forKey: "date")
        }
    }
    var birth: Date? = nil
    let popover = NSPopover()
    var button: NSStatusBarButton? = nil
    var eventMonitor: EventMonitor?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        var dateComponents = DateComponents()
        dateComponents.year = birthYear
        dateComponents.month = birthMonth
        dateComponents.day = birthDay
        popover.contentViewController = IageViewController.freshController()
        
        if let btn = statusItem.button {
            button = btn
            btn.title = "iage"
            btn.action = #selector(togglePopover(_:))
        }
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(sender: event)
            }
        }
        
        if (birthDay == 0) {
            showPopover(sender: nil)
        } else {
            birth = Calendar.current.date(from: dateComponents)
            startTimer()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        timer?.invalidate()
    }
    
    func refresh() {
        var dateComponents = DateComponents()
        dateComponents.year = birthYear
        dateComponents.month = birthMonth
        dateComponents.day = birthDay
        birth = Calendar.current.date(from: dateComponents)
        print(birthYear)
        startTimer()
    }
    
    func startTimer() {
        if let btn = button {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { _ in
                if let birthTimestamp = self.birth?.timeIntervalSince1970 {
                    let diff = Date().timeIntervalSince1970 - birthTimestamp
                    let years = diff / 3.154e+7
                    btn.title = String(format: "%.8f", years)
                }
            })
        }
    }
    
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        eventMonitor?.start()
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
}

