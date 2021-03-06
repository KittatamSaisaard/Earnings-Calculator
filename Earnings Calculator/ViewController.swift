//
//  ViewController.swift
//  Earnings Calculator
//
//  Created by Kittatam Saisaard on 20/1/21.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var Monday: Day!
    @IBOutlet weak var Tuesday: Day!
    @IBOutlet weak var Wednesday: Day!
    @IBOutlet weak var Thursday: Day!
    @IBOutlet weak var Friday: Day!
    @IBOutlet weak var Saturday: Day!
    @IBOutlet weak var Sunday: Day!
    
    @IBOutlet weak var ordinaryPay: UITextField!
    @IBOutlet weak var monToFriAfterSixPMBeforeElevenPMPay: UITextField!
    @IBOutlet weak var saturdayPay: UITextField!
    @IBOutlet weak var sundayPay: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ordinaryPay.delegate = self
        monToFriAfterSixPMBeforeElevenPMPay.delegate = self
        saturdayPay.delegate = self
        sundayPay.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
        Monday.day.text = "Monday"
        Tuesday.day.text = "Tuesday"
        Wednesday.day.text = "Wednesday"
        Thursday.day.text = "Thursday"
        Friday.day.text = "Friday"
        Saturday.day.text = "Saturday"
        Sunday.day.text = "Sunday"
        
        fetchCoreData()
        
        calculate()
    }
     
    @IBOutlet weak var grossEarnings: UILabel!
    @IBOutlet weak var tax: UILabel!
    @IBOutlet weak var netEarnings: UILabel!
    
    @IBAction func calculateButton(_ sender: Any) {
        calculate()
        saveCoreData()
    }
    
    func saveCoreData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContent = appDelegate.persistentContainer.viewContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "Rates")
        do {
            let result = try managedContent.fetch(fetchRequest)

            (result.last as! NSManagedObject).setValue((ordinaryPay.text! as NSString).doubleValue, forKey: "ordinaryPay")
            (result.last as! NSManagedObject).setValue((monToFriAfterSixPMBeforeElevenPMPay.text! as NSString).doubleValue, forKey: "monToFriAfterSixPMBeforeElevenPMPay")
            (result.last as! NSManagedObject).setValue((saturdayPay.text! as NSString).doubleValue, forKey: "saturdayPay")
            (result.last as! NSManagedObject).setValue((sundayPay.text! as NSString).doubleValue, forKey: "sundayPay")
            
            (result.last as! NSManagedObject).setValue(Monday.toggleSwitch.isOn, forKey: "mondaySelected")
            (result.last as! NSManagedObject).setValue(Monday.inTime.date, forKey: "mondayInTime")
            (result.last as! NSManagedObject).setValue(Monday.outTime.date, forKey: "mondayOutTime")
            
            (result.last as! NSManagedObject).setValue(Tuesday.toggleSwitch.isOn, forKey: "tuesdaySelected")
            (result.last as! NSManagedObject).setValue(Tuesday.inTime.date, forKey: "tuesdayInTime")
            (result.last as! NSManagedObject).setValue(Tuesday.outTime.date, forKey: "tuesdayOutTime")
            
            (result.last as! NSManagedObject).setValue(Wednesday.toggleSwitch.isOn, forKey: "wednesdaySelected")
            (result.last as! NSManagedObject).setValue(Wednesday.inTime.date, forKey: "wednesdayInTime")
            (result.last as! NSManagedObject).setValue(Wednesday.outTime.date, forKey: "wednesdayOutTime")
            
            (result.last as! NSManagedObject).setValue(Thursday.toggleSwitch.isOn, forKey: "thursdaySelected")
            (result.last as! NSManagedObject).setValue(Thursday.inTime.date, forKey: "thursdayInTime")
            (result.last as! NSManagedObject).setValue(Thursday.outTime.date, forKey: "thursdayOutTime")
            
            (result.last as! NSManagedObject).setValue(Friday.toggleSwitch.isOn, forKey: "fridaySelected")
            (result.last as! NSManagedObject).setValue(Friday.inTime.date, forKey: "fridayInTime")
            (result.last as! NSManagedObject).setValue(Friday.outTime.date, forKey: "fridayOutTime")
            
            (result.last as! NSManagedObject).setValue(Saturday.toggleSwitch.isOn, forKey: "saturdaySelected")
            (result.last as! NSManagedObject).setValue(Saturday.inTime.date, forKey: "saturdayInTime")
            (result.last as! NSManagedObject).setValue(Saturday.outTime.date, forKey: "saturdayOutTime")
            
            (result.last as! NSManagedObject).setValue(Sunday.toggleSwitch.isOn, forKey: "sundaySelected")
            (result.last as! NSManagedObject).setValue(Sunday.inTime.date, forKey: "sundayInTime")
            (result.last as! NSManagedObject).setValue(Sunday.outTime.date, forKey: "sundayOutTime")
            
            //print(result.count)
        } catch {
            print("Error")
        }
        
        do {
            try managedContent.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchCoreData() {
        ordinaryPay.text = String(27.24)
        monToFriAfterSixPMBeforeElevenPMPay.text = String(31.60)
        saturdayPay.text = String(32.69)
        sundayPay.text = String(38.13)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContent = appDelegate.persistentContainer.viewContext
        let fetchRequest  = NSFetchRequest<NSFetchRequestResult>(entityName: "Rates")
        do {
//  Uncomment to erase the last element in CoreData
//            let resultTemp = try managedContent.fetch(fetchRequest)
//            managedContent.delete(resultTemp.last as! NSManagedObject)
            let result = try managedContent.fetch(fetchRequest)
            if (result.count == 0) {
                let ratesEntity = NSEntityDescription.entity(forEntityName: "Rates", in: managedContent)!
                let rates = NSManagedObject(entity: ratesEntity, insertInto: managedContent)
                rates.setValue((ordinaryPay.text! as NSString).doubleValue, forKey: "ordinaryPay")
                rates.setValue((monToFriAfterSixPMBeforeElevenPMPay.text! as NSString).doubleValue, forKey: "monToFriAfterSixPMBeforeElevenPMPay")
                rates.setValue((saturdayPay.text! as NSString).doubleValue, forKey: "saturdayPay")
                rates.setValue((sundayPay.text! as NSString).doubleValue, forKey: "sundayPay")
                
                
                rates.setValue(Monday.toggleSwitch.isOn, forKey: "mondaySelected")
                rates.setValue(Monday.inTime.date, forKey: "mondayInTime")
                rates.setValue(Monday.outTime.date, forKey: "mondayOutTime")
                
                rates.setValue(Tuesday.toggleSwitch.isOn, forKey: "tuesdaySelected")
                rates.setValue(Tuesday.inTime.date, forKey: "tuesdayInTime")
                rates.setValue(Tuesday.outTime.date, forKey: "tuesdayOutTime")
                
                rates.setValue(Wednesday.toggleSwitch.isOn, forKey: "wednesdaySelected")
                rates.setValue(Wednesday.inTime.date, forKey: "wednesdayInTime")
                rates.setValue(Wednesday.outTime.date, forKey: "wednesdayOutTime")
                
                rates.setValue(Thursday.toggleSwitch.isOn, forKey: "thursdaySelected")
                rates.setValue(Thursday.inTime.date, forKey: "thursdayInTime")
                rates.setValue(Thursday.outTime.date, forKey: "thursdayOutTime")
                
                rates.setValue(Friday.toggleSwitch.isOn, forKey: "fridaySelected")
                rates.setValue(Friday.inTime.date, forKey: "fridayInTime")
                rates.setValue(Friday.outTime.date, forKey: "fridayOutTime")
                
                rates.setValue(Saturday.toggleSwitch.isOn, forKey: "saturdaySelected")
                rates.setValue(Saturday.inTime.date, forKey: "saturdayInTime")
                rates.setValue(Saturday.outTime.date, forKey: "saturdayOutTime")
                
                rates.setValue(Sunday.toggleSwitch.isOn, forKey: "sundaySelected")
                rates.setValue(Sunday.inTime.date, forKey: "sundayInTime")
                rates.setValue(Sunday.outTime.date, forKey: "sundayOutTime")
                
                do {
                    try managedContent.save()
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
            } else {
                ordinaryPay.text = String(format: "%@", (result.last as! NSManagedObject).value(forKey: "ordinaryPay") as! CVarArg)
                monToFriAfterSixPMBeforeElevenPMPay.text = String(format: "%@", (result.last as! NSManagedObject).value(forKey: "monToFriAfterSixPMBeforeElevenPMPay") as! CVarArg)
                saturdayPay.text = String(format: "%@", (result.last as! NSManagedObject).value(forKey: "saturdayPay") as! CVarArg)
                sundayPay.text = String(format: "%@", (result.last as! NSManagedObject).value(forKey: "sundayPay") as! CVarArg)
                
                let mondayToggled = (result.last as! NSManagedObject).value(forKey: "mondaySelected") as! Bool
                Monday.toggleSwitch.isOn = mondayToggled
                Monday.dayOffToggle = !mondayToggled
                Monday.toggleDayForced(toggle: (result.last as! NSManagedObject).value(forKey: "mondaySelected") as! Bool)
                Monday.inTime.date = (result.last as! NSManagedObject).value(forKey: "mondayInTime") as! Date
                Monday.outTime.date = (result.last as! NSManagedObject).value(forKey: "mondayOutTime") as! Date
                
                let tuesdayToggled = (result.last as! NSManagedObject).value(forKey: "tuesdaySelected") as! Bool
                Tuesday.toggleSwitch.isOn = tuesdayToggled
                Tuesday.dayOffToggle = !tuesdayToggled
                Tuesday.toggleDayForced(toggle: (result.last as! NSManagedObject).value(forKey: "tuesdaySelected") as! Bool)
                Tuesday.inTime.date = (result.last as! NSManagedObject).value(forKey: "tuesdayInTime") as! Date
                Tuesday.outTime.date = (result.last as! NSManagedObject).value(forKey: "tuesdayOutTime") as! Date
                
                let wednesdayToggled = (result.last as! NSManagedObject).value(forKey: "wednesdaySelected") as! Bool
                Wednesday.toggleSwitch.isOn = wednesdayToggled
                Wednesday.dayOffToggle = !wednesdayToggled
                Wednesday.toggleDayForced(toggle: (result.last as! NSManagedObject).value(forKey: "wednesdaySelected") as! Bool)
                Wednesday.inTime.date = (result.last as! NSManagedObject).value(forKey: "wednesdayInTime") as! Date
                Wednesday.outTime.date = (result.last as! NSManagedObject).value(forKey: "wednesdayOutTime") as! Date

                let thursdayToggled = (result.last as! NSManagedObject).value(forKey: "thursdaySelected") as! Bool
                Thursday.toggleSwitch.isOn = thursdayToggled
                Thursday.dayOffToggle = !thursdayToggled
                Thursday.toggleDayForced(toggle: (result.last as! NSManagedObject).value(forKey: "thursdaySelected") as! Bool)
                Thursday.inTime.date = (result.last as! NSManagedObject).value(forKey: "thursdayInTime") as! Date
                Thursday.outTime.date = (result.last as! NSManagedObject).value(forKey: "thursdayOutTime") as! Date
                
                let fridayToggled = (result.last as! NSManagedObject).value(forKey: "fridaySelected") as! Bool
                Friday.toggleSwitch.isOn = fridayToggled
                Friday.dayOffToggle = !fridayToggled
                Friday.toggleDayForced(toggle: (result.last as! NSManagedObject).value(forKey: "fridaySelected") as! Bool)
                Friday.inTime.date = (result.last as! NSManagedObject).value(forKey: "fridayInTime") as! Date
                Friday.outTime.date = (result.last as! NSManagedObject).value(forKey: "fridayOutTime") as! Date
                
                let saturdayToggled = (result.last as! NSManagedObject).value(forKey: "saturdaySelected") as! Bool
                Saturday.toggleSwitch.isOn = saturdayToggled
                Saturday.dayOffToggle = !saturdayToggled
                Saturday.toggleDayForced(toggle: (result.last as! NSManagedObject).value(forKey: "saturdaySelected") as! Bool)
                Saturday.inTime.date = (result.last as! NSManagedObject).value(forKey: "saturdayInTime") as! Date
                Saturday.outTime.date = (result.last as! NSManagedObject).value(forKey: "saturdayOutTime") as! Date

                let sundayToggled = (result.last as! NSManagedObject).value(forKey: "sundaySelected") as! Bool
                Sunday.toggleSwitch.isOn = sundayToggled
                Sunday.dayOffToggle = !sundayToggled
                Sunday.toggleDayForced(toggle: (result.last as! NSManagedObject).value(forKey: "sundaySelected") as! Bool)
                Sunday.inTime.date = (result.last as! NSManagedObject).value(forKey: "sundayInTime") as! Date
                Sunday.outTime.date = (result.last as! NSManagedObject).value(forKey: "sundayOutTime") as! Date
            }
        } catch {
            print("Error")
        }
    }
    
    @IBOutlet weak var totalHoursWorked: UILabel!
    
    func calculate() {
        Monday.payRate = (ordinaryPay.text! as NSString).doubleValue
        Monday.updateResults()
        Tuesday.payRate = (ordinaryPay.text! as NSString).doubleValue
        Tuesday.updateResults()
        Wednesday.payRate = (ordinaryPay.text! as NSString).doubleValue
        Wednesday.updateResults()
        Thursday.payRate = (ordinaryPay.text! as NSString).doubleValue
        Thursday.updateResults()
        Friday.payRate = (ordinaryPay.text! as NSString).doubleValue
        Friday.updateResults()
        Saturday.payRate = (saturdayPay.text! as NSString).doubleValue
        Saturday.updateResults()
        Saturday.weekDay = false
        Sunday.payRate = (sundayPay.text! as NSString).doubleValue
        Sunday.updateResults()
        Sunday.weekDay = false
        
        let totalIncome = calculateTotalPay()
        let totalTax = calculateTotalTax(income: totalIncome)
        let totalHours = calculateTotalHours()
        
        grossEarnings.text = "Gross Earnings: $" + String(format: "%.2f", totalIncome)
        tax.text = "Tax: $" + String(totalTax)
        netEarnings.text = "Net Earnings: $" + String(format: "%.2f", totalIncome - Double(totalTax))
        totalHoursWorked.text = "Total Hours Worked: " + String(format: "%.2f", totalHours)
    }
    
    func calculateTotalPay() -> Double {
        let ordinaryPay = Monday.payAmount + Tuesday.payAmount + Wednesday.payAmount + Thursday.payAmount + Friday.payAmount + Saturday.payAmount
        return ordinaryPay + Sunday.payAmount
    }
    
    func calculateTotalHours() -> Double {
        return Monday.totalHours + Tuesday.totalHours + Thursday.totalHours + Friday.totalHours + Saturday.totalHours + Sunday.totalHours
    }
    
    func calculateTotalTax(income: Double) -> Int {
        let truncIncome = trunc(income)
        if (truncIncome < 359){
            return 0
        } else if (truncIncome < 438) {
            return Int(round(0.1900 * (trunc(truncIncome)+0.99) - 68.3462))
        } else if (truncIncome < 548) {
            return Int(round(0.2900 * (trunc(truncIncome)+0.99) - 112.1942))
        } else if (truncIncome < 721) {
            return Int(round(0.2100 * (trunc(truncIncome)+0.99) - 68.3465))
        } else if (truncIncome < 865) {
            return Int(round(0.2190 * (trunc(truncIncome)+0.99) - 74.8369))
        } else if (truncIncome < 1282) {
            return Int(round(0.3477 * (trunc(truncIncome)+0.99) - 186.2119))
        } else if (truncIncome < 2307) {
            return Int(round(0.3450 * (trunc(truncIncome)+0.99) - 182.7504))
        } else if (truncIncome < 3461) {
            return Int(round(0.3900 * (trunc(truncIncome)+0.99) - 286.5965))
        } else {
            return Int(round(0.4700 * (trunc(truncIncome)+0.99) - 563.5196))
        }
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIViewController {

    @objc func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

