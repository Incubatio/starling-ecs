build: clean data
	mxmlc -debug=true -static-link-runtime-shared-libraries=true -library-path+=./vendors/MonsterDebugger.swc:./vendors/starling.swc -output=build/Main.swf src/Main.as

clean: 
	rm -rf build

server: 
	@python -um SimpleHTTPServer 2>&1| grep -v KeyboardInterrupt

deploy: 
	git push -f origin HEAD:gh-pages

data:
	coffee --print --bare --compile src/data.coffee | tail -n +3 | sed 's/});/}/' | sed 's/({/{/' |  tr -d '\n' | gsed "s/\([^ '\"]\w*[^ '\"]\):/\"\1\":/g" > data.json
