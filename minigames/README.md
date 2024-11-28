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