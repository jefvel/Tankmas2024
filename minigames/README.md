# minigames/

1. Place minigames here! Using a git submodule is preferred.
    - Make sure the `Project.xml`, `assets`, and `source` folders are all below the main folder.
2. Add the following to the main `Project.xml` in the Minigames section. Make sure to use the correct minigame ID!

```xml
<section unless="exclude_bunnymark">
	<classpath path="minigames/bunnymark/source"/>
	<library name="bunnymark" preload="false" />
	<assets path="minigames/bunnymark/assets" rename="assets/minigames/bunnymark" library="bunnymark" exclude="*.ase|*.wav"/>
</section>
```

3. Edit `assets/data/entries/minigames.json` and add an entry to the `minigames` list.
4. Add a Minigame entity in the LDTK project whose `minigame_id` value is the ID of the associated minigame.
5. Edit `source/minigames/MinigameHandler.hx` and edit `initalize()` to add the minigame's constructor to the `constructors` list.

Note that `external` minigames don't need code, just an entry in `minigames.json` and a corresponding Minigame entity in the LDTK project.

## Minigame Types

There are three types of minigames:
- `overlay`: This displays the minigame as a substate. This is the primary mode to use.
- `state`: This fully switches states to play the minigame. Currently not implemented, but should only be needed if the minigame truely doesn't support being a substate for some reason.
- `external`: Displays a prompt to access an external URL. This is good for things like linking the previous Tankmas events!
