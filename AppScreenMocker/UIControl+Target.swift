//
//  UIControl+Target.swift
//  AppScreenMocker
//
//  Created by Hong Duan on 8/30/16.
//  Copyright © 2016 Hong Duan. All rights reserved.
//

import UIKit

public extension UIControl {
    
    /// The registry contains a weak reference to all UIControl objects that have been given targets, the events to observe, and the closures to execute when the events are triggered.
    private static var actionRegistry = [Action]()
    
    // MARK: Public methods
    
    /// Adds a target to the receiv er for the given event, which triggers the given action.
    public func addTarget(forControlEvents: UIControlEvents, action: () -> Void) {
        self.addTarget(forEvent: forControlEvents, action: action)
    }
    
    // MARK: Private methods
    
    /// A wrapper used to maintain a weak reference to a UIControl, an event to observe, and a function to call.
    private class Action: AnyObject {
        weak var object: UIControl?
        var event: UIControlEvents
        var function: Any
        init(object: UIControl, event: UIControlEvents, function: () -> Void) {
            self.object = object
            self.event = event
            self.function = function
        }
        init(object: UIControl, event: UIControlEvents, function: (sender: UIControl) -> Void) {
            self.object = object
            self.event = event
            self.function = function
        }
    }
    
    /// Adds the target to the actual object and adds the action to the registry.
    private func addTarget(forEvent event: UIControlEvents, action: () -> Void) {
        var actionString: Selector!
        switch event {
            
            // Touch events
            
        case UIControlEvents.TouchDown:
            actionString = #selector(UIControl.touchDown(_:))
        case UIControlEvents.TouchDownRepeat:
            actionString = #selector(UIControl.touchDownRepeat(_:))
        case UIControlEvents.TouchDragInside:
            actionString = #selector(UIControl.touchDragInside(_:))
        case UIControlEvents.TouchDragOutside:
            actionString = #selector(UIControl.touchDragOutside(_:))
        case UIControlEvents.TouchDragEnter:
            actionString = #selector(UIControl.touchDragEnter(_:))
        case UIControlEvents.TouchDragExit:
            actionString = #selector(UIControl.touchDragExit(_:))
        case UIControlEvents.TouchUpInside:
            actionString = #selector(UIControl.touchUpInside(_:))
        case UIControlEvents.TouchUpOutside:
            actionString = #selector(UIControl.touchUpOutside(_:))
        case UIControlEvents.TouchCancel:
            actionString = #selector(UIControl.touchCancel(_:))
            
            // UISlider events
            
        case UIControlEvents.ValueChanged:
            actionString = #selector(UIControl.valueChanged(_:))
            
            // tvOS button events
            
        case UIControlEvents.PrimaryActionTriggered:
            actionString = #selector(UIControl.primaryActionTriggered(_:))
            
            // UITextField events
            
        case UIControlEvents.EditingDidBegin:
            actionString = #selector(UIControl.editingDidBegin(_:))
        case UIControlEvents.EditingChanged:
            actionString = #selector(UIControl.editingChanged(_:))
        case UIControlEvents.EditingDidEnd:
            actionString = #selector(UIControl.editingDidEnd(_:))
        case UIControlEvents.EditingDidEndOnExit:
            actionString = #selector(UIControl.editingDidEndOnExit(_:))
            
            // Other events
            
        case UIControlEvents.AllTouchEvents:
            actionString = #selector(UIControl.allTouchEvents(_:))
        case UIControlEvents.AllEditingEvents:
            actionString = #selector(UIControl.allEditingEvents(_:))
        case UIControlEvents.ApplicationReserved:
            actionString = #selector(UIControl.applicationReserved(_:))
        case UIControlEvents.SystemReserved:
            actionString = #selector(UIControl.systemReserved(_:))
        case UIControlEvents.AllEvents:
            actionString = #selector(UIControl.allEvents(_:))
            
        default: // Unrecognized event
            break
        }
        
        // Add the Objective-C target
        self.addTarget(self, action: actionString, forControlEvents: event)
        
        // Register action
        UIControl.registerAction(Action(object: self, event: event, function: action))
    }
    
    /// Adds an action to the registry.
    private static func registerAction(action: Action) {
        self.cleanRegistry()
        // Add action to the registry
        self.actionRegistry.append(action)
    }
    
    /// Triggers the actions for the correct control events.
    private func triggerAction(forObject: UIControl, event: UIControlEvents) {
        for action in UIControl.actionRegistry {
            if action.object == forObject && action.event == event {
                if let function = action.function as? () -> Void {
                    function()
                } else if let function = action.function as? (sender: UIControl) -> Void {
                    function(sender: forObject)
                }
            }
        }
        UIControl.cleanRegistry()
    }
    
    /// Cleans the registry, removing any actions whose object has already been released.
    /// This guarantees that no memory leaks will occur over time.
    private static func cleanRegistry() {
        UIControl.actionRegistry = UIControl.actionRegistry.filter({ $0.object != nil })
    }
    
    
    // MARK: Targets given to the Objective-C selectors
    
    @objc private func touchDown(sender: UIControl) {
        triggerAction(sender, event: .TouchDown)
    }
    @objc private func touchDownRepeat(sender: UIControl) {
        triggerAction(sender, event: .TouchDownRepeat)
    }
    @objc private func touchDragInside(sender: UIControl) {
        triggerAction(sender, event: .TouchDragInside)
    }
    @objc private func touchDragOutside(sender: UIControl) {
        triggerAction(sender, event: .TouchDragOutside)
    }
    @objc private func touchDragEnter(sender: UIControl) {
        triggerAction(sender, event: .TouchDragEnter)
    }
    @objc private func touchDragExit(sender: UIControl) {
        triggerAction(sender, event: .TouchDragExit)
    }
    @objc private func touchUpInside(sender: UIControl) {
        triggerAction(sender, event: .TouchUpInside)
    }
    @objc private func touchUpOutside(sender: UIControl) {
        triggerAction(sender, event: .TouchUpOutside)
    }
    @objc private func touchCancel(sender: UIControl) {
        triggerAction(sender, event: .TouchCancel)
    }
    @objc private func valueChanged(sender: UIControl) {
        triggerAction(sender, event: .ValueChanged)
    }
    @objc private func primaryActionTriggered(sender: UIControl) {
        triggerAction(sender, event: .PrimaryActionTriggered)
    }
    @objc private func editingDidBegin(sender: UIControl) {
        triggerAction(sender, event: .EditingDidBegin)
    }
    @objc private func editingChanged(sender: UIControl) {
        triggerAction(sender, event: .EditingChanged)
    }
    @objc private func editingDidEnd(sender: UIControl) {
        triggerAction(sender, event: .EditingDidEnd)
    }
    @objc private func editingDidEndOnExit(sender: UIControl) {
        triggerAction(sender, event: .EditingDidEndOnExit)
    }
    @objc private func allTouchEvents(sender: UIControl) {
        triggerAction(sender, event: .AllTouchEvents)
    }
    @objc private func allEditingEvents(sender: UIControl) {
        triggerAction(sender, event: .AllEditingEvents)
    }
    @objc private func applicationReserved(sender: UIControl) {
        triggerAction(sender, event: .ApplicationReserved)
    }
    @objc private func systemReserved(sender: UIControl) {
        triggerAction(sender, event: .SystemReserved)
    }
    @objc private func allEvents(sender: UIControl) {
        triggerAction(sender, event: .AllEvents)
    }
    
}