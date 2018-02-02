//
//  EventDetails.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 28/06/17.
//  Copyright © 2017 Casinò di Venezia SPA. All rights reserved.
//

import UIKit
import EventKit
import Social


class EventDetails: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titolo: UILabel!
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var corpo: UITextView!
    @IBOutlet weak var map: UIButton!
    
    
    let formatter = DateFormatter()
    let transition = CircularTransition()
    let appDelegate = UIApplication.shared.delegate
        as! AppDelegate
    var event = Events()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EventDetails.handledTap))
        self.view.addGestureRecognizer(tapGesture)
        image.sd_setImage(with: URL(string: event.ImageName), placeholderImage: UIImage(named: "sediciNoni"))
        
        titolo.text = event.Name
        
        formatter.dateFormat = "dd MMM"
        let myDate = formatter.string(from: event.StartDate as Date)
        data.text = myDate
        corpo.textContainerInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0);
        corpo.text = event.Description
    }
    
    func configureReminder(){
        if appDelegate.eventStore == nil {
            appDelegate.eventStore = EKEventStore()
            
            appDelegate.eventStore?.requestAccess(
                to: .event , completion: {(granted, error) in
                    if !granted {
                        print("Access to store not granted")
                        print(error?.localizedDescription as Any)
                    } else {
                        print("Access granted")
                    }
            })
        }
        
    
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func handledTap () {
       // self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func shareOnFacebook(_ sender: Any) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            post?.setInitialText(event.Name)
            post?.add(image.image)
            self.present(post!, animated: true, completion: nil)
        }
    }
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var facebook: UIButton!
   

    @IBAction func addEventToCalendar(_ sender: Any) {
        configureReminder()
        if (appDelegate.eventStore != nil) {
//            let reminder = EKReminder(eventStore: appDelegate.eventStore!)
            let eventToCalendar:EKEvent = EKEvent(eventStore: appDelegate.eventStore!)
//            
//            reminder.title = event.Name
//            reminder.calendar =
//                appDelegate.eventStore!.defaultCalendarForNewReminders()
//                let date = event.StartDate as Date
//                let alarm = EKAlarm(absoluteDate: date)
//            
//                reminder.addAlarm(alarm)
//            
//            do {
//                try appDelegate.eventStore?.save(reminder,
//                                                 commit: true)
//            } catch let error {
//                print("Reminder failed with error \(error.localizedDescription)")
//            }
 
            
            
            eventToCalendar.title = event.Name
            eventToCalendar.startDate = event.StartDate as Date
            eventToCalendar.endDate = event.EndDate as Date
            eventToCalendar.notes = event.Description
            if event.URL != "" {
               eventToCalendar.url = URL(string: event.URL)
            }
            
            eventToCalendar.calendar = appDelegate.eventStore!.defaultCalendarForNewEvents
            do {
                try appDelegate.eventStore!.save(eventToCalendar, span: .thisEvent)
            } catch let error as NSError {
                print("failed to save event with error : \(error.localizedDescription)")
                let alert = UIAlertController(title: "Event could not save", message: (error as NSError).localizedDescription, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(OKAction)
                
                self.present(alert, animated: true, completion: nil)
            }
            
            
        }
        
    }
 
    @IBAction func openMaps(_ sender: Any) {
        let mapVC = storyboard?.instantiateViewController(withIdentifier: "MapView") as! MapsViewController
        mapVC.event = self.event
        mapVC.transitioningDelegate = self
        mapVC.modalPresentationStyle = .custom
        present(mapVC, animated: true, completion: nil)
        
    }
    

    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        transition.openingFrame = self.map
        transition.origin = self.map.center
        
        return transition
        
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        transition.openingFrame = self.map
        transition.origin = self.map.center
        
        return transition
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
