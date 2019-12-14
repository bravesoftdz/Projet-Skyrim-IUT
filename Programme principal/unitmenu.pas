unit UnitMenu;

interface
uses UnitPersonnage, GestionEcran, unitLieu, TypInfo, Keyboard, Classes, SysUtils;

//Procédure qui affiche le menu initial
procedure menuInitial();
//Procédure pour lancer le jeu
procedure LaunchGame();
//Procédure pour quitter le jeu
procedure QuitGame();
//Procédure pour afficher l'interface du jeu
procedure InterfaceInGame(position : TInformation);
//Procédure qui permet d'afficher un menu à partir d'une liste de texte (par exemple pour le menu initial)
procedure afficherListeMenu(ListeTexte : array of String; coordMenuInitial : coordonnees; distanceEntreTexte : Integer);

function selectionMenu(coordMin : coordonnees; nbText : Integer; distanceEntreTexte, couleurFondTexte, couleurTexte : Integer) : Integer;

procedure ecrireTexte(posCoord : coordonnees; textToWrite : String; largeur : Integer);

procedure writelnPerso();
procedure writelnPerso(ligneAEcrire : String);

procedure readlnPerso();
procedure readlnPerso(var ligneAEnregistrer : String);
procedure readlnPerso(var ligneAEnregistrer : Integer);

function Key() : TKeyEvent;
procedure redo();

implementation

//Procédure qui affiche le menu initial
procedure menuInitial();
var
  rep : Integer;
  coorT : coordonnees;
  coorTTest : coordonnees;
  coorT3 : coordonnees;
  volonte : Integer;
  lancement : Boolean;
  touche : TKeyEvent;
  ListeMenuInitial : array of String;
  choiceMenu : Integer;
  asciiText : String;

 // personnageCree : personnageStat;

begin
  coorT.x := 96;      //Coor Texte
  coorT.y := 30 - 5;

  coorTTest.x := 38;
  coorTTest.y := 20;

  redo();
  couleurTexte(White);

  asciiText :=             '      #######      /                            ##### ##                                                              ';
  asciiText := asciiText + '    /       ###  #/                          ######  /###                          #                                  ';
  asciiText := asciiText + '   /         ##  ##                         /#   /  /  ###                        ###                           #     ';
  asciiText := asciiText + '   ##        #   ##                        /    /  /    ###                        #                           ##     ';
  asciiText := asciiText + '    ###          ##                            /  /      ##                                                    ##     ';
  asciiText := asciiText + '   ## ###        ##  /##  ##   ####           ## ##      ## ###  /###     /###   ###      /##       /###     ######## ';
  asciiText := asciiText + '    ### ###      ## / ###  ##    ###  /       ## ##      ##  ###/ #### / / ###  / ###    / ###     / ###  / ########  ';
  asciiText := asciiText + '      ### ###    ##/   /   ##     ###/      /### ##      /    ##   ###/ /   ###/   ##   /   ###   /   ###/     ##     ';
  asciiText := asciiText + '        ### /##  ##   /    ##      ##      / ### ##     /     ##       ##    ##    /   ##    ### ##            ##     ';
  asciiText := asciiText + '          #/ /## ##  /     ##      ##         ## ######/      ##       ##    ##   /    ########  ##            ##     ';
  asciiText := asciiText + '           #/ ## ## ##     ##      ##         ## ######       ##       ##    ##  ###   #######   ##            ##     ';
  asciiText := asciiText + '            # /  ######    ##      ##         ## ##           ##       ##    ##   ###  ##        ##            ##     ';
  asciiText := asciiText + '  /##        /   ##  ###   ##      ##         ## ##           ##       ##    ##    ### ####    / ###     /     ##     ';
  asciiText := asciiText + ' /  ########/    ##   ### / #########         ## ##           ###       ######      ### ######/   ######/      ##     ';
  asciiText := asciiText + '/     #####       ##   ##/    #### ###   ##   ## ##            ###       ####        ##  #####     #####        ##    ';
  asciiText := asciiText + '|                                   ### ###   #  /                                   ##                               ';
  asciiText := asciiText + ' \)                          #####   ### ###    /                                    /                                ';
  asciiText := asciiText + '                           /#######  /#   #####/                                    /                                 ';
  asciiText := asciiText + '                          /      ###/       ###                                    /                                  ';
  ecrireTexte(coorTTest, asciiText, 118);
  readln;
  redo();

  setLength(ListeMenuInitial, 2);
  ListeMenuInitial[0] := 'Jouer ?';
  ListeMenuInitial[1] := 'Quitter ?';
  afficherListeMenu(ListeMenuInitial, coorT, 5);
  choiceMenu := selectionMenu(coorT, 2, 5, LightBlue, White);

  if choiceMenu = 0 then
    LaunchGame()
  else
    QuitGame();

  readln;
