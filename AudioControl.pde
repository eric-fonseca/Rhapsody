class AudioControl{
  String directory;
  String[] audioTracks;
  FilePlayer[] audioPlayer;
  AudioOutput[] out;

  AudioControl(String directory_, String[] trackNames_) {
     directory = directory_;
     audioTracks = trackNames_;
     println(audioTracks);
  }
  
  void init(){
     audioPlayer = new FilePlayer[audioTracks.length];
     out = new AudioOutput[audioTracks.length];
    
     for(int i = 0; i < audioTracks.length; i++){
        out[i] = minim.getLineOut();
        audioPlayer[i] = new FilePlayer(minim.loadFileStream("audio/" + directory + "/" + audioTracks[i], 1024, true));
     }
     
     for(int i = 0; i < audioTracks.length; i++){
        audioPlayer[i].rewind();
        audioPlayer[i].play();
        audioPlayer[i].patch(out[i]);
     }
     
     visualizer = new Visualizer(out);
  }
}
