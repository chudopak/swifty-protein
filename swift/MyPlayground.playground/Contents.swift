import UIKit

/*
 Определить две константы a и b типа Double, присвоить им любые значения. Вычислить среднее значение и сохранить результат в переменную average.
 */
print("____Практические задания Часть 1____\n")
let a: Double = 1.34
let b: Double = 3.56
let average: Double = (a + b) * 0.5

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

func fillfibonacciArray(firstNbr: Int, fibonacciNumberList: inout [Int]) -> Int {
    if (fibonacciNumberList.capacity != firstNbr + 1) {
        fibonacciNumberList.reserveCapacity(firstNbr + 1)
    }
    if (firstNbr <= 1) {
        if firstNbr == 1 && fibonacciNumberList.isEmpty {
            fibonacciNumberList.append(0)
        } else if (firstNbr == 1 && (fibonacciNumberList.count == 1 || fibonacciNumberList.count == 2)) {
            fibonacciNumberList.append(firstNbr)
        }
        return (firstNbr)
    }
    let nb = fillfibonacciArray(firstNbr: firstNbr - 1, fibonacciNumberList: &fibonacciNumberList) + fillfibonacciArray(firstNbr: firstNbr - 2, fibonacciNumberList: &fibonacciNumberList)
    if let last = fibonacciNumberList.last, nb > last {
        fibonacciNumberList.append(nb)
    }
    return (nb)
}

func printFirstFibonacciNumbers(lastNumberIndex: Int) {
    guard lastNumberIndex > 0 else {
        return
    }
    var fibonacciNumberList = [Int]()
    let _ = fillfibonacciArray(firstNbr: lastNumberIndex, fibonacciNumberList: &fibonacciNumberList)
    let minValue = lastNumberIndex < fibonacciNumberList.count ? lastNumberIndex : fibonacciNumberList.count
    for i in 0..<minValue {
        print(fibonacciNumberList[i])
    }
}

printFirstFibonacciNumbers(lastNumberIndex: 5)

