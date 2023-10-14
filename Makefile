default: usage

all: 
	make download
	make dk_start

download:
	$(SCRIPT)

dk_start:
	docker-compose up --build -d
dk_stop:
	docker-compose down --volumes --remove-orphans

clean:
	make dk_stop
	docker rmi manojmanivannan18/postgres-playground-py

# Determine the operating system
ifeq ($(OS),Windows_NT)
    # Windows batch file
    SCRIPT := download-extra-dataset.bat
	ECHO = echo
else
    # Unix/Linux shell script
    SCRIPT := ./download-extra-dataset.sh
	ECHO = echo
endif

download-extras:
	$(SCRIPT)

usage:
	@$(ECHO) Usage
	@$(ECHO) 	make dk_start   - Start the docker containers
	@$(ECHO) 	make dk_stop    - Stop the docker containers
	@$(ECHO) 	make download   - Download extra dataset from web
	@$(ECHO) 	make all        - Download extra dataset from web and Start the docker containers
