all: 
	make download
	make dk_start

download:
	$(SCRIPT)

dk_start:
	docker-compose up
dk_stop:
	docker-compose down --volumes --remove-orphans

# Determine the operating system
ifeq ($(OS),Windows_NT)
    # Windows batch file
    SCRIPT := download-extra-dataset.bat
else
    # Unix/Linux shell script
    SCRIPT := ./download-extra-dataset.sh
endif

download-extras:
	$(SCRIPT)




