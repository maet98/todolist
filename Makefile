install_backend:
	docker compose -f ./backend/docker-compose.yml build

install_mobile:
	cd mobile && flutter pub get

install: install_mobile install_backend

run_backend:
	docker compose -f ./backend/docker-compose.yml up -d

run_mobile:
	cd mobile && flutter run

run: run_backend run_mobile

down_backend:
	docker compose -f ./backend/docker-compose.yml down

