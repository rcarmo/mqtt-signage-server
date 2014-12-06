# set up fig so we can manage the rest of the project
bootstrap:
	sudo pip install -U fig

client:
	fig run app hy client.hy	

serve:
	fig up

repl:
	fig run app hy

deps:
	pip install -r requirements.txt
