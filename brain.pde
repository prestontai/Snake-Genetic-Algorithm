class Brain{
  boolean[] facts;
  float[] weights;
  float[] middle;
  int step = 0;
  
  Brain(){
    facts = new boolean[6];
    middle = new float[3];
    weights = new float[facts.length * middle.length];
    for ( int i = 0; i < weights.length; ++i )
    {
      float rand = random(1);
      weights[i] = rand;
    }
  }
  int pureMagic()
  {
    for ( int i = 0; i < middle.length; ++i )
    {
      middle[i] = 0;
    }
    PVector biggest = new PVector(-1, -1);
    for ( int i = 0; i < middle.length; ++i )
    {
      for ( int j = 0; j < facts.length; ++j )
      {
        float truthVal = facts[j] ? 1.0 : 0.0;
        middle[i] += truthVal * weights[i * middle.length + j];
      }
      float sigmoid = (float)(1 / (1 + Math.exp(-middle[i])));
      if ( sigmoid > biggest.x )
      {
        biggest.x = sigmoid;
        biggest.y = i;
      }
    }
    return (int)biggest.y;
  }
  int getDirection()
  {
    return pureMagic();
  }
 
  void mutate(){
    for ( int i = 0; i < weights.length; ++i ){
      float rand = random(1);
      if ( rand < 0.03 ){
        weights[i] = rand;
      }
    }
  }
}
