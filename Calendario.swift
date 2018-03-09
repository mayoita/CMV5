//
//  Calendario.swift
//  Casinò di Venezia
//
//  Created by Massimo Moro on 27/02/18.
//  Copyright © 2018 Casinò di Venezia SPA. All rights reserved.
//

import UIKit
import JTAppleCalendar
class Calendario: UICollectionViewCell {
    
    @IBOutlet weak var apri: UIButton!
    @IBOutlet weak var dettaglioSede: UILabel!
    @IBOutlet weak var dettaglioTitolo: UILabel!
    @IBOutlet weak var dettaglioImmagine: UIImageView!
    @IBOutlet weak var dettaglio: UIView! {
        didSet{
            dettaglio.frame.origin.y -= dettaglio.frame.height
        }
    }
    @IBOutlet weak var anno: UILabel!
    @IBOutlet weak var mese: UILabel!
    @IBOutlet weak var collectionCalendario: JTAppleCalendarView! {
        didSet {
            collectionCalendario.calendarDelegate = self
            collectionCalendario.calendarDataSource = self
            //collectionCalendario?.register(CalendarCell.self, forCellWithReuseIdentifier: cellaCalendario)
            collectionCalendario?.register(UINib(nibName: "CalendarCell", bundle: nil), forCellWithReuseIdentifier: cellaCalendario)
        }
    }
    
    @IBOutlet weak var lun: UILabel!
    @IBOutlet weak var mar: UILabel!
    @IBOutlet weak var mer: UILabel!
    @IBOutlet weak var gio: UILabel!
    @IBOutlet weak var ven: UILabel!
    @IBOutlet weak var sab: UILabel!
    @IBOutlet weak var dom: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var altezzaCalendario: NSLayoutConstraint!
    @IBOutlet weak var margineTop: NSLayoutConstraint!
    
   let cellaCalendario = "CalendarioCella"
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MM yyyy"
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Locale(identifier: Locale.preferredLanguages[0])
        
