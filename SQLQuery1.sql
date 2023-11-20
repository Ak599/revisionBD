                       ----revision---
                     ---CREATION DES TABLES ----
 create table Client(clientID varchar(5) primary key ,
                 nom varchar(15) not null , ville varchar(20))

 create table Commandes(commandeID int identity(1,2) primary key , clientID varchar(5)foreign key references Client(clientID) ,
           datecom date )

create table DetailsCommandes ( commandeID int , produitID int , Qté int ,
            primary key(commandeID , produitID) )

alter table /*on change la table  */ DetailsCommandes add constraint FK_commandeID 
			   foreign key(commandeID) references Commandes(commandeID)

create table Produits( produitID int identity (1,1) primary key , libellé varchar(30) , prix int )

alter table /*on change la table  */ DetailsCommandes add constraint FK_produitID 
			   foreign key(produitID) references Produits(produitID)
	update /*modification*/ Produits 
  set /*indiquer*/ libellé='ordinateur '
  where produitID<10 

delete from DetailsCommandes  

   /*supprimer toute les commande faites le 01 novembre */
   delete /*supp les lignes*/ 
   from DetailsCommandes 
   where commandeID in (select commandeID from Commandes where datecom='01/11/20231')

select * from Client 
select * from Commandes 
select * from DetailsCommandes 
select * from Produits

 /* liste des clients ayant commande en utilisant in*/
 select *
 from Client 
 where clientID in (select clientID from Commandes)

  /* liste des clients ayant commande en utilisant exist*/
  select nom 
  from Client 
 where  exists ( select clientID from Commandes where Commandes.clientID=Client.clientID) 

    /*liste des clients ayant commande en utilisant la jointure*/
	select  distinct c.clientID , co.commandeID 
	from Client c , Commandes co 
	where c.clientID=co.clientID

	-----faire cette requête avec join
	 select  distinct c.clientID , co.commandeID 
	from Client c
	----where c.clientID=co.clientID
	join Commandes co on c.clientID=co.clientID

	/*liste des clients qui n'ont pas commandés avec in , exixts , jointure , join */
	                 /*IN*/
	select distinct clientID 
	from Client 
	where clientID not in (select clientID from Commandes)
	/*il est pertinent de mettre le distinct ici car le client peut passer
	+ieurs commandes donc il permet de reduire le nbre de commparaison */
	
	                 /*EXIXTS*/
select * 
  from Client 
 where   not exists ( select clientID from Commandes where Commandes.clientID=Client.clientID)

                    /*jointure gauche*/
select  distinct c.clientID , co.commandeID 
	from Client c
	 left join Commandes co on c.clientID=co.clientID
where co.clientID is null
                    /*jointure droite*/
select  distinct c.clientID , co.commandeID 
	from Commandes co
	 right join Client c on c.clientID=co.clientID
where co.clientID is null
/*si un opperateur est commutatif ie join A = join B */
  
 /*Selectionner les produits qui n 'ont pas ete commande en utilisant exixts , in , jointure*/
           /*EXISTS*/
select distinct p.produitID 
from Produits p 
   where not exists (select produitID from DetailsCommandes dc where dc.produitID=p.produitID)
		  
		  /*IN*/
select distinct p.produitID 
 from Produits p 
   where  produitID not in  (select produitID from DetailsCommandes dc where dc.produitID=p.produitID)

		   /*JOINTURE*/

 /*selectionner  pour chaque client son nbre de commande */
 select  Commandes.clientID,count( Client.clientID) as Nombre_de_Commandes from Commandes, Client
	where  Client.clientID = Commandes.clientID
	group by Commandes.clientID

/*selectionner  pour chaque client la quantite totale commande */
 select distinct Commandes.clientID,sum(Qté)as Quantite_Totale from Commandes, Client,DetailsCommandes
	where  Client.clientID=Commandes.clientID  and DetailsCommandes.commandeID=Commandes.commandeID
	group by Commandes.clientID

 /*selectionner les client (clientid compagny name) qui ont passer exactement 4 commande */

  /*selectionner les client (clientid) son nbre de commande et la commande totale qu il a commmande*/
  select distinct Commandes.clientID,count( Client.clientID) as Nombre_de_Commandes ,sum(Qté)as Quantite_Totale from Commandes, Client,DetailsCommandes
	where  Client.clientID=Commandes.clientID  and DetailsCommandes.commandeID=Commandes.commandeID
	group by Commandes.clientID