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
import Lottie



class EventDetails: UIViewController, UIViewControllerTransitioningDelegate, CAAnimationDelegate {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titolo: UILabel!
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var corpo: UITextView!
    @IBOutlet weak var map: UIButton!
    @IBOutlet weak var calendarioIcona: UIButton!
    
    var salvatoInCAlendario:Bool = false
    let formatter = DateFormatter()
    let transition = CircularTransition()
    let appDelegate = UIApplication.shared.delegate
        as! AppDelegate
    var event = Events()
    let defaults = UserDefaults.standard
    let suffissoBOOL = "BOOL"
    var animazione:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        corpo.font = UIFont(name: "Lato-Regular", size: 12)
        titolo.font = UIFont(name: "VeniceCasino-Regular", size: 22)
        titolo.textColor = StyleKit.oro
        
        map.setImage(StyleKit.imageOfIconaDove(imageSize: CGSize(width: 25, height: 25), color: StyleKit.bianco), for: .normal)
        if  defaults.bool(forKey: suffissoBOOL + event.Name)  {
            salvatoInCAlendario = defaults.bool(forKey: suffissoBOOL + event.Name)
            if salvatoInCAlendario {
                calendarioIcona.setImage(StyleKit.imageOfEvents(imageSize: CGSize(width: 100, height: 100), highlited: true), for: .normal)
            } else {
                calendarioIcona.setImage(StyleKit.imageOfEvents(imageSize: CGSize(width: 100, height: 100), highlited: false), for: .normal)
            }
        } else {
            defaults.set(false, forKey: suffissoBOOL + event.Name)
        }
     
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EventDetails.handledTap))
        self.view.addGestureRecognizer(tapGesture)
        image.sd_setImage(with: URL(string: event.ImageName), placeholderImage: UIImage(named: "sediciNoni"))
        
        
        titolo.text = event.Name
        
        formatter.dateFormat = "dd MMM"
        let myDate = formatter.string(from: event.StartDate as Date)
        let myDateEnd = formatter.string(from: event.EndDate as Date)
        if (event.EndDate != event.StartDate) {
            data.text = "Dal \(myDate) al \(myDateEnd)".localized
        } else {
            data.text = myDate
        }
       
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
        let activityController = UIActivityViewController(activityItems: [image.image!,event.Name, event.URL], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var facebook: UIButton!
    func cuore() {
        let fullRotation = CGFloat(Double.pi * 2)
        let animationView = LOTAnimationView(name: "heart")
        animazione = animationView
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        animationView.center = calendarioIcona.center
        animationView.contentMode = .scaleAspectFill
        animationView.animationSpeed = 0.8
        animationView.loopAnimation = false
        view.addSubview(animationView)
        animationView.play()
        
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 1/6, 1, 1, 1)
        animation.fromValue = calendarioIcona.center.y
        animation.toValue = calendarioIcona.center.y - 50
        
        let opacita = CABasicAnimation(keyPath: "opacity")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        opacita.fromValue = 1
        opacita.toValue = 0
        
        let rot = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        rot.values = [0,1/24 * fullRotation,-1/24 * fullRotation,1/24 * fullRotation,0]
        rot.keyTimes = [0,0.15,0.3,0.55,1]
        
        let timingFunction = CAMediaTimingFunction(controlPoints: 1/6, 1, 1, 1)
        let animationDuration:TimeInterval = 2
        let animationGroup = CAAnimationGroup()
        
        animationGroup.duration = animationDuration
        animationGroup.timingFunction = timingFunction
        animationGroup.animations = [animation, opacita,rot]
        animationGroup.isRemovedOnCompletion = false
        animationGroup.fillMode = kCAFillModeBoth
        animationGroup.delegate = self
        animationView.layer.add(animationGroup, forKey: "cuore")
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        animazione?.removeFromSuperview()
    }
   
    func testoAggiungi(testoDa: String, lunghezza: CGFloat, altezza: CGFloat, ydalCentro: CGFloat) {
        let testo = EdgeInsetLabel()
        testo.text = testoDa.localized
        testo.textColor = .white
        testo.backgroundColor = .red
        testo.adjustsFontSizeToFitWidth = true
        testo.leftTextInset = 15
        testo.rightTextInset = 15
        testo.frame = CGRect(x: 0, y: 0, width: lunghezza, height: altezza)
        testo.center = view.center
        testo.textAlignment = .center
        testo.center.y += ydalCentro
        view.addSubview(testo)
        testo.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        testo.scaleInOut()
    }

    @IBAction func addEventToCalendar(_ sender: Any) {
        
        configureReminder()
        if (appDelegate.eventStore != nil) {
            if !salvatoInCAlendario {
                cuore()
                let eventToCalendar:EKEvent = EKEvent(eventStore: appDelegate.eventStore!)

                eventToCalendar.title = event.Name

                let gregorian = Calendar.current
                var componentsEnd = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: event.EndDate as Date)
                componentsEnd.hour = 23
                componentsEnd.minute = 59
                componentsEnd.second = 0
                var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: event.StartDate as Date)

                components.hour = 20
                components.minute = 30
                components.second = 0

                let dateStart = gregorian.date(from: components)
                let dateEnd = gregorian.date(from: componentsEnd)

                eventToCalendar.startDate = dateStart!
                eventToCalendar.endDate = dateEnd!
                eventToCalendar.notes = event.Description
                if event.URL != "" {
                    eventToCalendar.url = URL(string: event.URL)
                }

                eventToCalendar.calendar = appDelegate.eventStore!.defaultCalendarForNewEvents
                do {
                    try appDelegate.eventStore!.save(eventToCalendar, span: .thisEvent)
                    testoAggiungi(testoDa: "L'evento è stato aggiunto al calendario", lunghezza: 300, altezza: 50, ydalCentro: 100)
                    defaults.set(true, forKey: suffissoBOOL + event.Name)
                    salvatoInCAlendario = true
                    defaults.set(eventToCalendar.eventIdentifier, forKey: event.Name)
                    calendarioIcona.setImage(StyleKit.imageOfEvents(imageSize: CGSize(width: 100, height: 100), highlited: true), for: .normal)

                } catch let error as NSError {
                    testoAggiungi(testoDa: "L'evento non può essere salvato", lunghezza: 300, altezza: 50, ydalCentro: 100)
                    print(error.localizedDescription)
                }

            } else {
                let eventoDaRimuovere = appDelegate.eventStore?.event(withIdentifier: defaults.object(forKey: event.Name) as! String)
                do {
                    try appDelegate.eventStore?.remove(eventoDaRimuovere!, span: EKSpan.thisEvent)
                    defaults.set(false, forKey: suffissoBOOL + event.Name)
                    defaults.removeObject(forKey: event.Name)
                    defaults.removeObject(forKey: suffissoBOOL + event.Name)
                    calendarioIcona.setImage(StyleKit.imageOfEvents(imageSize: CGSize(width: 100, height: 100), highlited: false), for: .normal)
                    salvatoInCAlendario = false
                    calendarioIcona.imageView?.image = StyleKit.imageOfEvents()
                    testoAggiungi(testoDa: "L'evento è stato eliminato dal calendario!", lunghezza: 300, altezza: 50, ydalCentro: 100)
                } catch let error as NSError{
                    testoAggiungi(testoDa: "L'evento non può essere cancellato", lunghezza: 300, altezza: 50, ydalCentro: 100)
                    print(error.localizedDescription)
                }



            }
        }
        
    }
 
    @IBAction func openMaps(_ sender: Any) {
        let mapVC = storyboard?.instantiateViewController(withIdentifier: "MapView") as! MapsViewController
        mapVC.sediNome = [event.office]

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
