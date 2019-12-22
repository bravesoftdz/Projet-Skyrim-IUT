unit unitMagasin;

{$codepage utf8}

interface

uses GestionEcran, unitInventaire, unitPersonnage, SysUtils, TypInfo;

procedure initMagasin(var listePerso,listeMagasin:Inventaire);
procedure achat(var p:Personnage; var listePer,listeMagasin:Inventaire);
procedure vente(var p:Personnage; var listePer,listeMagasin:Inventaire);
procedure negociation();




implementation
uses UnitMenu;
   var
      remise:boolean; //booléen qui vérifie si le joueur a une remise sur son prochain achat.

   procedure initMagasin(var listePerso,listeMagasin:Inventaire);
   var
     i:Integer;
     {On récupère de l'inventaire du joueur, les différents objets qu'il peut possèder
     et pour chaque objet on met la quantité d'objets disponible à 3.}
   begin
     for i:=0 to length(listePerso.listeObjets) do
     begin
         listeMagasin.listeObjets[i]:=listePerso.listeObjets[i];
         listeMagasin.possession[i]:=3;
     end;
   end;



   procedure achat(var p:Personnage; var listePer,listeMagasin:Inventaire);
   var
     nChoix,
     valobj : Integer;
     sortie:boolean;
     listePerTemp,
     listeMagasinTemp : Inventaire;
   begin
     listePerTemp := listePer;
     listeMagasinTemp := listeMagasin;
     sortie:=false;
     repeat
       InterfaceInGame();
       afficheInventaire(listePer);
       writelnPerso(' >  Epee --> 5 or');
       writelnPerso(' >  Bouclier --> 3 or');
       writelnPerso(' >  Potion --> 5 or');
       writelnPerso(' >  Quitter');
       if remise then
          writelnPerso('N''oubliez pas ! Vous avez 30% de remise sur un article au choix.')
       else
          writelnPerso();
       writelnPerso();

       nChoix := selectionMenu(posXY(positionCurseur().x, positionCurseur().y-5), 4, 1, 2, LightBlue, White) + 1;
       if (nChoix=4) then
          sortie:=true
       else
       begin
         if remise then
            valobj := listeMagasinTemp.listeObjets[nChoix].valeur * 7 div 10
         else
             valObj := listeMagasinTemp.listeObjets[nChoix].valeur;
         if p.argent>=valObj then
         begin
              remise:=false;
              listePerTemp.possession[nChoix]:=listePerTemp.possession[nChoix]+1; //ajout à l'inventaire du personnage
              p.argent:=p.argent-valObj; //diminution de la bourse du personnage
              listeMagasinTemp.possession[nChoix]:=listeMagasinTemp.possession[nChoix]-1;//diminution des stocks
              writelnPerso('Vous avez acquis un/une ' + listePerTemp.listeObjets[nChoix].nom + '  pour ' + IntToStr(valObj) + ' or. Vous en avez actuellement ' + IntToStr(listePer.possession[nChoix]) + ' et il vous reste maintenant ' + IntToStr(p.argent) +' or.');
              readlnPerso();
         end
         else
         begin
              writelnPerso('Vous n''avez pas l''argent necessaire.');
              readlnPerso();
         end;
       end;
       setPersonnage(p);
       listePer := listePerTemp;
       listeMagasin := listeMagasinTemp;
     until (sortie); //Fin while(sortie=false)
   end;

  procedure vente(var p:Personnage; var listePer,listeMagasin:Inventaire);
  var
     nChoix : Integer;
     sortie : boolean;
     listePerTemp,
     listeMagasinTemp : Inventaire;
  begin
     listePerTemp := listePer;
     listeMagasinTemp := listeMagasin;
     sortie := false;
     repeat
       InterfaceInGame();
       afficheInventaire(listePer);
       writelnPerso(' >  Vendre une epee pour 3 or ? Vous en avez ' + IntToStr(listePer.possession[1]));
       writelnPerso(' >  Vendre un Bouclier pour 1 or ? Vous en avez ' + IntToStr(listePer.possession[2]));
       writelnPerso(' >  Vendre une potion pour 3 or ? Vous en avez ' + IntToStr(listePer.possession[3]));
       writelnPerso(' >  Quitter');
       nChoix := selectionMenu(posXY(positionCurseur().x, positionCurseur().y-3), 4, 1, 2, LightBlue, White) + 1;
       if (nChoix=4) then
          sortie:=true
       else if (nChoix = 1) AND (listePer.possession[1] > 0) then
          begin
          writelnPerso('Vous vendez une epee pour 3 or');
          p.argent := p.argent + 3;
          listePerTemp.possession[1]:=listePerTemp.possession[nChoix]-1;
          readlnPerso();
          end
       else if (nChoix = 2) AND (listePer.possession[2] > 0) then
          begin
          writelnPerso('Vous vendez un Bouclier pour 1 or');
          p.argent := p.argent + 1;
          listePerTemp.possession[2]:=listePerTemp.possession[nChoix]-1;
          readlnPerso();
          end
       else if (nChoix = 3) AND (listePer.possession[3] > 0) then
          begin
          writelnPerso('Vous vendez une potion pour 3 or');
          p.argent := p.argent + 3;
          listePerTemp.possession[3]:=listePerTemp.possession[nChoix]-1;
          readlnPerso();
          end
       else if (listePer.possession[nChoix] = 0) then
          begin
          writelnPerso('Vous n''avez pas cet objet.');
          readlnPerso();
          end;
       setPersonnage(p);
       listePer := listePerTemp;
       listeMagasin := listeMagasinTemp;
     until (sortie);
  end;

  procedure negociation();
  var
     nbADeviner,
     nbEssais,
     nb : Integer;
     sortie : boolean;
  begin
     sortie:=false;
     nbEssais:=0;
     randomize();
     writelnPerso('Ah vous voulez jouer, ... sachez que je suis joueur moi aussi et si vous gagner contre moi vous gagnerez 30% de remise sur n''importe quel article pour votre prochain achat');
     readlnPerso();
     writelnPerso(' _____');
     writelnPerso('|  _  |');
     writelnPerso('|  ?  |');
     writelnPerso('|_____|');
     writelnPerso();
     nbADeviner:=random(50)+1;
     writelnPerso('Les regles sont simples, vous devez trouver le nombre écrit au dos de ce tableau');
     writelnPerso('Vous avez 4 essais, le nombre est compris entre 1 et 50. C''est parti ! Proposez un nombre !');
     repeat
       nbEssais:=nbEssais+1;
       if (nbEssais>4) then
       begin
            writelnPerso('Dommage ! Vous avez dépassé le nombre d''essais ! Vous paierez les articles au prix fort !');
            sortie:=true;
            writelnPerso('Le nombre était ' + IntToStr(nbADeviner) + '.');
       end
       else
       begin
            readlnPerso(nb);
            if nb=nbADeviner then
            begin
                 remise:=true;
                 sortie:=true;
                 writelnPerso('Bien joué ! Vous avez 30% de remise sur n''importe quel article.')
            end
            else
            begin
                 if nb>nbADeviner then
                 begin
                      writelnPerso('Raté le nombre est plus petit que ' + IntToStr(nb) + '.');
                 end
                 else
                 begin
                      writelnPerso('Raté le nombre est plus grand que ' + IntToStr(nb) + '.');
                 end;
            end;
       end;
     until(sortie);
     readlnPerso();
     readlnPerso();

  end;

end.
