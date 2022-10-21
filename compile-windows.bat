@echo off
flutter build windows --release & copy /y *.dll build\windows\runner\Release & 7z a map_level_maker-windows.zip build\windows\runner\Release
