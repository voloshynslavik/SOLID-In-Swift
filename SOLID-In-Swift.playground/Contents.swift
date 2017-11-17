//: # **SOLID Principles**

import Foundation
import UIKit

//: ## Single Responsibility Principle(SRP)
//: ### ❌ Incorrect
class PersonInc {
    let name: String
    let phoneNumber: String
    let phoneNumberCode: String

    init(name: String, phoneNumber: String, phoneNumberCode: String) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.phoneNumberCode = phoneNumberCode
    }

    func getFullPhoneNumber() -> String {
        return phoneNumberCode + phoneNumber
    }

    func printInfo() {
        print("Name - \(name)")
        print("Phone number - \(getFullPhoneNumber())")
    }
}

let personInc = PersonInc(name: "Bad SRP", phoneNumber: "+372", phoneNumberCode: "53726678")
personInc.printInfo()


//: ### ✅ Correct
class Person {
    let name: String
    let phoneNumber: PhoneNumber

    init(name: String, phoneNumber: PhoneNumber) {
        self.name = name
        self.phoneNumber = phoneNumber
    }

}

class PhoneNumber {

    let number: String
    let code: String

    init(number: String, code: String) {
        self.number = number
        self.code = code
    }

    func getFullNumber() -> String {
        return number + code
    }
}

class PersonInfoPrinter {

    func printInfo(for person: Person) {
        print("Name - \(person.name)")
        print("Phone number - \(person.phoneNumber.getFullNumber())")
    }

}

let phoneNumber = PhoneNumber(number: "53726678", code: "+372")
let person = Person(name: "Good SRP", phoneNumber: phoneNumber)
let personInfoPrinter = PersonInfoPrinter()
personInfoPrinter.printInfo(for: person)


//: ## The Open Closed Principle (OCP)
//: ### ❌ Incorrect

struct RectangleInc {
    let width: Double
    let height: Double

    var area: Double {
        return width * height
    }
}

struct CircleInc {
    let radius: Double

    var area: Double {
        return 2 * Double.pi * radius * radius
    }
}

class AreaSumCalculatorInc {

    class func calculate(items: Any...) -> Double {
        return items.reduce(0.0, { (value, item) -> Double in
            if let rect = item as? RectangleInc {
                return rect.area + value
            }
            else if let circle = item as? CircleInc {
                return circle.area + value
            }
            return value
        })
    }

}

let irect = RectangleInc(width: 25.3, height: 12.43)
let icircle = CircleInc(radius: 10.0)

let iareaSum = AreaSumCalculatorInc.calculate(items: irect, icircle)

//: ### ✅ Correct

protocol Area {
    var area: Double { get }
}

struct Rectangle: Area {
    let width: Double
    let height: Double

    var area: Double {
        return width * height
    }
}

struct Circle: Area {
    let radius: Double

    var area: Double {
        return 2 * Double.pi * radius * radius
    }
}

class AreaSumCalculator {

    class func calculate(areas: Area ...) -> Double {
        return areas.reduce(0.0, { $0 + $1.area })
    }

}

let rect = Rectangle(width: 25.3, height: 12.43)
let circle = Circle(radius: 10.0)

let areaSum = AreaSumCalculator.calculate(areas: rect, circle)


//: ## Liskov Substitution Principle(LSP)
//: ### ❌ Incorrect

class CustomViewInc: UIView {

    override func addSubview(_ view: UIView) {
        if view.frame.size.width > 0 && view.frame.size.height > 0 {
            super.addSubview(view)
        }
    }
}

let zeroViewInc = UIView(frame: .zero)

let customViewInc = CustomViewInc()
customViewInc.addSubview(zeroViewInc)


//: ### ✅ Correct
class CustomView: UIView {

    func addSubviewIfNotZero(_ view: UIView) {
        if view.frame.size.width > 0 && view.frame.size.height > 0 {
            addSubview(view)
        }
    }
}

let zeroView = UIView(frame: .zero)

let customView = CustomView()
customView.addSubviewIfNotZero(zeroView)


//: ## The Interface Segregation Principle (ISP)
//: ### ❌ Incorrect
protocol ApartmentInc {
    func book()
    func cancelReservation()
}

class AirbnbApartmentInc: ApartmentInc {

    func book() {
        print("You have booked appartment at Airbnb")
    }

    func cancelReservation() {
        assertionFailure("You can't cancel reservation at Airbnb")
    }

}

//: ### ✅ Correct
protocol Bookable {
    func book()
}

protocol Cancelable {
    func cancelReservation()
}

class AirbnbApartment: Bookable {
    func book() {
        print("You have booked appartment at Airbnb")
    }
}

class HotelNumber: Bookable, Cancelable {

    func book() {
        print("You have booked number at Hotel")
    }

    func cancelReservation() {
        print("You have canceled reservarion at Hotel")
    }

}

//: ## Dependency Inversion Principle(DIP)
//: ### ❌ Incorrect

class DataManagerInc {
    let database: DatabaseInc

    init(database: DatabaseInc) {
        self.database = database
    }

    func save(text: String) {
        database.save(text: text)
    }
}

class DatabaseInc {

    func save(text: String) {
        print("Added `\(text)` text to DatabaseInc")
    }
}

//: ### ✅ Correct

class DataManager {
    let storage: Storage

    init(database: Storage) {
        self.storage = database
    }

    func save(text: String) {
        storage.save(text: text)
    }
}

protocol Storage {
    func save(text: String)
}

class Database: Storage {

    func save(text: String) {
        print("Added `\(text)` text to Database")
    }
}

class GoogleDrive: Storage {

    func save(text: String) {
        print("Added `\(text)` text to GoogleDrive")
    }
}

let database: Storage = Database()
let dataManager1 = DataManager(database: database)
dataManager1.save(text: "It's Dependency Inversion Principle")

let googleDrive: Storage = GoogleDrive()
let dataManager2 = DataManager(database: googleDrive)
dataManager2.save(text: "It's Dependency Inversion Principle")
