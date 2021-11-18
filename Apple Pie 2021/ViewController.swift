//
//  ViewController.swift
//  Apple Pie 2021
//
//  Created by noone on 14.11.2021.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    // MARK: - IB Outlets
    @IBOutlet weak var treeImageView: UIImageView!
    @IBOutlet var letterButtons: [UIButton]!
    @IBOutlet weak var correctWordLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var themePicker: UIPickerView!
    
    // MARK: - Properties
    var currentGame: Game!
    let incorrectMovesAllowed = 7
    var citiesOfRussia = ["Москва",
                          "Санкт-Петербург","Новосибирск","Екатеринбург","Казань","Нижний Новгород","Челябинск","Самара","Омск","Ростов-на-Дону","Уфа","Красноярск","Воронеж","Пермь","Волгоград","Якутск", "Тольятти", "Ижевск", "Барнаул", "Тюмень", "Саратов", "Краснодар", "Ярославль", "Владивосток", "Хабаровск", "Кемерово", "Новокузнецк", "Рязань", "Астрахань", "Севастополь", "Липецк"]
    var statesOfUSA = [
        "Алабама",
        "Аляска",
        "Аризона",
        "Арканзас",
        "Калифорния",
        "Колорадо",
        "Коннектикут",
        "Делавер",
        "Флорида",
        "Джорджия",
        "Гавайи",
        "Айдахо",
        "Иллинойс",
        "Индиана",
        "Айова",
        "Канзас",
        "Кентукки",
        "Луизиана",
        "Мэн",
        "Мэриленд",
        "Массачусетс",
        "Мичиган",
        "Миннесота",
        "Миссисипи",
        "Миссури",
        "Монтана",
        "Небраска",
        "Невада",
        "Нью-Хэмпшир",
        "Нью-Джерси",
        "Нью-Мексико",
        "Нью-Йорк",
        "Северная Каролина",
        "Северная Дакота",
        "Огайо",
        "Оклахома",
        "Орегон",
        "Пенсильвания",
        "Род Айленд",
        "Южная Каролина",
        "Южная Дакота",
        "Теннеси",
        "Техас",
        "Юта",
        "Вермонт",
        "Вирджиния",
        "Вашингтон",
        "Западная Вирджиния",
        "Висконсин",
        "Вайоминг"]
    var citiesOfWorld = ["Дели",
                         "Шанхай",
                         "Сан-Паулу",
                         "Мехико",
                         "Каир",
                         "Мумбаи",
                         "Пекин",
                         "Дакка",
                         "Осака",
                         "Нью-Йорк",
                         "Карачи",
                         "Буэнос-Айрес",
                         "Чунцин",
                         "Стамбул",
                         "Калькутта",
                         "Манила",
                         "Лагос",
                         "Рио-де-Жанейро",
                         "Тяньцзинь",
                         "Киншаса",
                         "Гуанчжоу",
                         "Лос-Анджелес",
                         "Москва",
                         "Шэньчжэнь",
                         "Лахор",
                         "Бангалор",
                         "Париж",
                         "Богота",
                         "Джакарта",
                         "Ченнай",
                         "Лима",
                         "Бангкок",
                         "Сеул",
                         "Нагоя",
                         "Хайдарабад",
                         "Лондон",
                         "Тегеран",
                         "Чикаго",
                         "Чэнду",
                         "Нанкин",
                         "Ухань",
                         "Хошимин",
                         "Луанда",
                         "Ахмедабад",
                         "Куала Лумпур",
                         "Сиань",
                         "Гонконг",
                         "Дунгуань",
                         "Ханчжоу",
                         "Фошань",
                         "Шэньян",
                         "Эр-Рияд",
                         "Багдад",
                         "Сантьяго",
                         "Сурат",
                         "Мадрид",
                         "Сучжоу",
                         "Пуна",
                         "Харбин",
                         "Хьюстон",
                         "Даллас",
                         "Торонто",
                         "Дар-эс-Салам",
                         "Майами",
                         "Белу-Оризонти",
                         "Сингапур",
                         "Филадельфия",
                         "Атланта",
                         "Фукуока",
                         "Хартум",
                         "Барселона",
                         "Йоханнесбург",
                         "Санкт-Петербург",
                         "Циндао",
                         "Далянь",
                         "Вашингтон",
                         "Янгон",
                         "Александрия",
                         "Цзинань",
                         "Гвадалахара",]
    var listOfWords = [String]()
    var pickerData = ["Города мира", "Города России", "Штаты США"]
    var totalWins = 0 {
        didSet {
            correctWordLabel.text = currentGame.word
            
            // Give player 2 seconds to see the correct word
            Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(newRound), userInfo: nil, repeats: false)
        }
    }
    var totalLosses = 0 {
        didSet {
            treeImageView.image = UIImage(named: "Tree0")
            correctWordLabel.text = currentGame.word
            
            // Give player 2 seconds to see the correct word
            Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(newRound), userInfo: nil, repeats: false)
        }
    }
    
    // MARK: - Methods
    
    func enableButton(_ enable: Bool = true) {
        for button in letterButtons {
            button.isEnabled = enable
        }
    }
    
    @objc func newRound() {
        guard !listOfWords.isEmpty else {
            enableButton(false)
            updateUI()
            return
        }
        let newWord = listOfWords.removeFirst()
        currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectMovesAllowed)
        updateUI()
        enableButton()
    }
    
    func updateState() {
        if currentGame.incorrectMovesRemaining < 1 {
            totalLosses += 1
        } else if currentGame.guessedWord == currentGame.word {
            totalWins += 1
        } else {
            updateUI()
        }
    }
    
    func updateUI() {
        let movesRemaining = currentGame.incorrectMovesRemaining
        let imageNumber = movesRemaining < 0 ? 0 : movesRemaining < 8 ? movesRemaining : 7
        let image = "Tree\(imageNumber)"
        treeImageView.image = UIImage(named: image)
        correctWordLabel.text = currentGame.guessedWord
        scoreLabel.text = "Выигрыши: \(totalWins), Проигрыши: \(totalLosses)"
    }
    
    // Number of columns in picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Number of rows in picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // Data in picker
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Player chooses a type of game in picker.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerData[row] {
        case "Города мира":
            listOfWords = citiesOfWorld.shuffled()
        case "Города России":
            listOfWords = citiesOfRussia.shuffled()
        default:
            listOfWords = statesOfUSA.shuffled()
        }
        
        newRound()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connecting picker
        self.themePicker.delegate = self
        self.themePicker.dataSource = self
        listOfWords = citiesOfWorld.shuffled()
        newRound()
    }
    
    
    
    // MARK: - IB Actions
    @IBAction func letterButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        let letter = sender.title(for: .normal)!
        currentGame.playerGuessed(letter: Character(letter))
        updateState()
    }
    
}

