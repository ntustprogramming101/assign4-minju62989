



PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage groundhogIdle, groundhogLeft, groundhogRight, groundhogDown;
PImage bg, life, cabbage, stone1, stone2, soilEmpty;
PImage soldier;
PImage soil0, soil1, soil2, soil3, soil4, soil5;
PImage[][] soils, stones;

final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;

final int GRASS_HEIGHT = 15;
final int SOIL_COL_COUNT = 8;
final int SOIL_ROW_COUNT = 24;
final int SOIL_SIZE = 80;

int[][] soilHealth;

final int START_BUTTON_WIDTH = 144;
final int START_BUTTON_HEIGHT = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;

float[] cabbageX, cabbageY, soldierX, soldierY;
float soldierSpeed = 2f;

float playerX, playerY;
int playerCol, playerRow;
final float PLAYER_INIT_X = 4 * SOIL_SIZE;
final float PLAYER_INIT_Y = - SOIL_SIZE;
boolean leftState = false;
boolean rightState = false;
boolean downState = false;
int playerHealth = 2;
final int PLAYER_MAX_HEALTH = 5;
int playerMoveDirection = 0;
int playerMoveTimer = 0;
int playerMoveDuration = 15;
int soilChangeTimer = 0;
int soilChangeDuration = 15;
int stone0ChangeDuration = 30;
int stone1ChangeDuration = 45;

boolean demoMode = false;

void setup() {
  size(640, 480, P2D);
  bg = loadImage("img/bg.jpg");
  title = loadImage("img/title.jpg");
  gameover = loadImage("img/gameover.jpg");
  startNormal = loadImage("img/startNormal.png");
  startHovered = loadImage("img/startHovered.png");
  restartNormal = loadImage("img/restartNormal.png");
  restartHovered = loadImage("img/restartHovered.png");
  groundhogIdle = loadImage("img/groundhogIdle.png");
  groundhogLeft = loadImage("img/groundhogLeft.png");
  groundhogRight = loadImage("img/groundhogRight.png");
  groundhogDown = loadImage("img/groundhogDown.png");
  life = loadImage("img/life.png");
  soldier = loadImage("img/soldier.png");
  cabbage = loadImage("img/cabbage.png");

  soilEmpty = loadImage("img/soils/soilEmpty.png");

  //soil images
  soil0 = loadImage("img/soil0.png");
  soil1 = loadImage("img/soil1.png");
  soil2 = loadImage("img/soil2.png");
  soil3 = loadImage("img/soil3.png");
  soil4 = loadImage("img/soil4.png");
  soil5 = loadImage("img/soil5.png");

  //soils loction
  soils = new PImage[6][5];
  for(int i = 0; i < soils.length; i++){
    for(int j = 0; j < soils[i].length; j++){
      soils[i][j] = loadImage("img/soils/soil" + i + "/soil" + i + "_" + j + ".png");
    }
  }

  // stones loction
  stones = new PImage[2][5];
  for(int i = 0; i < stones.length; i++){
    for(int j = 0; j < stones[i].length; j++){
      stones[i][j] = loadImage("img/stones/stone" + i + "/stone" + i + "_" + j + ".png");
    }
  }

  // player status
  playerX = PLAYER_INIT_X;
  playerY = PLAYER_INIT_Y;
  playerCol = (int) (playerX / SOIL_SIZE);
  playerRow = (int) (playerY / SOIL_SIZE);
  playerMoveTimer = 0;
  playerHealth = 2;

  //soilHealth
  soilHealth = new int[SOIL_COL_COUNT][SOIL_ROW_COUNT];
  for(int i = 0; i < soilHealth.length; i++){
    for (int j = 0; j < soilHealth[i].length; j++) {
      // 0/15/30/45: null/soil/1stone/2stones
      soilHealth[i][j] = 15;
      // section1
      if(i==j)soilHealth[i][j] = 30;
      // section2
      if(j==8 || j==11 || j==12 || j==15){
        if(i==1 || i==2 || i==5 || i==6) soilHealth[i][j] = 30;
      }
      if(j==9 || j==10 || j==13 || j==14){
        if(i==0 || i==3 || i==4 || i==7) soilHealth[i][j] = 30;
      }
      // section3
      if(j==16 || j==19 || j==22){
        if(i==1 || i==4 || i==7) soilHealth[i][j] = 30;
        if(i==2 || i==5) soilHealth[i][j] = 45;
      }
      if(j==17 || j==20 || j==23){
        if(i==0 || i==3 || i==6) soilHealth[i][j] = 30;
        if(i==1 || i==4 || i==7) soilHealth[i][j] = 45;
      }
      if(j==18 || j==21 ){
        if(i==2 || i==5) soilHealth[i][j] = 30;
        if(i==0 || i==3 || i==6) soilHealth[i][j] = 45;
      }
    }
  }
    
  // health0
  for(int l=1;l<24;l++){
    int count = floor(random(2)+1);
        
    for(int k=0;k<count;k++){
      int col = floor(random(8));
      soilHealth[col][l] = 0;
    }
  }
  

  //soidier loction
  soldierX = new float[6];
  soldierY = new float[6];
  
  for(int i=0; i<6; i++){
    float col = random(8);
    int row = floor(random(4))+i*4;
    soldierX[i] = col*SOIL_SIZE;
    soldierY[i] = row*SOIL_SIZE;
  }

  // cabbages loction
  cabbageX = new float[6];
  cabbageY = new float[6];
  
  for(int i=0;i<6;i++){
    int col = floor(random(8));
    int row = floor(random(4))+i*4;
    cabbageX[i] = col*SOIL_SIZE;
    cabbageY[i] = row*SOIL_SIZE;
  }
}

