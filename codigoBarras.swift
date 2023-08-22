import Foundation

// MARK: - Extensions
extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

// Código por país para el estándar EAN-13
var diccionarioCodigoPais: [String:String] = [
  "0" : "EEUU",
  "389" : "Bulgaria",
  "50" : "Inglaterra",
  "539" : "Irlanda",
  "560" : "Portugal",
  "70" : "Noruega",
  "759" : "Venezuela",
  "850" : "Cuba",
  "890" : "India"
]

final class Reto {

	// MARK: - Private properties
	private var eanOchoVerificacion: Bool = false
	private var eanOcho: String = ""
	private var eanTrece: String = ""
	private var digitosArray: [Int] = [] // Variable con código de control al inicio, luego se le elimina el código de control en la línea 119
	private var digitosArrayInvertido: [Int] = [] // Variable sin código de control

	// MARK: - Computed properties
	private var digitoControlEanTrece: Int? {
		if !eanTrece.isEmpty {
			return Int(String(eanTrece[eanTrece.count - 1]))
		} else {
			return nil
		}
	}
	
	private var digitoControlEanOcho: Int? {
		if !eanOcho.isEmpty {
			return Int(String(eanOcho[eanOcho.count - 1]))
		} else {
			return nil
		}
	}
	
	// MARK: - Methods
	
	// Método en el que se lee la entrada del usuario, se comprueba que se cumplan los diversos condicionantes de entrada
	// y se devuelve true o false dependiendo de si se introduce un número relacionado con el código de barras o un 0, con el
	// que saldríamos del programa
	private func lecturaEntrada() -> Bool {
	
		while true {
			if let entradaUsuario: String = readLine(),
			let entradaNumerica: Int = Int(entradaUsuario),
			entradaNumerica >= 0	{
				if entradaNumerica == 0 {
					return false
				} else if entradaUsuario.count <= 13 && entradaUsuario.count > 0 {
					if entradaUsuario.count <= 13 && entradaUsuario.count > 8 {
						if entradaUsuario.count == 13 {
							eanTrece = entradaUsuario
							return true
						} else {
							let diferenciaDigitos: Int = 13 - entradaUsuario.count
							for _ in 1...diferenciaDigitos {
								eanTrece += "0"
							}
							eanTrece += entradaUsuario
							return true
						}
					} else {
						if entradaUsuario.count == 8 {
							eanOcho = entradaUsuario
							eanOchoVerificacion = true
							return true
						} else {
							let diferenciaDigitos: Int = 8 - entradaUsuario.count
							for _ in 1...diferenciaDigitos {
								eanOcho += "0"
							}
							eanOcho += entradaUsuario
							eanOchoVerificacion = true
							return true
						}
					}
				} else {
					print("Error de formato. Has introducido \(entradaUsuario.count) dígitos. Solo está permitido hasta 13 dígitos.")
				}
			} else {
				print("Error de formato. Has introducido caracteres alfabéticos o números negativos. Introduce números enteros positivos o 0 para salir.")
			}
		}
	
	}
	
	// Método que se encarga de preparar la entrada en formato Array para poder realizar los posteriores cálculos pertinentes
	private func deteccionErroresFasePreparatoria() {
	
		// Agregar dígitos a array como tipo Int
		if !eanTrece.isEmpty {
			eanTrece.forEach { digito in
			  if let digitoInt = Int(String(digito)) {
				digitosArray.append(digitoInt)
			  }
			}
		} else {
			eanOcho.forEach { digito in
			  if let digitoInt = Int(String(digito)) {
				digitosArray.append(digitoInt)
			  }
			}
		}
		
		// Eliminar dígito de control
		digitosArray.remove(at: digitosArray.count - 1)
		
		// Invertir array
		digitosArray.forEach { digitosArrayInvertido.insert($0, at: 0) }
	
	}

	// Método que se ocupa de realizar los cálculos que determinan si el dígito de control del código de barras es correcto (return false)
	// o no (return true)
	private func deteccionErrores() -> Bool {
		
		// Empezando por la derecha (sin contar el dígito de control que se está calculando), se suman los dígitos individuales, 
		// multiplicados por 3 si están en posición impar y por 1 si están en posición par
		var sumaDigitos: Int = 0

		digitosArrayInvertido.enumerated().forEach {
		  if ($0 + 1) % 2 == 0 {
			sumaDigitos += $1
		  } else {
			sumaDigitos += $1 * 3
		  }
		}
		
		// El dígito de comprobación es el número que hay que sumar al resultado anterior para llegar a un valor múltiplo de 10. 
		// En el ejemplo de EAN-8, para llegar al múltiplo de 10 más cercano por encima del número 88 hay que sumar 2 (y llegar al 90). 
		// Ten en cuenta que si la suma resulta ser ya múltiplo de 10, el dígito de control será 0.
		if sumaDigitos % 10 == 0 {
			if eanOchoVerificacion {
				if digitoControlEanOcho == 0 {
					return false
				} else {
					return true
				}
			} else {
				if digitoControlEanTrece == 0 {
					return false
				} else {
					return true
				}
			}
		} else {
			if eanOchoVerificacion {
				for num in 1...9 {
					if (sumaDigitos + num) % 10 == 0 {
						if digitoControlEanOcho == num {
							return false
						} else {
							return true
						}
					}
				}
				return true
			} else {
				for num in 1...9 {
					if (sumaDigitos + num) % 10 == 0 {
						if digitoControlEanTrece == num {
							return false
						} else {
							return true
						}
					}
				}
				return true
			}
			
		}	
		
	}
	
	// Método que, en caso de tener un código de barras que se enmarca dentro del estándar EAN-13, se ocupa de cotejar con el diccionario
	// que alberga cada código con su correspondiente país para imprimirlo por pantalla. En caso de no encontrarse, se imprime `Desconocido`
	// en lugar de un nombre de país
	private func identificarCodigoPais() {

		var paisEncontrado: Bool = false		

		diccionarioCodigoPais.forEach { valor in

		  var entradaArrayAcortado: [Int] = []
		  var keyArray: [Int] = []
		  let longitudKey: Int = valor.key.count

		  (0...longitudKey - 1).forEach { entradaArrayAcortado.append(digitosArray[$0]) }
							 
		  valor.key.forEach {
			if let digito = Int(String($0)) {
			  keyArray.append(digito)
			}
		  }

		  if entradaArrayAcortado == keyArray {
			print("SI \(valor.value)")
			paisEncontrado = true
		  }

		}

		if !paisEncontrado {
			print("SI Desconocido")
		}
	
	}
	
	// Método empleado para reiniciar las variables de clase una vez que se ha analizado el caso
	private func reiniciarValores() {
	
		eanOchoVerificacion = false
		eanOcho = ""
		eanTrece = ""
		digitosArray = []
		digitosArrayInvertido = []
	
	}
	
	// Método que aplica la lógica principal del programa integrando el resto de métodos
	func caso() {
	
		var finPrograma: Bool = false
		while !finPrograma {
			if !lecturaEntrada() {
				finPrograma = true
			} else {
				deteccionErroresFasePreparatoria()
				if deteccionErrores() {
					print("NO")
					reiniciarValores()
				} else {
					if eanOchoVerificacion {
						print("SI")
						reiniciarValores()
					} else {
						identificarCodigoPais()
						reiniciarValores()
					}
				}
			}
		}
	
	}

}

// Main
let reto: Reto = Reto()
reto.caso()
