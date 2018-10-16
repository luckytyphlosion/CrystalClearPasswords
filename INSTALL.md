# Linux

	sudo apt-get install make git

	git clone https://github.com/rednex/rgbds
	cd rgbds
	sudo make install
	cd ..

	git clone https://github.com/luckytyphlosion/CrystalClearPasswords
	cd CrystalClearPasswords

	make

# Mac

Get [**Homebrew**](http://brew.sh/).

Then in **Terminal**, run:

	xcode-select --install
	brew install rgbds

	git clone https://github.com/luckytyphlosion/CrystalClearPasswords
	cd CrystalClearPasswords

	make


# Windows

To build on Windows, use [**Cygwin**](http://cygwin.com/install.html) (64-bit). Use the default settings.

In the installer, select the following packages:
- `make`
- `git`

Then download [**rgbds**](https://github.com/bentley/rgbds/releases).
Extract the archive. Inside should be `rgbasm.exe`, `rgblink.exe`, `rgbfix.exe`, `rgbgfx.exe` and some `.dll` files. Put each file in `C:\cygwin64\usr\local\bin\`. If your Cygwin installation directory differs, ensure the `bin` directory is present in the PATH variable.

In the **Cygwin terminal**:

	git clone https://github.com/luckytyphlosion/CrystalClearPasswords
	cd CrystalClearPasswords

	make

# Adding Pokémon

The main file is main.asm, the labels for the input data are `NewPasswords` and `NewPokemonSource`.

Documentation is provided, it should be easy enough to follow by example to create a password/Pokémon combination.
