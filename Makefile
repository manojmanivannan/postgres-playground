# Define the default target
all: run-script

# Determine the operating system
ifeq ($(OS),Windows_NT)
    # Windows batch file
    SCRIPT := download-extra-dataset.bat
else
    # Unix/Linux shell script
    SCRIPT := download-extra-dataset.sh
endif

run-script:
	./$(SCRIPT)
