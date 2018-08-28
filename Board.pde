import java.util.*;
public class Board
{
  int fitnessSum;
  int gen;
  int [][] arr;
  Runner [] runners;
  Runner bestRunner;
  int bestFit;
  int width, height;
  public Board( int w, int h, int players )
  {
    bestFit = 0;
    fitnessSum = 0;
    gen = 1;
    width = w;
    height = h;
    bestRunner = new Runner( width/2, height/2, 0 );
    arr = new int[w][h];
    runners = new Runner[players];
    for ( int i = 0; i < players; ++i )
    {
      runners[i] = new Runner(width/2, height/2, i );
    }
  }
  public void update()
  {
    for ( int i = 0; i < runners.length; ++i )
    {
      runners[i].update();
      bestFit = runners[i].leng > bestFit ? runners[i].leng : bestFit;
    }
  }
  public void show()
  {
    for( int i = 0; i < runners.length; ++i )
    {
      runners[i].show(); 
    }
  }
  public boolean someAlive()
  {
    for ( int i = 0; i < runners.length; ++i )
    {
      if ( runners[i].alive == true )
      {
         return true;
      }
    }
    return false;
  }
  void naturalSelection()
  {
    Runner[] newRunners = new Runner[runners.length];
    calculateFitnessSum();
    newRunners[0] = new Runner( width/2, height/2, 0 );
    newRunners[0].brain.weights = bestRunner.brain.weights;
    newRunners[0].brain.weightsTwo = bestRunner.brain.weightsTwo;
    for ( int i = 1; i < newRunners.length; ++i )
    {
      Runner mom = selectParent();
      Runner dad = selectParent();
      Runner dom = mom.fitness > dad.fitness ? mom : dad;
      Runner help = dad.fitness < mom.fitness ? dad : mom;
      newRunners[i] = new Runner( width/2, height/2, i );
      for( int j = 0; j < mom.brain.weights.length; ++j )
      {
        Random crossOver = new Random();
        newRunners[i].brain.weights[j] = crossOver.nextInt(7) == 0 ? dom.brain.weights[j] : help.brain.weights[j];
      }
      for( int j = 0; j < mom.brain.weightsTwo.length; ++j )
      {
        Random crossOver = new Random();
        newRunners[i].brain.weightsTwo[j] = crossOver.nextInt(7) == 0 ? dom.brain.weightsTwo[j] : help.brain.weightsTwo[j];
      }
    }
    runners = newRunners.clone();
    ++gen;
  }
  void calculateFitnessSum(){
    fitnessSum = 0;
    for( int i = 0; i < runners.length; ++i ){
      runners[i].calculateFitness();
      fitnessSum += runners[i].fitness;
      bestRunner = runners[i].fitness > bestRunner.fitness ? runners[i]: bestRunner; 
    }
    System.out.println(fitnessSum);
  }
  Runner selectParent(){
    float rand = random(fitnessSum);
    int runningSum = 0;
    for( int i = 0; i < runners.length; ++i ){
      runningSum += runners[i].fitness;
      if (runningSum > rand ){
        return runners[i];
      } 
    }
    return null;
  }
  void mutateBabies(){
    for ( int i = 1; i < runners.length; ++i)
    {
      runners[i].brain.mutate();
    }
  }


  
}
