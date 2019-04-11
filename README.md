# Joyeuse
FPS Framework for Godot. Provides nodes for AI, Navigation and interactions with areas and *Workstations*.
NOTE: This framework is work in progress, most things won't work out of the box. 
# Editors
## Character Editor
This works as a cohesive dedicated program to create characters ready to be placed into a world so they can make it vivid and functional. 
This is archived through: 

### AI
This is acomplished using a node based Behavior Tree editor, then taking information of connections and "compiling" them into a script which is attached to a model.

### Model 
The users are given certain parameters to make sure the model they selected is on scale with other characters and its colliders are correct. It also gives the user the option to create ragdolls for them, a better, easier to understand gizmo is to be implemented.

### Parameters 
 Even if the system already uses a Behavior Tree to explain how certain AI works, there are still some things that must be adressed, like health, strenght, speed, jump height, etc. This Tab serves to contain them and allow the user to modify them, with sections and categories easy to remember. 
 
## Level Editor
This level editor is archieved through a series of different methods, the main editor will allow the users to prototype their levels using CSG shapes and use Grid Maps if they desire to, providing a layered approach. 


#Prefabs, nodes and addons

##Workstations
Workstations (Or objectives) serve as a reference point for AI, so it looks for it, be it whatever you need it to be, from resources, food, water, terminals, reactors, etc. Anything that can serve for a Character to look for will be archievable with workstations. 

##KinematicMovable 
Inherits from KinematicBody, allows easier implementation of characters through simplified functions that allow gravity, acceleration, deacceleration and other parameters to be changed from code. 



