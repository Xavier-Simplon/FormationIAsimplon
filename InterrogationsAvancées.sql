#Interrogations avancées

#1/ Afficher tout les emprunt ayant été réalisé en 2006. Le mois doit être écrit en toute lettre et le résultat doit s’afficher dans une seul colonne.

use sakila;

SELECT *,concat(DATE_FORMAT(rental_date, '%d %M %Y'))
FROM rental 
WHERE year(rental_date) = 2006;

#2/ Afficher la colonne qui donne la durée de location des films en jour.

SELECT datediff(return_date,rental_date) as durée
from rental;

#3/ Afficher les emprunts réalisés avant 1h du matin en 2005. Afficher la date dans un format lisible.

SELECT rental.rental_id, DATE_FORMAT(rental.rental_date, '%D %M %H:%i:%s %x') as Date
from rental;
WHERE hour(rental.rental_date) < 1 and year(rental.rental_date)=2005;


#4/ Afficher les emprunts réalisé entre le mois d’avril et le moi de mai. La liste doit être trié du plus ancien au plus récent.

SELECT distinct rental_date, rental_id
from rental
where month(rental.rental_date) between 4 and 5;

#5/ Lister les film dont le nom ne commence pas par le « Le ».

select film.title
from film
where film.title not like 'Le%';

#6/ Lister les films ayant la mention « PG-13 » ou « NC-17 ». Ajouter une colonne qui affichera « oui » si « NC-17 » et « non » Sinon.

select rating,film.title,
	CASE rating
		WHEN 'NC-17' then 'oui'
        else 'non'
	END as is_NC_17
from film;

#7/ Fournir la liste des catégorie qui commence par un ‘A’ ou un ‘C’. (Utiliser LEFT).

SELECT category.name
from category
where left(category.name,1) like 'A' or left(category.name,1) like 'C';

#8/ Lister les trois premiers caractères des noms des catégorie.

select distinct left(category.name,3)
from category;

#9/ Lister les premiers acteurs en remplaçant dans leur prenom les E par des A.

select replace(actor.first_name, 'E','A')
from actor;



#LES JOINTURES

#Question 1 Lister les 10 premiers films ainsi que leur langues.

select film.title,L.name
from film
join language as L on film.language_id=L.language_id
limit 10;

#Question 2 Afficher les film dans les quel à joué « JENNIFER DAVIS » sortie en
#2006.
select film.title,actor.first_name,actor.last_name,year(film_actor.last_update)
from film
join film_actor on film.film_id=film_actor.film_id
join actor on film_actor.actor_id=actor.actor_id
where year(film_actor.last_update)=2006 and actor.first_name='JENNIFER' and actor.last_name='DAVIS';


#Question 3 Afficher le noms des client ayant emprunté « ALABAMA DEVIL ».

select customer.first_name,customer.last_name,film.title
from customer
join rental on customer.customer_id=rental.customer_id
join inventory on rental.inventory_id=inventory.inventory_id
join film on inventory.film_id=film.film_id
where (film.title = 'ALABAMA DEVIL');

#Question 4. Afficher les films louer par des personne habitant à « Woodridge ».
#Vérifié s’il y a des films qui n’ont jamais été emprunté.

select film.title
from film
join inventory on film.film_id=inventory.film_id
join rental on inventory.inventory_id=rental.inventory_id
join customer on rental.customer_id=customer.customer_id
join  address on customer.address_id=address.address_id
where address.address='Woodridge';

#Question 5. Quel sont les 10 films dont la durée d’emprunt à été la plus courte ?

select timediff(rental.return_date,rental.rental_date),film.title
from film
join inventory on film.film_id=inventory.film_id
join rental on inventory.inventory_id=rental.inventory_id
where rental.return_date>0
order by timediff(rental.return_date,rental.rental_date) asc
limit 10;

#Question 6. Lister les films de la catégorie « Action » ordonnés par ordre
#alphabétique.

select film.title, category.name
from film
join film_category on film.film_id=film_category.film_id
join category on film_category.category_id=category.category_id
where category.name = "Action" 
order by film.title asc;

#Question 7. Quel sont les films dont la duré d’emprunt à été inférieur à 2 jour ?

select timediff(rental.return_date,rental.rental_date),film.title
from film
join inventory on film.film_id=inventory.film_id
join rental on inventory.inventory_id=rental.inventory_id
where rental.return_date>0 and hour(timediff(rental.return_date,rental.rental_date))<48
order by timediff(rental.return_date,rental.rental_date) asc;