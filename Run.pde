import java.util.*;
public static final int UP = 0;
public static final int DOWN = 1;
public static final int RIGHT = 2;
public static final int LEFT = 3;

public class Runner
{
  int lastEaten;
  double distanceToGoal;
  int direction;
  int leng;
  float fitness;
  int id;
  int x, y;
  Vector <PVector> snakeCoords;
  Vector <PVector> obstacles;
  PVector goal;
  Brain brain;
  boolean alive;
  boolean [][] ownBoard;
  int boardHeight;
  int boardWidth;
  public Runner( int xx, int yy, int ident)
  {
    boardWidth = xx * 2;
    boardHeight = yy * 2;
    lastEaten = 0;
    snakeCoords = new Vector<PVector>();
    obstacles = new Vector<PVector>();
    goal = new PVector();
    leng = 1;
    fitness = 0;
    alive = true;
    ownBoard = new boolean[boardWidth][boardHeight];
    distanceToGoal = 400;
    brain = new Brain();
    direction = 3;
    id = ident;
    x = xx;
    y = yy;;
    for( int i = 0; i < leng; ++i)
    {
      snakeCoords.add( new PVector(x-i, y) );
    }
    for ( int i = 0; i < 10 && obstaclesOn; ++i )
    {
      obstacles.add( new PVector(getRandom(100), getRandom(100)));
      ownBoard[(int)obstacles.elementAt(i).x][(int)obstacles.elementAt(i).y] = false;
    }
    setBoard();
    makeGoal();
  }
  private boolean inBounds()
  {
    return x >= 0 && x < boardWidth && y >= 0 && y < boardHeight;
  }
  private boolean inBounds(int inX, int inY)
  {
    return inX >= 0 && inX < boardWidth && inY >= 0 && inY < boardHeight;
  }

