import processing.sound.*;
SoundFile [] soundfile = new SoundFile [20];

float tempoResposta, diferenca, deltaRitmo, deltaResposta;
FloatList deltaRitmosMedidos;
boolean clik=false;
boolean tocaResposta=false;
boolean ritmoTocado=false;
boolean primeiroToque=true;
boolean tocouPrimeiraReposta=false;
int totalEventos;
int index=0;
int indexPergunta=0;
char situacao='1';
float sumOfDeltaMedidos=0;
float delayToResponse=2000;

int divisaoOitava=12;
int [] fronteiraPitch = new int [divisaoOitava*2];
float [] speedPitch = new float [divisaoOitava*2];
float speedPitchPlay=1;
IntList pitchTocados;

void setup()
{
  size(800,600);
  background(255);
  frameRate(60);
  
  //list to append time lapses
  deltaRitmosMedidos = new FloatList();
  pitchTocados = new IntList();
  
  for (int i=0; i<soundfile.length; i++)
  {
    //load sample
    soundfile [i] = new SoundFile(this, "sampleMono.aiff");
  }
  
  int divisaoDisplayOitava= (int) width/(divisaoOitava*2);
  
  //equal divisions of the width of screen
  for (int i=0; i<fronteiraPitch.length; i++)
  { 
    fronteiraPitch[i]= i * divisaoDisplayOitava;
  }
  //Equal temperament (pitch)
  for (int j=0; j<speedPitch.length; j++)
  {
    speedPitch[j]= pow(2,((float)(j-divisaoOitava)/divisaoOitava));
  }
}


void draw()
{
  inputRitmo();
  respondeRitmo();
}
      
void inputRitmo ()
{
  if(clik)
  {
    //first played note
    if (primeiroToque)
    {
      resetThings();
      //draws first ellipse
      //if not Schonberg mode
      if (situacao!='5')
      {
        fill(0,255,255);
        ellipse(width*0.5,mouseY, 100, 100);
        //plays first sound
        soundfile[0].play();
        soundfile[0].pan(0);
        soundfile[0].amp(0.5);
        soundfile[0].rate(1);
      }
      //if schonberg mode
      else if (situacao=='5')
      {
        fill(0,255,255);
        ellipse(mouseX,mouseY, 100, 100);
        //plays first sound
        soundfile[0].play();
        soundfile[0].pan(0);
        soundfile[0].amp(0.5);
        float pitch=checkPitchMouse(mouseX);
        soundfile[0].rate(pitch);
        pitchTocados.append((int)mouseX);
      }
    }
    
    //after first note played
    if(!primeiroToque)
    {
      //measuring time lapse
      deltaRitmo = millis()-diferenca;
      //drawing ellipses
      fill(255,255,0);
      ellipse(mouseX,random(height-50), 50, 50);
      //playing samples in sequence (not to overlap)
      indexPergunta=indexPergunta+1;
      soundfile[indexPergunta].play();
      soundfile[indexPergunta].pan(map(mouseX,0,width,-0.7,0.7));
      soundfile[indexPergunta].amp(0.5);
      
      //pitch decidor
      switch(situacao)
      {
        //MOZART
        case '1':
          //quantised, two octaves
          float pitch=checkPitchMouse(mouseX);
          soundfile[indexPergunta].rate(pitch);
          break;
        //PARTCH
        case '2':
          //pitch based on mouseX, two octaves
          pitch=map(mouseX,0, width, 0.5, 1.5);
          soundfile[indexPergunta].rate(pitch);
          break;
        //NUNES 
        case '3':
          //quantised, two octaves
          pitch=checkPitchMouse(mouseX);
          soundfile[indexPergunta].rate(pitch);
          break;
        //FELDMANN  
        case '4':
          //quantised, two octaves
          pitch=map(mouseX,0, width, 0.5, 1.5);
          soundfile[indexPergunta].rate(pitch);
          break;
        //SCHONBERG  
        case '5':
          //quantised, two octaves
          pitch=checkPitchMouse(mouseX);
          soundfile[indexPergunta].rate(pitch);
          pitchTocados.append((int)mouseX);
          break;        
        default:
          soundfile[indexPergunta].rate(0.5);
      }
      
      //fill array with time lapse
      deltaRitmosMedidos.append(deltaRitmo);
      //resets measurement for time lapse
      diferenca=millis();
      deltaRitmo=0;
      ritmoTocado=true;
      totalEventos=deltaRitmosMedidos.size();
      //compute average values
      sumOfDeltaMedidos= sumOfDeltaMedidos+deltaRitmosMedidos.get(indexPergunta-1);
      delayToResponse=sumOfDeltaMedidos/totalEventos;
      //decides the delay for answer. Always more than 1 sec.
      if (delayToResponse<1000)
      {
        delayToResponse=delayToResponse*2;
      }
      if (delayToResponse>2000)
      {
        delayToResponse = delayToResponse*0.5;
      }
    }
      clik=false;
  }
}

