# PHP Refactoring for Atom
PHP Refactoring Browser implementation for atom.

![Screenshot](/screenshot.gif "Screenshot")

## Installation
### Requirements
* PHP
* `patch` command on your system

Just search `php refactoring` in Settings > Install. If you are Windows user you have to install [Git Bash](https://git-scm.com/) first because this plugins require `patch` command in your system to change code.

## Settings
If you can't see package settings open `Extract Method` panel and close it. Then go to Settings and you will see settings. (It's Atom bug)

If you are Windows user you will have to specify `patch` command path. When you are using Git Bash it's located at: `C:/Users/<Your User Name>/AppData/Local/Programs/Git/usr/bin/patch.exe`

## Usage
You can use default key bindings or select code range / variable and right click on it. Also you can use navigation in Packages > PHP Refactoring.

To rename or convert variable you have to have selected variable, not just cursor on it.

### Default key bindings
* `ctrl-alt-r e` Extract method
* `ctrl-alt-r r` Rename variable
* `ctrl-alt-r c` Convert local variable to instance variable
* `ctrl-alt-r o` Optimize use statements

### Commands
* php-refactoring:extract
* php-refactoring:rename-variable
* php-refactoring:convert-variable
* php-refactoring:optimize
