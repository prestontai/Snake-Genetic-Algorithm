Board game;
boolean bestShow;

void settings()
{
  size(800,800);
}

void setup(){
  frameRate(150);
  background(0, 0, 50 );
  game = new Board(100, 100, 200);
  bestShow = false;
  textSize(20);
  text( "Generation: " + int(game.gen), width - 180, height - 40 );
  text( "Fittest: " + int( game.bestFit ), width - 160, height - 10);
}

void draw(){
    
    if( game.someAlive())
    {
      background(0,0,50 );
      textSize(20);
      text( "Generation: " + int(game.gen), width - 180, height - 40 );
      text( "Fittest: " + int( game.bestFit ), width - 160, height - 10);
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
        case 68:    //d
           ++game.runners[i].x;
           break;
        case 65:    //a
           --game.runners[i].x;
           break;
        case 83:    //s
           ++game.runners[i].y;
           break;
        case 87:    //w
           --game.runners[i].y;
           break;
        case 38:    //up
           frameRate(150);
           break;
        case 40:    //down
           frameRate(40);
           break;
        case 70:
           bestShow = !bestShow;
           break;
     }
  }
}
