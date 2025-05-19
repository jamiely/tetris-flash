# Tetris

A Tetris implementation in ActionScript. 

* Written circa 2004 using Flash MX.
* This implementation was updated in 2013 to remove its fla dependency
* Updated in 2025 to play using Ruffle flash emulator.

# Compile

Setup `mxmlc` (as of 2025)

* Install [Adobe AIR SDK](https://airsdk.harman.com/runtime)
* Install [Apache Flex SDK](https://flex.apache.org/installer.html)
* Add required environment variables
  ```bash
  export FLEX_HOME="..."
  export PATH="$FLEX_HOME/bin:$PATH"
  ```

Run `make`.

# Controls

* Left,Right - move a block
* CTRL,UP - rotate a block
* Spacebar - Fast drop a block
* HOME,ENTER - Restart

# Demo

Updated version that plays using [Ruffle flash emulator](https://ruffle.rs/):

https://jamiely.github.io/tetris-flash/

# Media

## Updated

* 2013: http://youtu.be/ChhGMjpxiTo
* 2004: http://youtu.be/NbBIJEZKNuI

# Troubleshooting

> Error: unable to open 'libs/player/31.0/playerglobal.swc'

You need to obtain a copy of the player. Search for `playerglobal.swc`
on the web and you should find a copy.
