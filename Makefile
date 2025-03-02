# Default love2d installation path

ifeq ($(OS),Windows_NT)
    LOVE_PATH = "C:\Program Files\LOVE\love.exe"
else
    LOVE_PATH = "love"
endif

.PHONY: run
run:
	$(LOVE_PATH) .

.PHONY: clean
clean:
	del /Q *.love 