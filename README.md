# Códigos de barras

![Tiempo y memoria a consumir máximos](images/tiempoMemoria.png)

En el lejano 1952, tres norteamericanos patentaron lo que terminó llamándose *código de barras*. Consiste en una técnica para representar números (y, en menos ocasiones, letras) mediante una serie de líneas verticales paralelas, con diferentes grosores y separaciones entre ellas. Si bien el primer uso sirvió para identificar de manera automática los vagones de un ferrocarril, hoy los códigos de barras se utilizan en infinidad de lugares, siendo la catalogación de productos la más habitual.

La manera concreta de codificar mediante barras los números y las letras puede ser muy variada, lo que ha llevado a la aparición de diferentes estándares. De todos ellos, el EAN (*European Article Number*) resulta ser el más extendido. De éste, hay principalmente dos formatos, que se diferencian en el ancho. Existe así el llamado EAN-8, que codifica 8 números, y el EAN-13, que, naturalmente, codifica 13.

![Códigos de barras EAN](images/figura.png)

El último dígito del código se utiliza para detección de errores, y se calcula a partir de los demás. Para eso:

* Empezando por la derecha (sin contar el dígito de control que se está calculando), se suman los dígitos individuales, multiplicados por un factor:
	* Los dígitos en posiciones impares (empezando a contar por la derecha saltándonos el de control) se multiplican por 3.
	* Los dígitos en posiciones pares se multiplican por 1.

	Por ejemplo, para el código EAN-8 de la figura la operación a realizar es:
	
![Ejemplo operación](images/ejemplo.png)

* El dígito de comprobación es el número que hay que sumar al resultado anterior para llegar a un valor múltiplo de 10. En el ejemplo de EAN-8, para llegar al múltiplo de 10 más cercano por encima del número 88 hay que sumar 2 (y llegar al 90). Ten en cuenta que si la suma resulta ser ya múltiplo de 10, el dígito de control será 0.

En EAN-13, los primeros dígitos se usan además para identificar al país. A continuación se indica una tabla (parcial) de esos códigos de país.

![Identificador de países en los códigos de barras EAN](images/tabla.png)

## Entrada

La entrada estará formada por una serie de casos de prueba. Cada uno contendrá una sucesión de números pertenecientes a un código de barras EAN-8 o EAN-13, incluyendo el dígito de control. Si el número de dígitos es inferior a 8, se asumirá que es un código EAN-8; si es superior a 8 pero inferior a 13, se asumirá EAN-13. En ambos casos, se completarán el resto de dígitos colocando ceros a la izquierda.

El último caso de prueba es seguido por una línea con un 0 que no provoca salida.

## Salida

Para cada caso de prueba, el programa indicará si el dígito de control es correcto o no. Si lo es, escribirá "SI". En otro caso, escribirá "NO".

Si el código de barras es EAN-13 y correcto, el programa escribirá además el país al que pertenece utilizando la tabla anterior (separado por un espacio). Si el código no aparece en la tabla, el programa mostrará "Desconocido". Ten cuidado al escribir los países; deberás respetar el uso de mayúsculas y minúsculas de la tabla.

## Entrada de ejemplo

![Entrada del programa](images/entrada.png)

## Salida de ejemplo

![Salida del programa](images/salida.png)

## Lenguaje empleado

<p align="center">
	<a href="https://www.swift.org">
	    <img src="https://img.shields.io/badge/Swift-FA7343?style=for-the-badge&logo=swift&logoColor=white" alt="Git">
	</a>
</p>

---

[🛜 Aquí puedes encontrar el sitio web oficial donde se encuentra este reto.](https://aceptaelreto.com/pub/problems/v001/06/st/statements/Spanish/index.html)