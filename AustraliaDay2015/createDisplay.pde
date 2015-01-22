
void create() {

  //Clear screen
  background(0);

  //Text
  fill(255);
  textFont(f1);
  textAlign(CENTER);
  text("Current Session", width/2, 50);
  text("Ranking", width/2, 180);

  //Find Minimum sector time
  for (int j = 0; j < 9; j++) {
    for (int i = 0; i < index; i++) {
      if (data[i][j] < min[j]) {
        min[j] = data[i][j];
      }
    }
  }

  //Find Max sector time
  for (int j = 0; j < 9; j++) {
    for (int i = 0; i < index; i++) {
      if (data[i][j] > max[j]) {
        max[j] = data[i][j];
      }
    }
  }

  //Alternating Bars    
  fill(40);
  stroke(40);
  rectMode(CENTER);
  for (int i = 1; i < index + 1 && i < 25; i = i + 2) {
    rect(width/2 + 77, (201 + (i * 20)), 1035, 19, 7);
  }
  rect(width/2 + 77, 114, 1035, 24, 7);

  //Text for Current Session
  fill(255);
  textFont(f2);
  textAlign(CENTER);
  text("Name", width/2 - (115 * 4) + 57, 96);
  text("Reaction Time", width/2 - (115 * 3) + 57, 96);
  text("Speed", width/2 - (115 * 2) + 57, 96);
  text("Sector 1", width/2 - (115 * 1) + 57, 96);
  text("Sector 2", width/2 - (115 * 0) + 57, 96);
  text("Sector 3", width/2 + (115 * 1) + 57, 96);
  text("Sector 4", width/2 + (115 * 2) + 57, 96);
  text("ET", width/2 + (115 * 3) + 57, 96);
  text("Total Time", width/2 + (115 * 4) + 57, 96);

  //Text for times and name of current session
  if (count == 7 && nameSet == false) {
    for (int i = 1; i < count + 2; i++) {
      //Check for minimum time 
      if (data[index -  1][i] <= min[i]) {
        rectMode(CORNERS);
        fill(c1);
        text(String.format("%.2f", data[index -  1][i]), width/2 - (115 * (4 - i)) + 57, 120);
      } else if (data[index -  1][i] >= max[i]) {
        rectMode(CORNERS);
        fill(c2);
        text(String.format("%.2f", data[index -  1][i]), width/2 - (115 * (4 - i)) + 57, 120);
      } else {
        fill(255);
        text(String.format("%.2f", data[index -  1][i]), width/2 - (115 * (4 - i)) + 57, 120);
      }
    }
    fill(255);
    text(names[int(data[index - 1][0])], width/2 - (115 * 4) + 57, 120);
  } else {
    for (int i = 1; i < count + 1; i++) {
      //Check for minimum time 
      if (data[index][i] <= min[i]) {
        rectMode(CORNERS);
        fill(c1);
        //        text(String.format("%.2f", data[index][i]), width/2 - (115 * (4 - i)) + 57, 120);
      } else if (data[index][i] >= max[i]) {
        rectMode(CORNERS);
        fill(c2);
        //        text(String.format("%.2f", data[index][i]), width/2 - (115 * (4 - i)) + 57, 120);
      } else {
        fill(255);
        //        text(String.format("%.2f", data[index][i]), width/2 - (115 * (4 - i)) + 57, 120);
      }
      text("Hit", width/2 - (115 * (4 - i)) + 57, 120);
    }
    fill(255);
    text(names[int(data[index][0])], width/2 - (115 * 4) + 57, 120);
  }

  //Sort the list for ranking based on total time
  for (int i = 0; i < index; i++) {
    sortList[i] = data[i][8];
  }
  sortList = sort(sortList);

  //Generate a list of the ranked positions
  for (int i = 0; i < index; i++) {
    for (int j = 0; j < index; j++) {
      if (data[j][8] == sortList[i]) {
        sortListPos[i] = j;
      }
    }
  }

  //text for times and names of Ranking
  if (sortFastest) { //For fastest first
    textFont(f3);
    for (int i = 0; i < index && i < 24; i++) {
      fill(255);
      textAlign(LEFT);
      text((i + 1) + ".", width/2 - (115 * 5) + 100, 226 + (20 * i));
      textAlign(CENTER);
      text(names[int(data[sortListPos[i]][0])], width/2 - (115 * 4) + 57, 226 + (20 * i));
      for (int j = 1; j < 8 + 1; j++) {
        //Check for minimum time 
        if (data[sortListPos[i]][j] <= min[j]) {
          rectMode(CORNERS);
          fill(c1);
          //          rect(410 + ((j - 1) * 115), 210+(i*20), 525 + ((j-1)*115), 230+(i*20));
          text(String.format("%.2f", data[sortListPos[i]][j]), width/2 - (115 * (4 - j)) + 57, 226 + (20 * i));
        } else if (data[sortListPos[i]][j] >= max[j]) {
          rectMode(CORNERS);
          fill(c2);
          //          rect(410 + ((j - 1) * 115), 210+(i*20), 525 + ((j-1)*115), 230+(i*20));
          text(String.format("%.2f", data[sortListPos[i]][j]), width/2 - (115 * (4 - j)) + 57, 226 + (20 * i));
        } else {
          fill(255);
          text(String.format("%.2f", data[sortListPos[i]][j]), width/2 - (115 * (4 - j)) + 57, 226 + (20 * i));
        }
      }
    }
  } else { //For slowest first
    textFont(f3);
    for (int i = 0; i < index && i < 24; i++) {
      fill(255);
      textAlign(LEFT);
      text((i + 1) + ".", width/2 - (115 * 5) + 100, 226 + (20 * i));
      textAlign(CENTER);
      text(names[int(data[sortListPos[index-i-1]][0])], width/2 - (115 * 4) + 57, 226 + (20 * i));
      for (int j = 1; j < 8 + 1; j++) {
        //Check for minimum time 
        if (data[sortListPos[index - 1-i]][j] <= min[j]) {
          rectMode(CORNERS);
          fill(c1);
          //          rect(410 + ((j - 1) * 115), 210+(i*20), 525 + ((j-1)*115), 230+(i*20));
          text(String.format("%.2f", data[sortListPos[index-1-i]][j]), width/2 - (115 * (4 - j)) + 57, 226 + (20 * i));
        } else if (data[sortListPos[index - 1-i]][j] >= max[j]) {
          rectMode(CORNERS);
          fill(c2);
          //          rect(410 + ((j - 1) * 115), 210+(i*20), 525 + ((j-1)*115), 230+(i*20));
          text(String.format("%.2f", data[sortListPos[index-1-i]][j]), width/2 - (115 * (4 - j)) + 57, 226 + (20 * i));
        } else {
          fill(255);
          text(String.format("%.2f", data[sortListPos[index-1-i]][j]), width/2 - (115 * (4 - j)) + 57, 226 + (20 * i));
        }
      }
    }
  }

  //Draw box and text for sort selection
  rectMode(CORNER);
  textFont(f3);
  textAlign(LEFT);

  stroke(255);  
  fill(255);
  if (sortFastest) {
    text("Fastest", boxX+20, boxY+13);
  } else {
    text("Slowest", boxX+20, boxY+13);
  }
  fill(c3);
  stroke(50);
  rect(boxX, boxY, boxSize, boxSize);

  //Draw text for Ready
  textFont(f1);
  textAlign(LEFT);
  if (count == 0 && nameSet == true) {
    fill(0, 255, 0);
    //    text("Ready", 20, 300);
  } else {
    fill(255, 0, 0);
    //    text("Not Ready", 20, 300);
  }

  //Text for current mode for the swtich
  text(mode, 20, 350);

  //Mimic lights
  ellipseMode(CORNER);
  if (redON) {
    fill(255, 0, 0);
  } else { 
    fill(50, 0, 0);
  }
  ellipse(20, 360, 40, 40);

  if (blueON) {
    fill(0, 0, 255);
  } else {
    fill(0, 0, 50);
  }
  ellipse(20, 410, 40, 40);

  if (greenON) {
    fill(0, 255, 0);
  } else {
    fill(0, 50, 0);
  }
  ellipse(20, 460, 40, 40);

  if (yellowON) {
    fill(255);
  } else {
    fill(50);
  }
  ellipse(20, 510, 40, 40);
}