void draw() {

  switch (gameState) {

    case GAME_START: // Start Screen
    image(title, 0, 0);
    if(START_BUTTON_X + START_BUTTON_WIDTH > mouseX
      && START_BUTTON_X < mouseX
      && START_BUTTON_Y + START_BUTTON_HEIGHT > mouseY
      && START_BUTTON_Y < mouseY) {

      image(startHovered, START_BUTTON_X, START_BUTTON_Y);
      if(mousePressed){
        gameState = GAME_RUN;
        mousePressed = false;
      }

    }else{

      image(startNormal, START_BUTTON_X, START_BUTTON_Y);

    }

    break;

    case GAME_RUN:
    image(bg, 0, 0);
      stroke(255,255,0);
      strokeWeight(5);
      fill(253,184,19);
      ellipse(590,50,120,120);
     pushMatrix();
    translate(0, max(SOIL_SIZE * -18, SOIL_SIZE * 1 - playerY));
    fill(124, 204, 25);
    noStroke();
    rect(0, -GRASS_HEIGHT, width, GRASS_HEIGHT);
    // Soil
    for(int i = 0; i < soilHealth.length; i++){
      for (int j = 0; j < soilHealth[i].length; j++) {
        // Change show on soilHealth value
        int areaIndex = floor(j / 4);
        image(soils[areaIndex][4], i * SOIL_SIZE, j * SOIL_SIZE);
        //soil run pic
        if(soilHealth[i][j] >= 13 && soilHealth[i][j] <= 45) image(soils[areaIndex][4],i * SOIL_SIZE,j * SOIL_SIZE);
        if(soilHealth[i][j] >= 10 && soilHealth[i][j] <= 12) image(soils[areaIndex][3],i * SOIL_SIZE,j * SOIL_SIZE);
        if(soilHealth[i][j] >= 7 && soilHealth[i][j] <= 9) image(soils[areaIndex][2],i * SOIL_SIZE,j * SOIL_SIZE);
        if(soilHealth[i][j] >= 4 && soilHealth[i][j] <= 6) image(soils[areaIndex][1],i * SOIL_SIZE,j * SOIL_SIZE);
        if(soilHealth[i][j] >= 1 && soilHealth[i][j] <= 3) image(soils[areaIndex][0],i * SOIL_SIZE,j * SOIL_SIZE);
        // stone run pic
        if(soilHealth[i][j] == 30) image(stones[0][4],i * SOIL_SIZE,j * SOIL_SIZE);
        if(soilHealth[i][j] == 45){
          image(stones[0][4],i * SOIL_SIZE,j * SOIL_SIZE);
          image(stones[1][4],i * SOIL_SIZE,j * SOIL_SIZE);
        }
        // stone run pic
        if(soilHealth[i][j] >= 28 && soilHealth[i][j] <= 45) image(stones[0][4],i * SOIL_SIZE,j * SOIL_SIZE);
        if(soilHealth[i][j] >= 25 && soilHealth[i][j] <= 27) image(stones[0][3],i * SOIL_SIZE,j * SOIL_SIZE);
        if(soilHealth[i][j] >= 22 && soilHealth[i][j] <= 24) image(stones[0][2],i * SOIL_SIZE,j * SOIL_SIZE);
        if(soilHealth[i][j] >= 19 && soilHealth[i][j] <= 21) image(stones[0][1],i * SOIL_SIZE,j * SOIL_SIZE);
        if(soilHealth[i][j] >= 16 && soilHealth[i][j] <= 18) image(stones[0][0],i * SOIL_SIZE,j * SOIL_SIZE);
        // stone1 animation
        if(soilHealth[i][j] >= 43 && soilHealth[i][j] <= 45) image(stones[1][4],i * SOIL_SIZE,j * SOIL_SIZE);
        if(soilHealth[i][j] >= 40 && soilHealth[i][j] <= 42) image(stones[1][3],i * SOIL_SIZE,j * SOIL_SIZE);
        if(soilHealth[i][j] >= 37 && soilHealth[i][j] <= 39) image(stones[1][2],i * SOIL_SIZE,j * SOIL_SIZE);
        if(soilHealth[i][j] >= 34 && soilHealth[i][j] <= 36) image(stones[1][1],i * SOIL_SIZE,j * SOIL_SIZE);
        if(soilHealth[i][j] >= 31 && soilHealth[i][j] <= 33) image(stones[1][0],i * SOIL_SIZE,j * SOIL_SIZE);
        // health0
        if(soilHealth[i][j] == 0) image(soilEmpty,i * SOIL_SIZE, j * SOIL_SIZE);   
      }
    }

    // Cabbages
    // playerHealth small MAX
    for(int i=0; i<6;i++){
      image(cabbage, cabbageX[i],cabbageY[i]);
      if(playerX<cabbageX[i]+SOIL_SIZE && playerX+SOIL_SIZE>cabbageX[i] &&
         playerY<cabbageY[i]+SOIL_SIZE && playerY+SOIL_SIZE>cabbageY[i]){
           if(playerHealth < PLAYER_MAX_HEALTH){
            cabbageY[i] = 5000;
            playerHealth ++;
           }
         
       }
    }
    

    // Groundhog

    PImage groundhogDisplay = groundhogIdle;

    // If player is not moving, we have to decide what player has to do next
    if(playerMoveTimer == 0){

      // HINT:
      // You can use playerCol and playerRow to get which soil player is currently on

      // Check if "player is NOT at the bottom AND the soil under the player is empty"
      // > If so, then force moving down by setting playerMoveDirection and playerMoveTimer (see downState part below for example)
      // > Else then determine player's action based on input state
      
      if(playerRow<23 && soilHealth[playerCol][playerRow+1]==0){
        playerMoveDirection = DOWN;
        playerMoveTimer = playerMoveDuration;
      }
      else{
      

        if(leftState){
  
          groundhogDisplay = groundhogLeft;
  
          // Check  boundary
          if(playerCol > 0){
            if(playerRow>=0 && soilHealth[playerCol-1][playerRow] > 0){
              if(soilHealth[playerCol-1][playerRow] <= 15) soilChangeTimer = soilChangeDuration;
              if(soilHealth[playerCol-1][playerRow] <= 30 && soilHealth[playerCol-1][playerRow] > 15) soilChangeTimer = stone0ChangeDuration;
              if(soilHealth[playerCol-1][playerRow] <= 45 && soilHealth[playerCol-1][playerRow] > 30) soilChangeTimer = stone1ChangeDuration;
            }
            else{
            playerMoveDirection = LEFT;
            playerMoveTimer = playerMoveDuration;
            }
          }
  
        }else if(rightState){
  
          groundhogDisplay = groundhogRight;
  
          // Check boundary
          if(playerCol < SOIL_COL_COUNT - 1){
  
            //dig move 
           if(playerRow>=0 && soilHealth[playerCol+1][playerRow] > 0){
              if(soilHealth[playerCol+1][playerRow] <= 15) soilChangeTimer = soilChangeDuration;
              if(soilHealth[playerCol+1][playerRow] <= 30 && soilHealth[playerCol+1][playerRow] > 15) soilChangeTimer = stone0ChangeDuration;
              if(soilHealth[playerCol+1][playerRow] <= 45 && soilHealth[playerCol+1][playerRow] > 30) soilChangeTimer = stone1ChangeDuration;
            }
            else{
            playerMoveDirection = RIGHT;
            playerMoveTimer = playerMoveDuration;
            }
          }
  
        }else if(downState){
  
          groundhogDisplay = groundhogDown;
  
          // Check bottom boundary
  
          // HINT:
          // checked bottom
          if(playerRow < SOIL_ROW_COUNT - 1){
  
            // > If so, dig it and decrease its health
             if(soilHealth[playerCol][playerRow+1] > 0){
              if(soilHealth[playerCol][playerRow+1] <= 15) soilChangeTimer = soilChangeDuration;
              if(soilHealth[playerCol][playerRow+1] <= 30 && soilHealth[playerCol][playerRow+1] > 15) soilChangeTimer = stone0ChangeDuration;
              if(soilHealth[playerCol][playerRow+1] <= 45 && soilHealth[playerCol][playerRow+1] > 30) soilChangeTimer = stone1ChangeDuration;
            }
            /*else{
  
            playerMoveDirection = DOWN;
            playerMoveTimer = playerMoveDuration;
  
            }*/
          }
        }
      }
    }

    // If player is now moving?
    // (Separated if-else so player can actually move as soon as an action starts)
    // (I don't think you have to change any of these)

    if(playerMoveTimer > 0){

      playerMoveTimer --;
      switch(playerMoveDirection){

        case LEFT:
        groundhogDisplay = groundhogLeft;
        if(playerMoveTimer == 0){
          playerCol--;
          playerX = SOIL_SIZE * playerCol;
        }else{
          playerX = (float(playerMoveTimer) / playerMoveDuration + playerCol - 1) * SOIL_SIZE;
        }
        break;

        case RIGHT:
        groundhogDisplay = groundhogRight;
        if(playerMoveTimer == 0){
          playerCol++;
          playerX = SOIL_SIZE * playerCol;
        }else{
          playerX = (1f - float(playerMoveTimer) / playerMoveDuration + playerCol) * SOIL_SIZE;
        }
        break;

        case DOWN:
        groundhogDisplay = groundhogDown;
        if(playerMoveTimer == 0){
          playerRow++;
          playerY = SOIL_SIZE * playerRow;
        }else{
          playerY = (1f - float(playerMoveTimer) / playerMoveDuration + playerRow) * SOIL_SIZE;
        }
        break;
      }

    }

    image(groundhogDisplay, playerX, playerY);
    

    if(soilChangeTimer > 0){
      soilChangeTimer -- ; 
      
      if(leftState){
        if(playerCol>=0 && playerRow>=0){
          soilHealth[playerCol-1][playerRow] -- ;
          if(soilHealth[playerCol-1][playerRow] <= 0) soilHealth[playerCol-1][playerRow] = 0 ;
        }
      }
      if(rightState){
        if(playerCol<7 && playerRow>=0){
          soilHealth[playerCol+1][playerRow] -- ;
          if(soilHealth[playerCol+1][playerRow] <= 0) soilHealth[playerCol+1][playerRow] = 0 ;
        }
      }
      if(downState){
        if(playerRow<23){
          soilHealth[playerCol][playerRow+1] -- ;
          if(soilHealth[playerCol][playerRow+1] <= 0) soilHealth[playerCol][playerRow+1] = 0 ;
        }
      }
    }

    // Soldiers
    for(int i=0; i<6;i++){
      image(soldier, soldierX[i],soldierY[i]);
      //soldier run pic
      soldierX[i] += 3;
      if(soldierX[i] >= 640) soldierX[i] = -SOIL_SIZE;
      if(playerX<soldierX[i]+SOIL_SIZE && playerX+SOIL_SIZE>soldierX[i] &&
         playerY<soldierY[i]+SOIL_SIZE && playerY+SOIL_SIZE>soldierY[i]){
            playerHealth -- ;
            playerMoveTimer = 0;
            soilChangeTimer = 0;
            playerX = PLAYER_INIT_X;
            playerY = PLAYER_INIT_Y;
            playerCol = (int) (playerX / SOIL_SIZE);
            playerRow = (int) (playerY / SOIL_SIZE);
            soilHealth[playerCol][playerRow+1] = 15;
            
       }
    }
    // Demo mode: Show the value of soilHealth on each soil
    // (DO NOT CHANGE THE CODE HERE!)

    if(demoMode){  

      fill(255);
      textSize(26);
      textAlign(LEFT, TOP);

      for(int i = 0; i < soilHealth.length; i++){
        for(int j = 0; j < soilHealth[i].length; j++){
          text(soilHealth[i][j], i * SOIL_SIZE, j * SOIL_SIZE);
        }
      }

    }

    popMatrix();

    // Health pic loction
    for(int i=0; i<playerHealth; i++){
      image(life,10+i*70, 10);
      if(playerHealth >= PLAYER_MAX_HEALTH){
        playerHealth = PLAYER_MAX_HEALTH;
      }
    }
    
    if(playerHealth == 0){
      gameState = GAME_OVER;
    }

    break;

    case GAME_OVER: // Gameover Screen
    image(gameover, 0, 0);
    
    if(START_BUTTON_X + START_BUTTON_WIDTH > mouseX
      && START_BUTTON_X < mouseX
      && START_BUTTON_Y + START_BUTTON_HEIGHT > mouseY
      && START_BUTTON_Y < mouseY) {

      image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
      if(mousePressed){
        gameState = GAME_RUN;
        mousePressed = false;

        // player status
        playerX = PLAYER_INIT_X;
        playerY = PLAYER_INIT_Y;
        playerCol = (int) (playerX / SOIL_SIZE);
        playerRow = (int) (playerY / SOIL_SIZE);
        soilChangeTimer = 0;
        playerMoveTimer = 0;
        playerHealth = 2;

        //soilHealth
        soilHealth = new int[SOIL_COL_COUNT][SOIL_ROW_COUNT];
        for(int i = 0; i < soilHealth.length; i++){
          for (int j = 0; j < soilHealth[i].length; j++) {
            // 0: no soil, 15: soil only, 30: 1 stone, 45: 2 stones
            soilHealth[i][j] = 15;
            // section1
            if(i==j)soilHealth[i][j] = 30;
            // section2
            if(j==8 || j==11 || j==12 || j==15){
              if(i==1 || i==2 || i==5 || i==6) soilHealth[i][j] = 30;
            }
            if(j==9 || j==10 || j==13 || j==14){
              if(i==0 || i==3 || i==4 || i==7) soilHealth[i][j] = 30;
            }
            // section3
            if(j==16 || j==19 || j==22){
              if(i==1 || i==4 || i==7) soilHealth[i][j] = 30;
              if(i==2 || i==5) soilHealth[i][j] = 45;
            }
            if(j==17 || j==20 || j==23){
              if(i==0 || i==3 || i==6) soilHealth[i][j] = 30;
              if(i==1 || i==4 || i==7) soilHealth[i][j] = 45;
            }
            if(j==18 || j==21 ){
              if(i==2 || i==5) soilHealth[i][j] = 30;
              if(i==0 || i==3 || i==6) soilHealth[i][j] = 45;
            }
          }
        }
          
        // health 0
        for(int l=1;l<24;l++){
          int count = floor(random(2)+1);
              
          for(int k=0;k<count;k++){
            int col = floor(random(8));
            soilHealth[col][l] = 0;
          }
        }
        
      
        // soidier loction
        soldierX = new float[6];
        soldierY = new float[6];
        
        for(int i=0; i<6; i++){
          float col = random(8);
          int row = floor(random(4))+i*4;
          soldierX[i] = col*SOIL_SIZE;
          soldierY[i] = row*SOIL_SIZE;
        }
      
        //abbages loction
        cabbageX = new float[6];
        cabbageY = new float[6];
        
        for(int i=0;i<6;i++){
          int col = floor(random(8));
          int row = floor(random(4))+i*4;
          cabbageX[i] = col*SOIL_SIZE;
          cabbageY[i] = row*SOIL_SIZE;
        }
      }

    }else{

      image(restartNormal, START_BUTTON_X, START_BUTTON_Y);

    }
    break;
     
  }
}

void keyPressed(){
  if(key==CODED){
    switch(keyCode){
      case LEFT:
      leftState = true;
      break;
      case RIGHT:
      rightState = true;
      break;
      case DOWN:
      downState = true;
      leftState = false;
      rightState = false;
      break;
    }
  }else{
    if(key=='b'){
      // Press B to toggle demo mode
      demoMode = !demoMode;
    }
  }
}

void keyReleased(){
  if(key==CODED){
    switch(keyCode){
      case LEFT:
      leftState = false;
      break;
      case RIGHT:
      rightState = false;
      break;
      case DOWN:
      downState = false;
      break;
    }
  }
}
