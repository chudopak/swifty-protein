import UIKit

print("____Практические задания Часть 1____\n")
/*
 Определить две константы a и b типа Double, присвоить им любые значения. Вычислить среднее значение и сохранить результат в переменную average.
 */
let a = 1.34
let b = 3.56
let average = (a + b) * 0.5

/*
 Создать кортеж, и задать два любых строковых значения с названиями firstName и lastName. Далее необходимо вывести в консоль строку в формате "Full name: [firstName] [lastName]".
 */
let tupple = (firstName: "John", lastName: "Smith")
print("Full name: \(tupple.firstName) \(tupple.lastName)")

/*
 Создать две опциональные переменные типа Float. Одной из них задать первоначальное значение. Написать функцию, которая принимает на вход опциональную переменную типа Float. Функция должна безопасно извлечь значение из входящей переменной. Если значение удалось получить - необходимо вывести его в консоль, если значение у переменной отсутствует вывести в консоль фразу "Variable can't be unwrapped". Вызвать функцию дважды с двумя ранее созданными переменными.
 */
func safeUnwrapping(value: Float?) {
    guard let unwrappedValue = value else {
        print("Variable can't be unwrapped")
        return
    }
    print(unwrappedValue)
}

var floatValue1: Float? = 1.2
var floatValue2: Float?

safeUnwrapping(value: floatValue1)
safeUnwrapping(value: floatValue2)

/*
 Напишите программу для вывода первых 15 чисел последовательности Фибоначчи
 PS я написал, что можно задать не только 15, а произвольное количество чисел
 */

func fillFibonacciArray(firstNbr: Int, fibonacciArray: inout [Int]) -> Int {
    //так как в списке две 1, то количество чисел в списке всегда будет на 1 больше
    if fibonacciArray.capacity != firstNbr + 1 {
        fibonacciArray.reserveCapacity(firstNbr + 1)
    }
    if firstNbr <= 1 {
        if firstNbr == 1 && fibonacciArray.isEmpty {
            fibonacciArray.append(0)
        } else if firstNbr == 1 && (fibonacciArray.count == 1 || fibonacciArray.count == 2) {
            fibonacciArray.append(firstNbr)
        }
        return firstNbr
    }
    let nb = fillFibonacciArray(firstNbr: firstNbr - 1, fibonacciArray: &fibonacciArray) + fillFibonacciArray(firstNbr: firstNbr - 2, fibonacciArray: &fibonacciArray)
    if let last = fibonacciArray.last, nb > last {
        fibonacciArray.append(nb)
    }
    return nb
}

func printFirstFibonacciNumbers(lastNumberIndex: Int) {
    guard lastNumberIndex > 0 else {
        return
    }
    var fibonacciArray = [Int]()
    let _ = fillFibonacciArray(firstNbr: lastNumberIndex, fibonacciArray: &fibonacciArray)
    let minValue = lastNumberIndex < fibonacciArray.count ? lastNumberIndex : fibonacciArray.count
    for i in 0..<minValue {
        print(fibonacciArray[i])
    }
}

printFirstFibonacciNumbers(lastNumberIndex: 20)

/*
 Напишите программу для сортировки массива, использующую метод пузырька. Сортировка должна происходить в отдельной функции, принимающей на вход исходный массив.
 */

func bubleSort<T: Comparable>(array: [T]) -> [T] {
    var arraySorted = array
    for i in 0..<arraySorted.count {
        for j in i + 1..<arraySorted.count {
            if arraySorted[i] > arraySorted[j] {
                arraySorted.swapAt(i, j)
            }
        }
    }
    return arraySorted
}

print(bubleSort(array: [2, 0, 34,2, 6, 17, -23]))

/*
 Напишите программу, решающую задачу: есть входящая строка формата "abc123", где сначала идет любая последовательность букв, потом число. Необходимо получить новую строку, в конце которой будет число на единицу больше предыдущего, то есть "abc124".
 */

func getNumberRange(strArray: [Character]) -> (Int, Int)? {
    var range = (start: -1, end: -1)
    var i = strArray.count - 1
    while (i >= 0) {
        if "0" <= strArray[i] && strArray[i] <= "9" {
            range.end = i
            while (i >= 0) {
                if !("0" <= strArray[i] && strArray[i] <= "9") {
                    range.start = i + 1
                    break
                }
                i -= 1
            }
        }
        i -= 1
    }
    if range.end == -1 {
        return nil
    }
    if range.start == -1 {
        range.start = 0
    }
    return range
}

