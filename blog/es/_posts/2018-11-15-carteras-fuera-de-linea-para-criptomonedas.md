---
layout: post
title: "carteras fuera de línea para criptomonedas"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

Las carteras para criptomonedas son piezas de software que dan acceso a los
[blockchains](https://es.wikipedia.org/wiki/Cadena_de_bloques) de Bitcoin,
Ethereum, etc, **cada criptomoneda tiene su propia cartera**, asi una cartera
para Bitcoin solo funcionará para ese protocolo. Y si se tienen `N`
criptomonedas, se requeriran la misma cantidad de carteras para administrar los
fondos.

También existen programas que pueden acceder a varios protocolos al mismo
tiempo, las multicarteras, sin embargo esos programas estan desarrollados por
terceras partes, por lo que tienden a ser menos confiables, por tal razón en
este artículo se hará enfásis en la utilización de las carteras oficiales.

Para usar una cartera se requieren dos cosas, una clave pública y una privada.

**Clave pública**: ésta es la dirección de la cartera.  Es muy parecido a un
número de cuenta bancaria, ya que sólo se puede usar para enviar dinero a una
cuenta.

**Clave privada**: ésta es la información que permite controlar los fondos de
la cuenta. Por lo cual debe mantenerse 100% secreta y segura, **si se pierde
esta clave se pierden los fondos**.

**OJO**: Una llave pública puede obtenerse a partir de una llave privada, pero
al revés no. Por lo que en teoría sólo se podría almacenar la llave privada.
Sin embargo, la llave pública a menudo es útil para solicitar fondos a terceros
sin arriesgarse a comprometer la llave privada, por lo que es conveniente tener
ambas a la mano.

Cuando los fondos se mantienen en un exchange, como [bitso](), [binance](),
etc, dichos sitios son los únicos que conocen ambas llaves, de ahi que puedan
comprometerse los recursos si el sitio es hackeado, o que el exchange pueda
tomar decisiones unilaterales para congelar cuentas o mantener los recursos.

La razon anterior es suficiente para tener los fondos en carteras
independientes cuando se trate de sumas considerables.

### wallet

Debido a mi pérfil técnico y a la variedad de criptomonedas que manejo, he
generado un script que me permite interactuar con las carteras de varios
protocolos de forma conveniente, incluidos, BTC, ETH, XRP, LTC, NEO, etc. Así
que será el método que describa. **OJO: A menos que me conozca personalmente,
sugiero fuertemente que revise el código fuente a detalle para determinar su
confiabilidad.**

    $ wget https://raw.githubusercontent.com/javier-lopez/learn/master/sh/tools/wallet
    $ chmod +x wallet && sudo mv wallet /usr/bin/wallet
    $ wallet -h
    Usage: wallet ARCHIVE
    Dockerized [BTC|BCC|BTCP|LTC|NEO|ETH|XRP|ADA] thin client launcher.

    Options:

      -U, --update    update this program to latest version
      -V, --version   display version
      -h, --help      show this message and exit

    Examples:

      $ wallet Electrum-3.2.2.tar.gz            #BTC
      $ wallet Electrum-LTC-3.1.3.1.tar.gz      #LTC
      $ wallet Electrum-BTCP-1.1.1.tar.gz       #BTCP
      $ wallet ElectronCash-3.3.1.tar.gz        #BCC
      $ wallet Neon-0.2.6-x86_64.Linux.AppImage #NEO
      $ wallet etherwallet-v3.21.03.zip         #ETH
      $ wallet minimalist-ripple-client.html    #XRP
      $ wallet daedalus-0.11.0-cardano.exe      #ADA

El script anterior requiere [Ubuntu Linux](https://es.wikipedia.org/wiki/Ubuntu),
[Docker](https://es.wikipedia.org/wiki/Docker_(software)) y la cartera del
protocolo con el que se desee interactuar, por ejemplo para Bitcoin se
requerirá [Electrum-3.2.2.tar.gz](https://electrum.org).

### Bitcoin, BTC

Teniendo el script y la cartera, se puede comenzar a interactuar con el
blockchain, esto generalmente se hace para dos cosas, generar nuevas
cuentas, o gestionar existentes.

## Generar nueva cuenta

Cada vez que se crea una nueva cuenta, en realidad se espera generar un par de
llaves (pública/privada) de dicha criptomoneda, por lo que este serán los datos
que estaremos búscando y almacenando. Para lanzar la cartera de BTC, se
ejecuta:

    $ wallet Electrum-3.2.2.tar.gz #BTC
    Verify the archive before continuing!!!

    SHA256: 69cc3eaef8cc88e92730f3f38850a83e66ffd51d9aa26364f35fd45d1cedaabb
    SHA512: 32c4a24c2d3e2e38b9d66f6102176533a991b1c1fd25173bcd3bdd...3c87f15

    Waiting 7 seconds.., press Ctrl-C to cancel

Es muy importante verificar que las sumatorias concuerden con las especificadas
por el proyecto (SHA256/SHA512), de lo contrario, esto indicaría modificaciones
(generalmente maliciosas) en los binarios.

La primera vez que se ejecute el script, se generará un entorno seguro /
reutilizable que permitirá lanzar las carteras soportadas. Este proceso puede
demorar hasta un par de hrs dependiendo la velocidad de internet, y sólo se
hace una vez.

Verificados los binarios se muestra la interfaz inicial.

**[![](/assets/img/wallet-btc-1.png)](/assets/img/wallet-btc-1.png)**

Las primeras pantallas muestran opciones de conexión y preferencias que
requeririan sus propios artículos, por el momento utilizaremos las opciones por
defecto para hacer el proceso tan rápido y eficiente como sea posible.

En la primera pantalla se selecciona **Auto connect**, y se da **siguiente**.

**[![](/assets/img/wallet-btc-2.png)](/assets/img/wallet-btc-2.png)**

En la segunda se pregunta por la ubicación de los datos de la cartera, se dejará
en **default_wallet** y se da **siguiente**.

**[![](/assets/img/wallet-btc-3.png)](/assets/img/wallet-btc-3.png)**

En la tercera, se pregunta por el tipo de cartera, la cartera estándar estará
bien, se da **siguiente**.

**[![](/assets/img/wallet-btc-4.png)](/assets/img/wallet-btc-4.png)**

Ahora se llega a la parte donde se elige si se desea generar una nueva cuenta o
abrir una existente. Para abrir una nueva cuenta se selecciona **Create a new seed**
y se da **siguiente**.

**[![](/assets/img/wallet-btc-5.png)](/assets/img/wallet-btc-5.png)**

Se selecciona el formato de las llaves , **standard** y se da **siguiente**.

**[![](/assets/img/wallet-btc-6.png)](/assets/img/wallet-btc-6.png)**

Ahora la cartera genera la **llave privada**, **OJO**, hay que tener mucho
cuidado con este dato, hay que mantenerlo privado y guardarlo en un lugar
seguro. Si se pierde u olvida los fondos se vuelven irrecuperables.

**[![](/assets/img/wallet-btc-7.png)](/assets/img/wallet-btc-7.png)**

Para asegurarse que el dato ha sido almacenado, en la siguiente
pantalla se pregunta por la llave privada.

**[![](/assets/img/wallet-btc-8.png)](/assets/img/wallet-btc-8.png)**

Ahora, se pregunta por una contraseña para cifrar de manera interna la
información recien generada, debido a la forma en que se abre la cartera no es
necesario establecer una, el entorno elimina los archivos temporales al
finalizar la sesión.

En su lugar, sera pertinente almacenar la **llave privada** en un archivo
cifrado y mantener ese archivo en un lugar seguro. Personalmente mantengo mis
llaves privadas en un archivo .txt y lo cifro con
[GPG](https://es.wikipedia.org/wiki/GNU_Privacy_Guard).

**[![](/assets/img/wallet-btc-9.png)](/assets/img/wallet-btc-9.png)**

Finalmente ha llegado el momento de interactuar con la nueva cuenta, desde esta
interfaz se puede consultar el saldo, enviar y recibir bitcoins. Para ver la llave
pública se va a la pestaña `recibir`.

**[![](/assets/img/wallet-btc-9.1.png)](/assets/img/wallet-btc-9.1.png)**

Listo!, ahora se tiene una nueva cuenta BTC.

    Llave pública: 1JTg8e3yfCBbk22...
    Llave privada: hub leopard broken neutral trash ...

## Gestionar cuenta existente

Si ya se cuenta con una llave privada anterior (la frase de 12 palabras) se
continua desde el 4to paso anterior y esta vez se selecciona **I already have a
seed**.

**[![](/assets/img/wallet-btc-10.png)](/assets/img/wallet-btc-10.png)**

Se introduce la llave privada y se da **siguiente**

**[![](/assets/img/wallet-btc-11.png)](/assets/img/wallet-btc-11.png)**
**[![](/assets/img/wallet-btc-12.png)](/assets/img/wallet-btc-12.png)**

Preguntará por una contraseña para cifrar los datos temporales, no es
necesario, puesto que el script eliminará esos datos al cerrar la cartera. Se
da **siguiente**

**[![](/assets/img/wallet-btc-13.png)](/assets/img/wallet-btc-13.png)**

Ya se puede interactuar con la cuenta para enviar o recibir BTC.

### Neo

El proceso es similar para otra carteras, en cada caso, solo variará la
cartera, y la interfaz gráfica, veamos el caso de NEO.

## Generar nueva cuenta

    $ wallet Neon-0.2.6-x86_64.Linux.AppImage

    Verify the archive before continuing!!!

    SHA256: 78276848a23d89db4d56965d94784c710d4281ca8085cfd0644644e08d1074bf
    SHA512: 3bf87818885128ad74cd018fd2e437e32f274a5974b473b74bad84...9b5c548

Después de verificar las sumatorias aparece la interfaz gráfica.

**[![](/assets/img/wallet-neo-1.png)](/assets/img/wallet-neo-1.png)**

Aunque luce diferente, en realidad provee las mismas opciones. Para generar una
nueva cuenta se selecciona **Create a new wallet**

**[![](/assets/img/wallet-neo-2.png)](/assets/img/wallet-neo-2.png)**

La cartera de NEO nos obliga a especificar una contraseña para cifrar los datos
temporales de la cartera, pero esa contraseña no es importante recordarla, se
puede poner una temporal.

**[![](/assets/img/wallet-neo-3.png)](/assets/img/wallet-neo-3.png)**

Una vez hecho, se proveen las llaves públicas y privadas.

Listo!, ahora también se tiene una nueva cuenta NEO.

    Llave pública: AaUZif7n6FiVPyH...
    Llave privada: KwuHYFeuJucZz94KanqaqaRkEi71mRdQbPZ...

## Gestionar cuenta existente

Si ya se cuenta con una llave privada de NEO anterior se selecciona la opción
**Login using a private key** en el menú principal.

**[![](/assets/img/wallet-neo-1.png)](/assets/img/wallet-neo-1.png)**

Se introduce la clave y se hace clic en **Login**

**[![](/assets/img/wallet-neo-10.png)](/assets/img/wallet-neo-10.png)**

Listo, ahora se pueden enviar y recibir Neo's y criptomonedas compatibles, como
GAS.

**[![](/assets/img/wallet-neo-11.png)](/assets/img/wallet-neo-11.png)**

-------------------------------------------------------------------------------

Listo, feliz manejo de sus finanzas &#128523;.

- [https://github.com/javier-lopez/learn/blob/master/sh/tools/wallet](https://github.com/javier-lopez/learn/blob/master/sh/tools/wallet)
