import UIKit

print("____Практические задания Часть 1____\n")
/*
 Определить две константы a и b типа Double, присвоить им любые значения. Вычислить среднее значение и сохранить результат в переменную average.
 */
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
    //так как в списке две 1, то количество чисел в списке всегда будет на 1 больше
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

printFirstFibonacciNumbers(lastNumberIndex: 15)

/*
 Напишите программу для сортировки массива, использующую метод пузырька. Сортировка должна происходить в отдельной функции, принимающей на вход исходный массив.
 */

func bubleSort<T: Comparable>(array: [T]) -> [T] {
    var arraySorted = array
    for i in 0..<arraySorted.count {
        for j in i + 1..<arraySorted.count {
            if (arraySorted[i] > arraySorted[j]) {
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
        if ("0" <= strArray[i] && strArray[i] <= "9") {
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
    if (range.end == -1) {
        return nil
    }
    if (range.start == -1) {
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
    return(String(finalStr))
}

func incrementNumberByOne(str: String) -> String {
    if ("0" <= str.prefix(1) && str.prefix(1) <= "9") {
        return (str)
    }
    let strArray = Array<Character>(str)
    guard let range: (start: Int, end: Int) = getNumberRange(strArray: strArray) else {
        return (str)
    }
    var numberStr = ""
    numberStr.reserveCapacity(range.end - range.start)
    for i in range.start...range.end {
        numberStr.append(strArray[i])
    }
    guard let nb = Int(numberStr) else {
        return (str)
    }
    numberStr = String(nb + 1)

    return(constructFinalStr(strArray: strArray, numberStr: numberStr, range: range))
}
print(incrementNumberByOne(str: "a999k"))

print("\n____Практические задания Часть 2____\n")