func constructFinalStr(strArray: [Character], numberStr: String, range: (start: Int, end: Int)) -> String {
    var finalStr = [Character]()
    finalStr.reserveCapacity(strArray.count)
    for i in 0..<range.start {
        finalStr.append(strArray[i])
    }
    for i in numberStr {
        finalStr.append(i)
    }
    for i in range.end + 1..<strArray.count {
        finalStr.append(strArray[i])
    }
    return String(finalStr)
}

func incrementNumberByOne(str: String) -> String {
    if "0" <= str.prefix(1) && str.prefix(1) <= "9" {
        return str
    }
    let strArray = Array<Character>(str)
    guard let range: (start: Int, end: Int) = getNumberRange(strArray: strArray) else {
        return str
    }
    var numberStr = ""
    numberStr.reserveCapacity(range.end - range.start)
    for i in range.start...range.end {
        numberStr.append(strArray[i])
    }
    guard let nb = Int(numberStr) else {
        return str
    }
    numberStr = String(nb + 1)

    return constructFinalStr(strArray: strArray, numberStr: numberStr, range: range)
}
print(incrementNumberByOne(str: "a999k"))

print("\n____Практические задания Часть 2____\n")
/*
 Написать простое замыкание в переменной myClosure, замыкание должно выводить в консоль фразу "I love Swift". Вызвать это замыкание. Далее написать функцию, которая будет запускать заданное замыкание заданное количество раз. Объявить функцию так: func repeatTask (times: Int, task: () -> Void). Функция должна запускать times раз замыкание task. Используйте эту функцию для печати «I love Swift» 10 раз.
 */

let task = {
    print("I love Swift")
}
task()
print("\n_Repeat Task")
func repeatTask (times: Int, task: () -> Void) {
    for _ in 0..<times {
        task()
    }
}
repeatTask(times: 10, task: task)

/*
 Условия: есть начальная позиция на двумерной плоскости, можно осуществлять последовательность шагов по четырем направлениям up, down, left, right. Размерность каждого шага равна 1. Создать перечисление Directions с направлениями движения. Создать переменную location с начальными координатами (0,0), создать массив элементами которого будут направления из перечисления. Положить в этот массив следующую последовательность шагов: [.up, .up, .left, .down, .left, .down, .down, .right, .right, .down, .right]. Программно вычислить, какие будут координаты у переменной location после выполнения этой последовательности шагов.
 */

enum Directions {
    case up, down, left, right
}

func handleMovement(direction: Directions, location: inout (x: Int, y: Int), stepSize: Int = 1) {
    switch direction {
    case .down:
        location.y += stepSize
    case .up:
        location.y -= stepSize
    case .right:
        location.x += stepSize
    case .left:
        location.x -= stepSize
    }
}

func getLocationAfterMoving(movements: [Directions], startLocation: (x: Int, y: Int), stepSize: Int = 1) -> (Int, Int) {
    var location = startLocation
    movements.forEach { handleMovement(direction: $0, location: &location) }
    return location
}

let location: (x: Int, y: Int) = (0,0)
print(getLocationAfterMoving(movements: [.up, .up, .left, .down, .left, .down, .down, .right, .right, .down, .right], startLocation: location))

/*
 Создать класс Rectangle с двумя неопциональными свойствами: ширина и длина. Реализовать в этом классе метод вычисляющий и выводящий в консоль периметр прямоугольника. Создать экземпляр класса и вызвать у него этот метод.
 */

class Rectangle {
    
    private let width: Int
    private let height: Int
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
    
    convenience init() {
        self.init(width: 0, height: 0)
    }

    func perimeter() -> Int {
        return (width + height) * 2
    }
}

let rectangle = Rectangle(width: 5, height: 2)
print(rectangle.perimeter())

/*
 Создать расширение класса Rectangle, которое будет обладать вычисляемым свойством площадь. Вывести в консоль площадь уже ранее созданного объекта.
 */

extension Rectangle {

    func area() -> Int {
        return width * height
    }
}

print(rectangle.area())
