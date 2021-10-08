//
//  MainMenuElements.swift
//  wheels_Andrew
//
//  Created by Andrew on 16.07.2021.
//

import UIKit

class MenuData {
    var trainingItemsArray: [MenuElement] = []
    var checkItemsArray: [MenuElement] = []
    var menuElementsSections: [[MenuElement]] = []
    var headers: [String]
    let trainingHeader = "Выберете тренировку"
    let trainingOne = MenuElement(
        id: 0,
        name: "Тренировка по главам ПДД",
        icon: UIImage(systemName: "book")!
    )
    let trainingTwo = MenuElement(
        id: 1,
        name: "Тренировка по тематическим билетам",
        icon: UIImage(systemName: "books.vertical")!
    )
    let trainingThree = MenuElement(
        id: 2,
        name: "Тренировка по случайному билету",
        icon: UIImage(systemName: "questionmark.diamond")!
    )
    let checkHeader = "Выберете контроль"
    let checkOne = MenuElement(
        id: 3,
        name: "Контроль по темам ПДД",
        icon: UIImage(systemName: "book.closed")!
    )
    let checkTwo = MenuElement(
        id: 4,
        name: "Контроль по тематическому билету Х10",
        icon: UIImage(systemName: "10.circle")!
    )
    let checkThree = MenuElement(
        id: 5,
        name: "Контроль по случайному билету",
        icon: UIImage(systemName: "person.fill.questionmark")!
    )
    
    init() {
        trainingItemsArray = [trainingOne, trainingTwo, trainingThree]
        checkItemsArray = [checkOne, checkTwo, checkThree]
        menuElementsSections = [trainingItemsArray, checkItemsArray]
        headers = [trainingHeader, checkHeader]
    }
}