void respondeRitmo()
{
  //waits 2 seconds to reply
  deltaResposta = millis()-diferenca;
  
  if (deltaResposta>delayToResponse)
  {
    //if array of time lapses is bigger than 1
    if (deltaRitmosMedidos.size()>=1)
    {       
      //after the first time is played. Choose on time lapse in the array and adds it to the current time
      if (ritmoTocado && tocouPrimeiraReposta && index<deltaRitmosMedidos.size())
      {
        //gets time lapses in sequence
        tempoResposta= millis() + deltaRitmosMedidos.get(index);
        ritmoTocado=false;
      }
      
      //if the current time is higher than the time lapse measured above then play
      if (millis()>tempoResposta && tocouPrimeiraReposta && index<deltaRitmosMedidos.size())
      {
        //draws ellipses
        fill(255,0,255);
        switch(situacao)
        {
          //pitch of response always medium and high notes
          case '1':
            int posRespostaX= (int)random(width*0.4,width);
            ellipse(posRespostaX,random(50,600), 50, 50);
            //plays sounds
            soundfile[index+1].play();
            float pitch=checkPitchMouse(posRespostaX);
            soundfile[index+1].amp(0.5);
            soundfile[index+1].pan(map(posRespostaX,0,width,-0.7,0.7));
            soundfile[index+1].rate(pitch);
            break;
          //pitch of response random
          case '2':
            //pitch of response random notes
            posRespostaX= (int)random(0,width);
            ellipse(posRespostaX,random(50,600), 50, 50);
            //plays sounds
            soundfile[index+1].play();
            pitch=map(posRespostaX,0, width, 0.5, 1.5);
            soundfile[index+1].amp(0.5);
            soundfile[index+1].pan(map(posRespostaX,0,width,-0.7,0.7));
            soundfile[index+1].rate(pitch);
            break;
          //pitch of response random
          case '3':
            //pitch of response always medium and high notes
            posRespostaX= (int)random(0,width);
            ellipse(posRespostaX,random(50,600), 50, 50);
            //plays sounds
            soundfile[index+1].play();
            pitch=checkPitchMouse(posRespostaX);
            soundfile[index+1].amp(0.5);
            soundfile[index+1].pan(map(posRespostaX,0,width,-0.7,0.7));
            soundfile[index+1].rate(pitch);
            break;
          //pitch of response random
          case '4':
            //pitch of response random notes
            posRespostaX= (int)random(0,width);
            ellipse(posRespostaX,random(50,600), 50, 50);
            //plays sounds
            soundfile[index+1].play();
            pitch=map(posRespostaX,0, width, 0.5, 1.5);
            soundfile[index+1].amp(0.5);
            soundfile[index+1].pan(map(posRespostaX,0,width,-0.7,0.7));
            soundfile[index+1].rate(pitch);
            break;
          //pitch of response retrograde
          case '5':
            //pitch of response random notes
              posRespostaX= pitchTocados.get(index);
              ellipse(posRespostaX,random(50,600), 50, 50);
              //plays sounds
              soundfile[index+1].play();
              pitch=checkPitchMouse(posRespostaX);
              soundfile[index+1].amp(0.5);
              soundfile[index+1].pan(map(posRespostaX,0,width,-0.7,0.7));
              soundfile[index+1].rate(pitch);
            break;           
          default:
            //pitch of response always medium and high notes
            posRespostaX= (int)random(width*0.4,width);
            ellipse(posRespostaX,random(50,600), 50, 50);
            //plays sounds
            soundfile[index+1].play();
            pitch=checkPitchMouse(posRespostaX);
            soundfile[index+1].amp(0.5);
            soundfile[index+1].pan(map(posRespostaX,0,width,-0.7,0.7));
            soundfile[index+1].rate(pitch);
            break;
        }
        //signals the rhythm is played
        ritmoTocado=true;
        //allows the first note to be played again 
        primeiroToque=true;
        index= index+1;
      }
      
      //FIRST RESPONSE
      //compares the total of events of the played array in order to play this note/ellipse only the first time
      if (deltaRitmosMedidos.size()==totalEventos)
      {
        //everything but Schonberg case
        if (situacao!='5')
        {
          fill(0,255,255);
          ellipse((width*0.5)*0.5,mouseY, 100, 100);
          soundfile[0].play();
          soundfile[0].amp(0.5);
          soundfile[0].pan(0);
          soundfile[0].rate(0.75);
        }
  
        switch(situacao)
        {
          case '1':
            //reverse array of time lapses
            deltaRitmosMedidos.reverse();
            break;
          case '2':
            //shuffles array of time lapses
            deltaRitmosMedidos.shuffle();
            break;
          case '3':
            //shuffles array of time lapses
            for (int i=0; i<deltaRitmosMedidos.size(); i++)
              {
                deltaRitmosMedidos.mult(i,0.5);
              }
            break;
          case '4':
            //shuffles array of time lapses
            for (int i=0; i<deltaRitmosMedidos.size(); i++)
              {
                deltaRitmosMedidos.mult(i,2.0);
              }
              //allows the first note to be played again 
              primeiroToque=true;
            break;
          case '5':
            //retrograde
              pitchTocados.reverse();
              //allows the first note to be played again 
              primeiroToque=true;
            break;
          default:
          //shuffles array of time lapses
            deltaRitmosMedidos.reverse();
            break;
        }
        //makes sure this part only runs once
        totalEventos=totalEventos+1;
        tocouPrimeiraReposta=true;
        ritmoTocado=true;
        }
    }
  }
}