all:
	@docker build -t="oransel/spotweb" .

start:
	@docker run -P -d --name spotweb oransel/spotweb

stop:
	@docker rm -f spotweb

restart: stop start

clear: stop
	@docker rmi oransel/spotweb