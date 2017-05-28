# Detalhes da camada de front-end

Para utilizar o projeto fa&ccedil;a o clone deste [reposit&oacute;rio](https://bitbucket.uhub.biz/projects/WUNBRA/repos/wunderman-gulpstarter/browse) em seu projeto.

### Linguagens utilizadas:
  - HTML
  - CSS | Sass
  - JS | Coffeescript
  
### Depend&ecirc;ncias do projeto: 
  - {depend&ecirc;ncia} (vers&atilde;o {vers&atilde;o})

### Arquitetura:
  - OOP


##Utilizando o template:##

##A pasta compiler cont&eacute;m o gulp e suas taks##

Entrar nesta pasta /compiler pelo terminal e executar os seguintes comandos: 

> npm install npm

> npm install

> bower install

> gulp

Quando se fazer necess&aacute;ria a inclus&atilde;o de uma nova depend&ecirc;ncia ao projeto, efetivar a mesma via bower e n&atilde;o esquecer do paramentro --save ao final, para que fique salvo no package.

> bower install {depend&ecirc;ncia} --save

##Inje&ccedil;&atilde;o dos templates e depend&ecirc;cias##

###Depend&ecirc;cias###

As depend&ecirc;ncias est&atilde;o sendo compiladas e unificadas em um &uacute;nico arquivo, atrav&eacute;s do numjucks.
Para isso, ao final no HTML defina o seguinte:

	<!-- build:js js/app-vendors.js -->
		<script type="text/javascript" src="mobile-detect/mobile-detect.min.js"></script> 
		<script type="text/javascript" src="jquery/dist/jquery.min.js"></script> 
		<script type="text/javascript" src="jquery-touchswipe/jquery.touchSwipe.min.js"></script> 
		<script type="text/javascript" src="jquery-easing/jquery.easing.min.js"></script> 
		<script type="text/javascript" src="circles/circles.min.js"></script> 
		<script type="text/javascript" src="PreloadJS/lib/preloadjs-0.6.2.min.js"></script> 
		<script type="text/javascript" src="gsap/src/minified/TweenMax.min.js"></script> 
		<script type="text/javascript" src="../source/js/mars/animation/SpriteAnim.js"></script> 
	<!-- endbuild -->

O path js/app-vendors.js se refere ao destino/nome_do_arquivo gerado com as deped&ecirc;ncias.

###Templates###

os templates tamb&eacute;m est&atilde;o sendo ignorado via numjucks, para tal, deve-se seguir o modelo:

	{% include "partials/loading.html" %}


- Na pasta source/html existe um diret&oacute;rio /partials, neste tudo que h&aacute; contido &eacute; descartado pelo nunjucks at&eacute; que se injete via include.
- Os &uacute;nicos arquivos compilados diretamente s&atilde;o os *.html constantes do source/html 

##Javacript##

Na pasta source/js ser&atilde;o inseridos os c&oacute;digos tanto javascript quanto coffeescript. 

O gulp est&aacute; preparado para detectar automaticamente a extens&atilde;o e compilar devidamente os arquivos.

- O arquivo app-main constante neste diret&oacute;rio pode ser .coffee ou .js e nele importados outros
- S&oacute; ser&atilde;o gerados bundles de arquivos que possuem o prefixo "app-", sendo assim, na necessidade de gerar mais de um bundle, basta criar outro arquivo no mesmo diret&oacute;rio com o mesmo prefixo "app-"
- Todos os arquivos que forem importados dentro deste ser&atilde;o copilados para o bundle, mas devem ter sua extens&atilde;o declarada na chamada, para que o gulp se localize e trabalhe corretamente
	
	```
	HomeView = require "./views/HomeView.coffee"
	Loader = require "./mars/loader/Loader.js"
	```
	
##CSS##

<a name="v1.0.0">**v1.0.0**</a>
