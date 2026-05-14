.PHONY: all pub-get run-web

all: pub-get run-web

pub-get:
	flutter pub get

run-web:
	flutter run -d chrome