  void setBoard()
  {
    for ( int i = 0; i < ownBoard.length; ++i )
    {
      for ( int j = 0; j < ownBoard[i].length; ++j )
      {
        ownBoard[i][j] = true;
      }
    }
    for ( int i = 0; i < leng - 1; ++i )
    {
      ownBoard[(int)snakeCoords.elementAt(i).x][(int)snakeCoords.elementAt(i).y] = false;
    }
    for ( int i = 0; i < obstacles.size(); ++i )
    {
      ownBoard[(int)obstacles.elementAt(i).x][(int)obstacles.elementAt(i).y] = false;
    }
  }
  public void update()
  {
    ++lastEaten;
    setBoard();
    if ( alive == true )
    {
      calcDir();
      if( !inBounds() || !ownBoard[x][y] || lastEaten > 300)
      {
        alive = false;
        distanceToGoal = Math.hypot( goal.x - x, goal.y - y);
      }
      else{
        snakeCoords.remove( 0 );
        snakeCoords.add( new PVector(x, y) );
        //ownBoard[x][y] = false;
      }
      if ( goal.x == x && goal.y == y )
      {
        lastEaten = 0;
        makeGoal();
        ++leng;
        snakeCoords.add( new PVector(x, y) );
      }
    }
  }
  private void makeGoal()
  {
    goal.x = getRandom(100);
    goal.y = getRandom(100);
    while ( !ownBoard[(int)goal.x][(int)goal.y])
    {
      goal.x = getRandom(100);
      goal.y = getRandom(100);
    }
  }
  public void show(int currentMax)
  {
    if ( alive == true )
    {
      if ( !bestShow )
      {
        fill(150, 150, 255);
        rect( goal.x * 8, goal.y *8, 8, 8);
        
        fill(leng + 100, 50, leng*4);
        if ( leng == currentMax)
        {
          fill(255, 255, 50);
        }
        for ( int i = 0; i < leng; ++i )
        {
          rect( snakeCoords.elementAt(i).x*8, snakeCoords.elementAt(i).y*8, 8, 8);
        }
      }
      else
      {
        if ( id == 0 )
        {
          fill(150, 150, 255);
          rect( goal.x * 8, goal.y * 8, 8, 8);
          for ( int i = 0; i < leng; ++i )
          {
            fill(leng + 100, 50, leng*4);
            rect( snakeCoords.elementAt(i).x*8, snakeCoords.elementAt(i).y*8, 8, 8);
          }
          for ( int i = 0; i < obstacles.size(); ++i )
          {
            fill(200, 255, 0);
            rect( obstacles.elementAt(i).x*8, obstacles.elementAt(i).y*8, 8, 8);
          }

        }
      }
    }
  }
  public void goStraight()
  {
    switch(direction)
    {
      case UP:
        --y;
        break;
      case DOWN:
        ++y;
        break;
      case RIGHT:
        ++x;
        break;
      case LEFT:
        --x;
        break;
    }
  }
  public void turnLeft()
  {
    switch(direction)
    {
      case UP:
        direction = LEFT;
        --x;
        break;
      case DOWN:
        direction = RIGHT;
        ++x;
        break;
      case RIGHT:
        direction = UP;
        --y;
        break;
      case LEFT:
        direction = DOWN;
        ++y;
        break;
    }
  }
  public void turnRight()
  {
    switch(direction)
    {
      case UP:
        direction = RIGHT;
        ++x;
        break;
      case DOWN:
        direction = LEFT;
        --x;
        break;
      case RIGHT:
        ++y;
        direction = DOWN;
        break;
      case LEFT:
        --y;
        direction = UP;
        break;
    }
  }
  public void stayingAlive()
  {
    switch(direction)
    {
      case UP:
        brain.facts[0] = inBounds(x, y-1) && ownBoard[x][y-1];
        brain.facts[1] = inBounds(x-1, y) && ownBoard[x-1][y];
        brain.facts[2] = inBounds(x+1, y) && ownBoard[x+1][y];
        break;
      case DOWN:
        brain.facts[0] = inBounds(x, y+1) && ownBoard[x][y+1];
        brain.facts[1] = inBounds(x+1, y) && ownBoard[x+1][y];
        brain.facts[2] = inBounds(x-1, y) && ownBoard[x-1][y];
        break;
      case RIGHT:
        brain.facts[0] = inBounds(x+1, y) && ownBoard[x+1][y];
        brain.facts[1] = inBounds(x, y-1) && ownBoard[x][y-1];
        brain.facts[2] = inBounds(x, y+1) && ownBoard[x][y+1];
        break;
      case LEFT:
        brain.facts[0] = inBounds(x-1, y) && ownBoard[x-1][y];
        brain.facts[1] = inBounds(x, y+1) && ownBoard[x][y+1];
        brain.facts[2] = inBounds(x, y-1) && ownBoard[x][y-1];
        break;
    }
  }
  public void findFood()
  {
    switch(direction)
    {
      case UP:
        brain.facts[3] = goal.y < y && goal.x == x;
        brain.facts[4] = goal.x < x;
        brain.facts[5] = goal.x > x;
        break;
      case DOWN:
        brain.facts[3] = goal.y > y && goal.x == x;
        brain.facts[4] = goal.x > x;
        brain.facts[5] = goal.x < x;
        break;
      case RIGHT:
        brain.facts[3] = goal.x > x && goal.y == y;
        brain.facts[4] = goal.y < y;
        brain.facts[5] = goal.y > y;
        break;
      case LEFT:
        brain.facts[3] = goal.x < x && goal.y == y;
        brain.facts[4] = goal.y > y;
        brain.facts[5] = goal.y < y;
        break;
    }
  }
  public void calcDir()
  {
    stayingAlive();
    findFood();
    int dir = brain.getDirection();
    switch(dir)
    {
      case 0:
        goStraight();
        break;
      case 1:
        turnLeft();
        break;
      case 2:
        turnRight();
        break;
    }
  }
  void calculateFitness(){
    fitness = 1 + (float)(5/(distanceToGoal+1)) + (float)Math.pow(leng - 1, 1.5) * 20;
  }
  int getRandom(int num)
  {
    Random r = new Random();
    return r.nextInt(num);
  }
}
