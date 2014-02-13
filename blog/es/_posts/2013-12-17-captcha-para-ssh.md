---
layout: post
title: "captcha para ssh"
---

## {{ page.title }}
###### {{ page.date | date_to_string }}

<!--**[![](/assets/img/pam_captcha.png)](https://github.com/chilicuil/pam_captcha)**-->
<iframe class="showterm" src="http://showterm.io/53a85bc1b41c096c83130" width="640" height="350">&nbsp;</iframe> 

Hace unos dias mientras revisaba algunos parametros en un servidor personal note que se habia colado un spammer. Afortunadamente, el individuo habia dejado un rastro en syslog y bash_history, por lo que fue facil tracearlo, eliminar sus procesos y cuenta. Hecho esto, cambie la contraseña y reinicie todo. Lo mas doloroso del incidente es que me di cuenta que la contraseña *master* que he usado por años ya no es segura =(.

Revisando las bitacoras del sistema, reafirme que el acceso fue mediante fuerza bruta, así que decidi reforzar la seguridad.

Conozco varias formas de hacerlo, se puede cambiar la contraseña (a una en verdad dificil), cambiar el puerto, filtrar por ip, filtrar por intentos (fail2ban), usar algun modulo pam, o deshabilitar la opcion por completo.

Al final, decidi agregar un captcha. ¿Por que?, pues a mi forma de ver las cosas, la mayoria de ataques (incluyendo este) son automatizados, al agregar un captcha, aunque el script tenga la contraseña en su base de datos, la autenticacion fallara debido al captcha (si no reconoce la cadena, ni siquiera tendra posibilidad de introducir una contraseña). Otra razon es la facilidad de uso, instalacion y tambien porque no, el toque l337 de los projectos de Jordan Sissel. Reconozco que si un individuo tiene la contraseña y hace un intento manualmente podra entrar. Sin embargo para servidores personales creo que es suficiente. Ya me puedo liar con configuraciones mas avanzadas para servicios criticos.

Algunos otros metodos que descarte fueron:

- [google authenticator](https://code.google.com/p/google-authenticator/) (mi telefono casi siempre esta apagado, perdido o sin bateria)
- [barada](http://barada.sourceforge.net/) (misma razon)
- [otpw](https://www.cl.cam.ac.uk/~mgk25/otpw.html) (¿cargar contraseñas en un papel?, ¿estan bromeando?)
- [otp](http://ubuntuforums.org/showthread.php?t=1891356) (generadores en linea.., suena bien, oh, pero fue eliminado de debian|ubuntu desde hace tiempo.., mal presagio)
- [github auth](https://github.com/chrishunt/github-auth) (una interesante forma de obtener certificados de terceros, pero sin utilidad para este caso)
- [authy](http://blog.authy.com/two-factor-ssh-in-thirty-seconds) (necesita un telefono y ademas me forza a usar el metodo incluso cuando me haya autenticado con llaves)
- cualquier otro metodo que requiera [ForceCommand](https://www.duosecurity.com/) o sincronizacion entre relojes

### Instalacion

<pre>
$ sudo add-apt-repository ppa:chilicuil/sucklesstools
$ sudo apt-get update
$ sudo apt-get install libpam-captcha
</pre>

### Configuracion

**/etc/pam.d/sshd**

<pre>
    auth       requisite    pam_captcha.so math randomstring
</pre>

**/etc/ssh/sshd_config**

<pre>
    PasswordAuthentication no
    ChallengeResponseAuthentication yes
    UsePAM yes
</pre>

<pre>
$ sudo service ssh restart
</pre>

Los ultimos 3 pasos se pueden automatizar facilmente, se puede utilizar grep para revisar en ambos archivos si las opciones se encuentran habilitadas, y habilitarlas (con sed) en el caso de que no lo estuvieran.

<br>
- [http://www.semicomplete.com/projects/pam_captcha/](https://github.com/psychomario/PyPXE)
- [http://javier.io/blog/es/2010/12/14/compartir-conexion-pc-a-pc.html](http://javier.io/blog/es/2010/12/14/compartir-conexion-pc-a-pc.html)
