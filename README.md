# Rhapsody Setup:

Don’t fret! Most of Rhapsody is modular and will adapt to the situation it is run in. For the full music jam experience, the setup requires the following:

##### 1. A running Computer that needs:
- The capability to display two screens that will be hooked up.
- Good heat circulation for long run periods!
- Processing 2 installed. This runs on any OS, and is completely free to any consumer. (https://processing.org/)
    - Note: The multi-touch library is currently not supported by later versions of Processing so Processing 2 is recommended.
- The SMT Library must be imported before running.
    - This is very easy: Open Processing sketch -&gt; Top-left sketch tab -&gt; Import Library -&gt; Add Library…-&gt; and then search for this term: SMT
    - Simple Multi-Touch is tool that Rhapsody uses that allows a multi-touchscreen to give the Processing sketch references to more than one touch at once.
    - Otherwise only one touch will be recognized at a given moment.
- To download the project! (https://github.com/eric-fonseca/Rhapsody.git)
    - This project is built to run on the desktop of the computer. Otherwise, you will need to change the following lines of code for the Visualizer.pde file and make them point to the  data directory of the main sketch:
    ```processing 
    PImage logo = loadImage(System.getProperty("user.home") + "/Desktop/Rhapsody/data/logo.png");
    ```
    ```processing 
    musicVideo = new Movie(this, System.getProperty("user.home") + "/Desktop/Rhapsody/data/" + artistName + ".mp4");
    ```

##### 2. A multi-touchscreen hooked to the running computer.
- Optimally configured for 1920x1280 resolution. Rhapsody can be cleanly run on other resolutions as well.

##### 3. Projector visuals hooked to the running computer.

##### 4. Sound system appropriate to the environment, hooked to the running computer.

- Be careful with setting the volume, the effects can make the sound bloom to almost three times the loudness. Leaving a lot of quietness for the sound to get louder is a good idea.

---

##### Once everything is connected, the startup is as follows:

1. Extend the connected displays of the multi-touch, and the projector so they are displaying two different desktop screens.
2. Within the extracted folder, open any of the .pde files, and present the sketch.
    * Open Processing sketch -&gt; Top-left sketch tab -&gt; Present Sketch
    * Or simply use Ctrl + Shift + R
3. Alt-Tab out of the presentation, and within the extracted folder navigate to the /Visualizer folder. From there, open Visualizer.pde. However this sketch must simply be played.
    * Press the play button in Processing.
    * Or simply press Ctrl + R
4. Move the sketch to the projector’s screen, then Alt-Tab so the former sketch’s screen is the primary focus of the computer.
5. Play!

Unfortunately in our prototype stage, the library we are using is a fickle and unstable creature. Rhapsody will occasionally crash and stop responding. But again, no need to fret! Processing is easy to restart and will be up and running as quickly as the music jam stopping.