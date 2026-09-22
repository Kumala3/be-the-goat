# Be The GOAT

So, the basic idea of a game is that you're playing as a goat and mosquitos are coming from every side to bite your ass. 

Since you're the goat, you need to stay alive as long as you can.

How to play:
	- move with the arrow keys (WASD don't work!)
	- don't let mosquitos bite your ass to death

Every second alive is a point and mosquitos spawn faster the longer you're alive.

## Features

- 3 health, if mosquito bites you: -1 health and after a bite, you're safe for a moment
- Power-ups spawn around the map to give you some advantages:
  - **Shield**: 5 seconds of swatting mosquitos on contact
  - **Hourglass**: mosquitos slow down for 5 seconds
  - **Mushroom**: the goat shrinks to make dodging easier for 5 seconds
  - **Heart**: +1 health (max 3, so if you already have 3, you won't have 4)
- Best score is saved between sessions
- 8-bit pixel art (that old-vibe feel)

## Work behind the scenes 

I'm new to Godot, so i read the user manual docs (really well-written!) and started from the official Godot "Dodge the Creeps" tutorial and built the base game by following it: player movement, mob spawning along a path, the HUD, score and timers. That part took about 2 hours from 0.

Then, I thought that this game is actually fun to play and i wanted to turn it into my own game. So, i wanted to save my best score, be the GOAT, have powerups,health score, and have that 8-bit, retro pixel style to make playing fun.

- used Claude to help me write the code for the new features i added on top: power-ups, saving the best-score save, making enemies spawn faster. 
- the sprites were generated with ChatGPT from my prompts

Music and the game over sound are from the Dodge the Creeps tutorial assets. The font is Xolonium.

## Running it

Open the project in Godot 4.7 and press F5.