end;


//Procédure pour quitter le jeu
procedure LaunchGame();
begin
  redo();
  createCharacter();
end;

//Procédure pour quitter le jeu
procedure QuitGame();
var
  rep : Char;
begin
  repeat
  effacerEcran();
  write('Etes vous sur de vouloir quitter ? [o/n] : ');
  readln(rep);
  if rep ='o' then
     writeln('Au plaisir de vous revoir')
  else if rep<>'n' then
      begin
      writeln('Veuillez saisir une réponse valide');
      attendre(1000);
      end;
  until (rep = 'o') OR (rep = 'n');
  effacerEcran();
  Halt(1);
end;

procedure InterfaceInGame(position : TInformation);
var
  posInterface, //Position du contenu de l'interface
  posCadre1, //Position du coin haut gauche
  posCadre2 : coordonnees; //Position du coin bas droit
  i : Integer; //Variable de boucle
  textTemp : String; //Variable qui affiche chaque ligne de l'inventaire
begin
  redo();
  posInterface.x := 5;
  posInterface.y := 4;
  posCadre1.x := 3;

  textTemp := 'Pseudo : ' + persoChoose.pseudo;
  ecrireEnPosition(posInterface, textTemp);
  posInterface.y := posInterface.y+1;

  textTemp := 'Race : ' + GetEnumName(TypeInfo(race), Ord(persoChoose.race));
  ecrireEnPosition(posInterface, textTemp);
  posInterface.y := posInterface.y+1;

  textTemp := 'PV : ' + IntToStr(persoChoose.pv) + ' / ' + IntToStr(persoChoose.pvMax);
  ecrireEnPosition(posInterface, textTemp);
  posInterface.y := posInterface.y+1;

  textTemp := 'Bourse : ' + IntToStr(persoChoose.argent) + ' Gold';
  ecrireEnPosition(posInterface, textTemp);
  posInterface.y := posInterface.y+1;

  textTemp := 'Vous vous-situez à ' + position.nom;
  ecrireEnPosition(posInterface, textTemp);
  posInterface.y := posInterface.y+1;

  posCadre1.y := posInterface.y+2;
  couleurTexte(Red);
  deplacerCurseur(posCadre1);
  for i := posCadre1.x-1 to 195 do //On dessine la ligne du bas
    write(#205);
  couleurTexte(White);
  posCadre1.y := posCadre1.y+1;
  deplacerCurseur(posCadre1);
end;

function Key() : TKeyEvent;
var
  K:TKeyEvent;
begin
InitKeyBoard;
  Repeat
    K:=GetKeyEvent;
    K:=TranslateKeyEvent(K);
  until (GetKeyEventChar(K)<>'');
  Key :=K;
DoneKeyBoard;
end;

procedure redo();
var
  coorC,
  coorC2 : coordonnees;
  largeur,
  hauteur : Integer;
begin
  largeur := 200;
  hauteur := 60;
  coorC.x := 2;      //Coor 1
  coorC.y := 1;
  coorC2.x := largeur-3;     //Coor 2
  coorC2.y := hauteur-2;

  effacerEcran();
  changerTailleConsole(largeur,hauteur);
  dessinerCadre(coorC,coorC2,double,4,0);
  couleurTexte(White);
end;

//Procédure qui permet d'afficher un menu à partir d'une liste de texte (par exemple pour le menu initial)
procedure afficherListeMenu(ListeTexte : array of String; coordMenuInitial : coordonnees; distanceEntreTexte : Integer);
var
  i : Integer;
  coordTemp : coordonnees;
begin
  coordTemp.x := coordMenuInitial.x;
  coordTemp.y := coordMenuInitial.y;
  for i:=low(ListeTexte) to high(ListeTexte) do
      begin
      ecrireTexte(coordTemp, ListeTexte[i], 120);
      coordTemp.x := coordTemp.x;
      coordTemp.y := coordTemp.y + distanceEntreTexte;
      end;
end;

function selectionMenu(coordMin : coordonnees; nbText, distanceEntreTexte: Integer; couleurFondTexte, couleurTexte : Integer) : Integer;
var
  coordTemp,
  coordMax : coordonnees;
  selectedChoice : Integer;
  Touche : TKeyEvent;
begin
  deplacerCurseur(CoordMin);
  coordTemp.x := coordMin.x;
  coordTemp.y := coordMin.y;
  ColorierZone(couleurFondTexte, couleurTexte, coordTemp.x, coordTemp.x+10, coordTemp.y);
  coordMax.y := coordMin.y + (nbText-1)*distanceEntreTexte;
  coordMax.x := coordMin.x;
  repeat
    Touche := Key();
    if (KeyEventToString(Touche)='Up') then
       if coordTemp.y = coordMin.y then
          begin
          ColorierZone(0, 15, coordTemp.x, coordTemp.x+10, coordTemp.y);
          coordTemp := coordMax;
          deplacerCurseur(coordTemp);
          ColorierZone(couleurFondTexte, couleurTexte, coordTemp.x, coordTemp.x+10, coordTemp.y);
          end
       else
          begin
          ColorierZone(0, 15, coordTemp.x, coordTemp.x+10, coordTemp.y);
          coordTemp.y := coordTemp.y-distanceEntreTexte;
          deplacerCurseur(coordTemp);
          ColorierZone(couleurFondTexte, couleurTexte, coordTemp.x, coordTemp.x+10, coordTemp.y);
          end
    else if (KeyEventToString(Touche)='Down') then
       if coordTemp.y = coordMax.y then
          begin
          ColorierZone(0, 15, coordTemp.x, coordTemp.x+10, coordTemp.y);
          coordTemp := coordMin;
          deplacerCurseur(coordTemp);
          ColorierZone(couleurFondTexte, couleurTexte, coordTemp.x, coordTemp.x+10, coordTemp.y);
          end
       else
          begin
          ColorierZone(0, 15, coordTemp.x, coordTemp.x+10, coordTemp.y);
          coordTemp.y := coordTemp.y+distanceEntreTexte;
          deplacerCurseur(coordTemp);
          ColorierZone(couleurFondTexte, couleurTexte, coordTemp.x, coordTemp.x+10, coordTemp.y);
          end;

  until (KeyEventToString(Touche)=chr(13));
  selectedChoice := (coordTemp.y - CoordMin.y) div distanceEntreTexte;
  selectionMenu:=selectedChoice;
end;

//Procédure pour écrire un texte sur une largeur donnée (justifié)
procedure ecrireTexte(posCoord : coordonnees; textToWrite : String; largeur : Integer);
var
  tempText : String;
  tempPosCoord : coordonnees;
begin
  tempPosCoord.y := posCoord.y - 1;
  tempPosCoord.x := posCoord.x;
  tempText := textToWrite;
  while length(tempText) > largeur do
    begin
    tempPosCoord.y := tempPosCoord.y + 1;
    ecrireEnPosition(tempPosCoord, copy(tempText, 0, largeur));
    tempText := copy(tempText, largeur+1, length(tempText)-largeur);
    end;
  if length(tempText) <> 0 then
     begin
     tempPosCoord.y := tempPosCoord.y + 1;
     ecrireEnPosition(tempPosCoord, tempText);
     end;
end;

//Fonction writeln qui marche avec des coordonnées non fixe (juste pour sauter une ligne)
procedure writelnPerso();
begin
  deplacerCurseurXY(positionCurseur.x, positionCurseur.y+1);
end;
//Fonction writeln qui marche avec des coordonnées non fixe
procedure writelnPerso(ligneAEcrire : String);
var
  posTemp : Integer; //Position en x du premier caractère de la ligne
begin
  posTemp := positionCurseur.x;
  deplacerCurseurXY(positionCurseur.x, positionCurseur.y+1);
  write(ligneAEcrire);
  deplacerCurseurXY(posTemp, positionCurseur.y);
end;
//Fonction readln qui marche avec des coordonnées non fixe (juste pour sauter une ligne)
procedure readlnPerso();
begin
  read();
  deplacerCurseurXY(positionCurseur.x, positionCurseur.y+1);
end;
//Fonction readln qui marche avec des coordonnées non fixe
procedure readlnPerso(var ligneAEnregistrer : String);
var
  posTemp : Integer;
begin
  posTemp := positionCurseur.x;
  deplacerCurseurXY(positionCurseur.x, positionCurseur.y+1);
  read(ligneAEnregistrer);
  deplacerCurseurXY(posTemp, positionCurseur.y);
end;
//Fonction readln qui marche avec des coordonnées non fixe
procedure readlnPerso(var ligneAEnregistrer : Integer);
var
  posTemp : Integer;
begin
  posTemp := positionCurseur.x;
  deplacerCurseurXY(positionCurseur.x, positionCurseur.y+1);
  read(ligneAEnregistrer);
  deplacerCurseurXY(posTemp, positionCurseur.y);
end;

end.

