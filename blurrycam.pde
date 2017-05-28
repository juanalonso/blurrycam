import processing.video.*;

Capture video;
int camW = 1280;
int camH = 720;

int numPixels;
int[][] backgroundPixels;
int iCounter, iSaveCounter;
int blurEveryNFrames = 15;
int saveEveryNBlurs = 5;
boolean isRecording = false;

String sTimestamp; 

void setup() {

  size(1280, 720);
  background(0);

  //println(Capture.list());
  video = new Capture(this, Capture.list()[0]);
  video.start();

  numPixels = camW * camH;
    
  loadPixels();

  resetSequence();
}

void draw() { 

  if (video.available()) {

    video.read();

    if (isRecording) {

      if (frameCount % blurEveryNFrames == 0) {

        for (int i = 0; i < numPixels; i++) {

          color currColor = video.pixels[i];

          int currR = (currColor >> 16) & 0xFF; 
          int currG = (currColor >> 8) & 0xFF; 
          int currB = (currColor) & 0xFF; 

          backgroundPixels[i][0] += currR;
          backgroundPixels[i][1] += currG;
          backgroundPixels[i][2] += currB;

          pixels[i] = 0xFF000000 | ((backgroundPixels[i][0]/iCounter) << 16) | (backgroundPixels[i][1]/iCounter << 8) | (backgroundPixels[i][2]/iCounter);
        }

        updatePixels();

        iCounter++;

        if (iCounter % saveEveryNBlurs == 0) {
          save(sTimestamp + "_" + iSaveCounter + ".png");
          iSaveCounter++;
        }
      }

      image(video, width-camW/4, height-camH/4, camW/4, camH/4);
      text(iCounter, width-camW/4 + 4, height-4);
    } else {

      image(video, 0, 0);
    }
  }
}

void keyPressed() {

  if (key==' ') {
    if (!isRecording) {
      isRecording = true;
    } else {
      resetSequence();
    }
  }
}

void resetSequence() {
  sTimestamp =  "" + year() + month() + day() + "_" + hour() + minute() + second();  
  iCounter = 1;
  iSaveCounter = 1;
  backgroundPixels = new int[numPixels][3];
}