        return dateFormatter
    }()
    let outsideMonthColor = UIColor(colorWithHexValue: 0x584a66)
    let monthColor = UIColor.white
    let selectedMonthColor = UIColor(colorWithHexValue: 0x3a294b)
    let currentDateSelectedViewColor = UIColor(colorWithHexValue: 0x4e3f5d)
    let oggi = UIColor(colorWithHexValue: 0xdfC68A)
    let coloreCella = UIColor(colorWithHexValue: 0x847552)
    var eventiDictionary: [String:String] = [:]
    var feedArray = [Events]()
    var bannerVisibile:Bool = false
    var startDateCalendar = Date()
    var endDateCalendar = Date()
    var totaleEventi:[Events] = []
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var eventoScelto:Events?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func awakeFromNib() {
        creaListaGiorni()
        fetchDatabase()
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func apriEvento(_ sender: Any) {
        let expandedVC = storyboard.instantiateViewController(withIdentifier: "EventDetails") as! EventDetails
        
        expandedVC.event = eventoScelto!
        
        if let keyWindow = UIApplication.shared.keyWindow?.rootViewController {
            keyWindow.present(expandedVC, animated: true, completion: nil)
        }
        
    }
    func creaListaGiorni() {
        if let keyWindow = UIApplication.shared.keyWindow {
            if isIPhoneX() {
                let margine:CGFloat = 15.0
                let height = keyWindow.frame.height - 88 - 50 - 45 - 20 - 80 - margine
                altezzaCalendario.constant = height
                margineTop.constant = margine
            } else {
                let height = keyWindow.frame.height - 64 - 50 - 45 - 20 - 80
                altezzaCalendario.constant = height
            }
        }
        let lunedi = formatter.date(from: "01 01 2018")
        formatter.dateFormat = "E"
        lun.text = formatter.string(from: lunedi!)
        mar.text = formatter.string(from: Calendar.current.date(byAdding: .day, value: 1, to: lunedi!)!)
        mer.text = formatter.string(from: Calendar.current.date(byAdding: .day, value: 2, to: lunedi!)!)
        gio.text = formatter.string(from: Calendar.current.date(byAdding: .day, value: 3, to: lunedi!)!)
        ven.text = formatter.string(from: Calendar.current.date(byAdding: .day, value: 4, to: lunedi!)!)
        sab.text = formatter.string(from: Calendar.current.date(byAdding: .day, value: 5, to: lunedi!)!)
        dom.text = formatter.string(from: Calendar.current.date(byAdding: .day, value: 6, to: lunedi!)!)
        apri.setTitle("APRI".localized, for: .normal)
    }
    func fetchDatabase () {
        LoadDatabase.sharedInstance.loadDatabase { (eventi: [Events]) in
            self.formatter.dateFormat = "dd MM yyyy"
            for evento in eventi {
                let stringData = self.formatter.string(from: evento.StartDate as Date)
                self.eventiDictionary[stringData] = evento.Name
            }
            self.feedArray = eventi
            self.feedArray.sort(by: { $0.StartDate.compare($1.StartDate as Date) == ComparisonResult.orderedDescending })
            for evento in self.feedArray {
                var start = evento.StartDate as Date
                let end = evento.EndDate as Date
                let calendario = NSCalendar.current
                evento.eventoOriginale = evento
                self.totaleEventi.append(evento)
                
                while start  < end  {
                    
                    start = calendario.date(byAdding: .day, value: 1, to: start)!
                    let eventoDaAggiungere = Events(Book: evento.Book, Description: evento.Description, ImageEvent1: evento.ImageEvent1, ImageEvent2: evento.ImageEvent2, ImageEvent3: evento.ImageEvent3, ImageName: evento.ImageName, isSlotEvents: evento.isSlotEvents, memo: evento.memo, Name: evento.Name, StartDate: start as NSDate, EndDate: evento.EndDate, EventType: evento.EventType, office: evento.office, URL: evento.URL, URLBook: evento.URLBook)
                    
                    eventoDaAggiungere.eventoOriginale = evento
                    self.totaleEventi.append(eventoDaAggiungere)
                }
                
            }
            self.setupCalendarView()
        }
    }
    func setupCalendarView() {
        collectionCalendario.scrollToDate(Date(), animateScroll: false)
        collectionCalendario.selectDates([Date()])
        collectionCalendario.minimumLineSpacing = 0
        collectionCalendario.minimumInteritemSpacing = 0
        collectionCalendario.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }
    func configureCell(cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCell else { return }
        //handleCellSelected(cell: validCell, cellState: cellState)
        handleCellTextColor(cell: validCell, cellState: cellState)
      
    }
    func handleCellTextColor(cell: CalendarCell, cellState: CellState) {
       
        if cellState.isSelected {
            cell.giorno.textColor = selectedMonthColor
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                cell.giorno.textColor = monthColor
            } else {
                cell.giorno.textColor = outsideMonthColor
            }
        }
    }
    func handledEventoCell(cell: CalendarCell, cellState: CellState, indexPath: IndexPath) {
        formatter.dateFormat = "dd MM yyyy"
        cell.backgroundColor = coloreCella
        cell.contenitoreEventi.isHidden = true
        cell.eventi = []
       
        for evento in totaleEventi {
            let dataEvento = formatter.string(from: evento.StartDate as Date)
            let dataCalendario = formatter.string(from: cellState.date)
            
            if dataEvento == dataCalendario {
                cell.eventi.append(evento)
                popolaGiornoconEventi(cella: cell)
                cell.contenitoreEventi.isHidden = false
                cell.backgroundColor = oggi
            }
        }
        if cellState.isSelected {
            cell.backgroundColor = oggi
        }
    }
    func popolaGiornoconEventi(cella: CalendarCell) {
    
        let altezzaDisponibileCella = cella.contenitoreEventi.frame.height
        let width = cella.contenitoreEventi.frame.width
        var height = (width / 16 ) * 9
        for viewSub in cella.contenitoreEventi.subviews {
            viewSub.removeFromSuperview()
        }
        for (index,evento) in cella.eventi.enumerated() {
            let posizioneY = cella.contenitoreEventi.frame.height - height * CGFloat(index + 1)
            let eventoIm = CalendarImageView(frame: CGRect(x: 0, y: posizioneY, width: width, height: height), evento: evento)

            eventoIm.sd_setImage(with: URL(string: evento.ImageName), placeholderImage: UIImage(named: "sediciNoni"))
            if (altezzaDisponibileCella / CGFloat(cella.eventi.count) < height) {
                height = altezzaDisponibileCella / CGFloat(cella.eventi.count)
            }
            let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
            eventoIm.isUserInteractionEnabled = true
            eventoIm.addGestureRecognizer(tap)
           
            cella.contenitoreEventi.addSubview(eventoIm)
        
        }
        
        
    }
    
    func imageTapped(_ sender: UITapGestureRecognizer) {
        let image = sender.view as! CalendarImageView
        impostaBanner(evento:image.evento)
        eventoScelto = image.evento?.eventoOriginale
    }
    
    func handleCellSelected(cell: CalendarCell, cellState: CellState) {

        if cell.isSelected {
            cell.backgroundColor = oggi
        } else {
            cell.backgroundColor = coloreCella
        }
    }
}
extension Calendario: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {

    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState )
    }

    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: cellaCalendario, for: indexPath) as! CalendarCell
        cell.giorno.text = cellState.text
        configureCell(cell: cell, cellState: cellState)
        cell.contenitoreEventi.isHidden = true
        handledEventoCell(cell: cell, cellState: cellState, indexPath: indexPath)

        return cell
    }

    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        startDateCalendar = formatter.date(from: "01 01 2017")!
        endDateCalendar = formatter.date(from: "31 12 2018")!
       
        let parameters = ConfigurationParameters(startDate: startDateCalendar, endDate: endDateCalendar,firstDayOfWeek: DaysOfWeek(rawValue: 2))
        return parameters
    }
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
    }
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
     
        self.formatter.dateFormat = "yyyy"
        self.anno.text = self.formatter.string(from: date)
        self.formatter.dateFormat = "MMMM"
        self.mese.text = self.formatter.string(from: date)
    }
    func impostaBanner(evento: Events?) {
        
        if bannerVisibile {
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.dettaglio.frame.origin.y -= self.dettaglio.frame.height
            }) {completata in
                self.mostraBanner(evento: evento)
            }
        } else {
            bannerVisibile = !bannerVisibile
            mostraBanner(evento: evento)
        }
    }
    func mostraBanner (evento: Events?) {
        self.dettaglioImmagine.sd_setImage(with: URL(string: (evento?.ImageName)!), placeholderImage: UIImage(named: "sediciNoni"))
        self.dettaglioTitolo.text = evento?.Name
        self.dettaglioTitolo.clipsToBounds = true
        self.dettaglioSede.text = sedi[(evento?.office)!]
        
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.dettaglio.isHidden = false
            self.dettaglio.frame.origin.y += self.dettaglio.frame.height
        }) {completata in
            
        }
    }
}


