Board game;
boolean obstaclesOn;
boolean bestShow;

void settings()
{
  size(800,800);
}

void setup(){
  frameRate(150);
  background(0, 0, 50 );
  game = new Board(100, 100, 150);
  bestShow = false;
  obstaclesOn = false;
}

void draw(){
    if( game.someAlive())
    {
      background(0,0,50 );
      fill(0, 255, 255);
      textSize(20);
      text( "Generation: " + int(game.gen), width - 180, height - 40 );
      text( "Fittest: " + int( game.bestFit ), width - 160, height - 10);
      text( "Current Max: " + int( game.currentMax ), width - 340, height - 10);
      game.update();
      game.show();
    }
    else
    {
      game.naturalSelection();
      game.mutateBabies();
    }
    
    
}

void mouseClicked()
{
   bestShow = !bestShow;
   //game.naturalSelection();
   //game.mutateBabies();
}
public void keyPressed()
{
  for ( int i = 0; i < game.runners.length; ++i)
  {
     switch( keyCode )
     {
        //case 68:    //d
        //   game.runners[1].direction = RIGHT;
        //   break;
        //case 65:    //a
        //   game.runners[1].direction = LEFT;
        //   break;
        //case 83:    //s
        //   game.runners[1].direction = DOWN;
        //   break;
        //case 87:    //w
        //   game.runners[1].direction = UP;
        //   break;
        case 38:    //up
           frameRate(150);
           break;
        case 40:    //down
           frameRate(20);
           break;
     }
  }
}
