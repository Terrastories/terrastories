// Pause All Playing Videos
//
// This function is called when a video is played (by binding to the `play`
// event), and it used to stop any other videos from continuing to play.
window.pauseAllVideos = function(elem){
  var videos = document.querySelectorAll('video');
  for (var i=0; i<videos.length; i++) {
    if(videos[i] == elem) {
      continue;
    }
    if (videos[i].played.length > 0 && !videos[i].paused) {
      videos[i].pause();
    }
  }
}
