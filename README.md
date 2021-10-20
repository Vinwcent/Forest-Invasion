# Forest-Invasion
SmashTV-Roguelike iOS game.

## Introduction

This game is a Roguelike game based on the _SmashTV_ GameStyle.
I got this idea while playing _Journey of the Prairie King_ and made it in few months.
If you want to play, just compile the game in an iOs device, the interface will adapt.
Most designs were edited by me with itch.io assets or made entirely by me.


## Quick Gameplay Description
<p float="left">
  <img src="https://raw.githubusercontent.com/Vinwcent/Forest-Invasion/main/PresentationsPictures/titleScreen.PNG" width=20% height=20%>
  <img src="https://raw.githubusercontent.com/Vinwcent/Forest-Invasion/main/PresentationsPictures/shop.PNG" width=20% height=20%>
  <img src="https://raw.githubusercontent.com/Vinwcent/Forest-Invasion/main/PresentationsPictures/game.PNG" width=20% height=20%>
</p>

Once you've started the game and pushed the play button you end up in the shop place (Where most items are free since the game is still in development). Then you can move on right or down to go to another place where you will be attacked.
There you'll have to use joysticks to attack enemies with your bow. There's 8 possibles directions to fire at.

<img src="https://user-images.githubusercontent.com/91033856/138105049-0e58d59d-468f-4990-b7c8-9edbbb778783.gif" width=20% height=20%>

## Items and Power-ups

There's around 20 items with various effects (poison, make the enemy your ally, better fire rate... I let you discover them in game or in code :D ). All of them can be bought at the shop for 0$ or 5$ but you can change everything in the code and add your own items if you want.

There's also power-ups which are 1-time use item (They can be used by tapping the screen where enemies are when you have one) that give you super power. They can fall on the ground when you kill an enemy and you can increase the spawnRate in the project but the actual value seems fair.

<img src="https://user-images.githubusercontent.com/91033856/138107448-df48f9ed-fe47-4738-9346-a68bb6b76c7f.gif" width=20% height=20%>

## The Map

<img src="https://raw.githubusercontent.com/Vinwcent/Forest-Invasion/main/PresentationsPictures/map.PNG" width=20% height=20%>

Finally when you're moving from a side to another you're changing the scene and if you just discover it there will be enemies. At this moment there's only one difficulty level so you'll always fight against the same types of enemies (Skeleton, orc, mushrooms) but there's already stronger enemies implemented (mole which can walk underground for example ), just set them up in the stage file !

### Credits

Joysticks were based on the code from https://github.com/MitrofD/TLAnalogJoystick

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
