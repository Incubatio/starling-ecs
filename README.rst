============
STARLING-ECS
============
Entity component framework based on starling.

Requirements
============
- **nodejs**
- **coffeescript** (when you have node just execute "npm install -g coffee-script") - *compile config file in coffee script*
- **mxlmc** - *if you use the terminal to compile*
- **python** - *used as a server for dev purposes*


Commands
========
``make clean``  = remove build

``make data``   = compile coffee sources

``make``        = make clean, make data, compile flash sources

``make deploy`` = publish master on gh-pages branch

``make server`` = start a python server on port 8000


Folder architecture
===================

**public**  = is an accessible folder from internet (/path/to/project/public/path/to/something = my.website.com/path/to/something)
  and contains public resources like the index.php but also the css, js and the images.  

**src**     = raw sources  

**build**   = compiled source  
