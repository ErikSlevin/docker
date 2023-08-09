<p align="center">
<a href="https://github.com/linuxserver/Heimdall"><img src="media/my-dashboard.png" width="850" alt="heimdal"></a><br/>
</p>

# Heimdall
Self-Hosted Dashboard

## Custom CSS-Anpassungen

Random 4k Background Image von [unsplash.com](https://www.unsplash.com)

``` css
body #app {
  background-image: url("https://source.unsplash.com/random/3440x1440?nature");
  background-size: cover;
}
```

## Custom-Template

Bilder-Syntax ```bild1.jpg```,```bild2.jpg``` ..

1. Ordner ```bg``` in ```/home/erik/``` erstellen
2. Ausführen ``` docker exec -it heimdall /bin/bash```
3. Ordner ```bg``` in ```/app/www/public/img/``` erstellen
4. Container-terminal beenden```exit```
5. Bilder kopieren zum Server ```C:\Users\erik\Desktop\UnsplashBilder\* Docker-Pi-2:/home/erik/bg``` (Ordner bg chmod 777)
6. In den Container kopieren ```docker cp . heimdall:/app/www/public/img/bg```

### CSS
``` css
/* Stil für das HTML-Element mit der ID "app" */
#app {
    width: 100%;
    height: 100vh;
    background-position: center center !important;
    background-repeat: no-repeat !important;
    background-size: cover !important;
    min-height: 100vh !important;
}
```
### JS
``` JavaScript
document.addEventListener("DOMContentLoaded", function() {
    var appElement = document.getElementById("app");
    var randomImageIndex = Math.floor(Math.random() * 50) + 1;
    var imageUrl = "../img/bg/bild" + randomImageIndex + ".jpg";

    appElement.style.setProperty("background-image", "url('" + imageUrl + "')", "important");
});
```
## Quellen

* [https://github.com/linuxserver/Heimdall](https://github.com/linuxserver/Heimdall)
* [https://heimdall.site/](https://heimdall.site/)
* [https://hub.docker.com/r/linuxserver/heimdall/](https://hub.docker.com/r/linuxserver/heimdall/)