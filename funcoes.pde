void resetThings()
{
     //clears background
    background(255);
    //resets arrays
    deltaRitmosMedidos.clear();
    pitchTocados.clear();
    pitchTocados.set(0,(int) width/2);
    //resets average values calculated before response
    sumOfDeltaMedidos=0;
    index=0;
    //resets indexPergunta
    indexPergunta=0;
    diferenca=millis();
}

void keyPressed()
{
  //mood Mozart
  if (key == '1')
  {
    situacao='1';
  }
  //mood Harry Partch
  else if (key=='2')
  {
    situacao='2';
  }
  //mood Emanuel Nunes 
  else if (key=='3')
  {
    situacao='3';
  }
  //mood Morton Feldmann
  else if (key=='4')
  {
    situacao='4';
  }
  //mood Schonberg
  else if (key=='5')
  {
    situacao='5';
  }
}

void mousePressed() 
{
  clik=true;
}

void mouseReleased() 
{
  primeiroToque=false;
}

float checkPitchMouse(int ratoX)
{  
  if (ratoX<=fronteiraPitch[fronteiraPitch.length-1])
  {
    for (int i=0; i<fronteiraPitch.length; i++)
    {
      if (ratoX>fronteiraPitch[i] && ratoX< fronteiraPitch[i+1])
      {
        speedPitchPlay = speedPitch[i];
      }
    }
  }
  else
  {
    speedPitchPlay= 2.0;
  }
  return speedPitchPlay;
}