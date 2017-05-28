# Detalhes da camada de front-end

Para utilizar o projeto faça o clone deste [repositório](https://bitbucket.uhub.biz/projects/WUNBRA/repos/wunderman-gulpstarter/browse) em seu projeto.

### Linguagens utilizadas:
  - HTML
  - CSS | Sass
  - JS | Coffeescript
  
### Dependências do projeto: 
  - {dependência} (versão {versão})

### Arquitetura:
  - OOP


# Utilizando o template:

### A pasta compiler contém o gulp e suas taks

Entrar nesta pasta /compiler pelo terminal e executar os seguintes comandos: 

	npm install npm

	npm install

	bower install

	gulp

Quando se fazer necessária a inclusão de uma nova dependência ao projeto, efetivar a mesma via bower e não esquecer do paramentro --save ao final, para que fique salvo no package.

	bower install {dependencia} --save

## Injeção dos templates e dependêcias

### Dependêcias

As dependências estão sendo compiladas para um único arquivo, através do gulp-useref.
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

O path js/app-vendors.js se refere ao destino/nome_do_arquivo gerado com as depedências.

### Templates

os templates também estão sendo ignorado via nunjucks, para tal, deve-se seguir o modelo:

	{% include "partials/loading.html" %}


- Na pasta source/html existe um diretório /partials, neste tudo que há contido é descartado pelo nunjucks até que se injete via include.
- Os únicos arquivos compilados diretamente são os *.html constantes do source/html 
- O nunjucks é um pré-procesador muito robusto e tem diversas utilidades que nos trazem praticidade como loops, arrays, functions, etc. Ver mais na [doc](https://mozilla.github.io/nunjucks/) deles.

### Javacript

Na pasta source/js serão inseridos os códigos tanto javascript quanto coffeescript. 

O gulp está preparado para detectar automaticamente a extensão e compilar devidamente os arquivos.

- O arquivo app-main constante neste diretório pode ser .coffee ou .js e nele importados outros
- Só serão gerados bundles de arquivos que possuem o prefixo "app-", sendo assim, na necessidade de gerar mais de um bundle, basta criar outro arquivo no mesmo diretório com o mesmo prefixo "app-"
- Todos os arquivos que forem importados dentro deste serão copilados para o bundle, mas devem ter sua extensão declarada na chamada, para que o gulp se localize e trabalhe corretamente
	

	HomeView = require "./views/HomeView.coffee"
	Loader = require "./mars/loader/Loader.js"
	
### CSS

Em source/css  existem diversos utilitários que podem ser importados para utilização:

- _animation.scss (inclui keyframes e animation com todos os fallbacks)
- _function.scss (funções gerais de matemática)
- _grid.scss (classes utilitárias com tamanhos baseados em %)
- _mixins.scss (utilitários para inclusçã fontsize com fallback, mediaquerie, input-placeholder, etc)
- _units.scss (classes utilitárias com tamanhos pré setados para facilitar a escrita html como margin-top5, padding-right10, no-margin, no-marginAfter, font08, font11, etc)
- _variables.scss (este já possui algumas varias de easing e deve ser utilizado para centralizar todas as variáveis do projeto)


No diretório /partials deve-se colocar tudo que for independente no projeto e não geral, como _home.scss, _product.scss, etc.

No diretório /components deve-se colocar tudo que for asset ou componente do projeto, como _carousel.scss, _accordeon.scss, etc.


### Imagem

Existe um diretório source/img, neste devem ser colocadas todas as imagens utilizadas no projeto.
Na task de imagem do gulp, além de move-las ao destino também já é executada a otimização das mesmas.

### Fonts

Todas as fontes devem ser colocadas no diretório source/fonts, o gulp fará a cópia das mesmas para a o diretório de destino.

### Json

Qualquer dado que precise ser carregado via json, deve ser disponibilizado no diretório sources/data. 
O gulp fará a cópia dos arquivos para a o diretório de destino.

# Importante

- Realizar o GitFlow antes de inciar o desenvolvimento.
- Fazer commits regulares, sempre descrevendo no máximo de detalhes o que foi feito.
- Sempre executar task ```gulp prod``` antes de publicar em HML ou produção.






