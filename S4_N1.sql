/*NIVELL 1
Descàrrega els arxius CSV, estudia'ls i dissenya una base de dades amb un esquema d'estrella que contingui, 
almenys 4 taules de les quals puguis realitzar les següents consultes:
Començo creant la base de dades i l'estructura de les taules segons els arxius csv. 
Primer creo la que identifico com a taula de fets: transactions */

CREATE DATABASE IF NOT EXISTS Trans_Sprint4;
USE Trans_Sprint4;

CREATE TABLE transactions (
	id VARCHAR(50) PRIMARY KEY,
    card_id VARCHAR(20),
    business_id VARCHAR(20),
    timestamp varchar(100),
    amount FLOAT,
    declined BOOLEAN,
    product_ids ENUM ('product1', 'product2', 'product3','product4','product5','product6'),
    user_id INT,
    lat INT,
    longitude INT
);
#drop table transactions;
# --local-infile=1
# --secure-file-priv=""
LOAD DATA LOCAL INFILE "C:\Program Files\MySQL\MySQL Workbench 8.0\extras\transactions.csv"
INTO TABLE transactions;
/*No consigo importar el contenido con LOAD DATA, Después de muchos intentos y modificaciones, 
al final consigo importarla con el import wizard creando tabla nueva con import wizard tb*/

CREATE TABLE users_ca (
	id VARCHAR(40),
    name VARCHAR(40),
    surname VARCHAR(60),
    phone VARCHAR(40),
    email VARCHAR(40),
    birth_date date,
    country VARCHAR(40),
    city VARCHAR(40),
    postal_code VARCHAR(40),
    adress VARCHAR(40)
);
/*Sigo sin poder importar el contenido con LOAD DATA,  al final consigo importarla con el 
import wizard creando tabla nueva con import wizard tb. Hago lo mismo con otdas las tablas.
- Empiezo por unir las 3 tablas de users ya que no veo ninguna ventaja en tenerlas separadas, 
manteniendo el orden del id para después poderlo cambiar a autoincremental*/
CREATE TABLE users_total (
  `id` int DEFAULT NULL,
  `name` text,
  `surname` text,
  `phone` text,
  `email` text,
  `birth_date` text,
  `country` text,
  `city` text,
  `postal_code` text,
  `address` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
INSERT INTO users_total (id,name,surname,phone,email,birth_date,country,city,postal_code,address)
SELECT * FROM users_usa
UNION ALL 
SELECT * FROM users_uk
UNION ALL
SELECT * FROM users_ca;
# compruebo que la tabla nueva es ok y elimino las anteriores
# Para crear el modelo asigno las PK. Como he importado en automàtico tengo que cambiar el tipo de columna
ALTER TABLE transactions 
MODIFY COLUMN id VARCHAR(50),
ADD PRIMARY KEY (id);
ALTER TABLE companies 
MODIFY COLUMN company_id VARCHAR(50),
ADD PRIMARY KEY (company_id);
ALTER TABLE credit_cards
MODIFY COLUMN id VARCHAR(50),
ADD PRIMARY KEY (id);
ALTER TABLE products
MODIFY COLUMN id VARCHAR(50),
ADD PRIMARY KEY (id);
ALTER TABLE users_total
MODIFY COLUMN id INT AUTO_INCREMENT,
ADD PRIMARY KEY (id);
#  ... y asigno las FK.
ALTER TABLE transactions 
MODIFY COLUMN card_id VARCHAR(50),
ADD CONSTRAINT fk_card FOREIGN KEY (card_id)
REFERENCES credit_cards(id);
ALTER TABLE transactions 
MODIFY COLUMN business_id VARCHAR(50),
ADD CONSTRAINT fk_business FOREIGN KEY (business_id)
REFERENCES companies(company_id);
ALTER TABLE transactions 
MODIFY COLUMN user_id VARCHAR(50),
ADD CONSTRAINT fk_user FOREIGN KEY (user_id)
REFERENCES users_total(id);
/* Me doy cuenta del problema de product_ids y después de ver varias opciones decido modificarlo
directamente en excel (con la funcion texto en columnas) añadiendo columnas para cada articulo 
product_id1,product_id2,3,4 i 5. Vuelvo a importar la tabla y aplico la PK y las FK's */
ALTER TABLE transactions 
MODIFY COLUMN product_id2 VARCHAR(50),
MODIFY COLUMN product_id3 VARCHAR(50),
MODIFY COLUMN product_id4 VARCHAR(50),
MODIFY COLUMN product_id5 VARCHAR(50);
ALTER TABLE transactions 
MODIFY COLUMN product_id1 VARCHAR(50),
ADD CONSTRAINT fk_product1 FOREIGN KEY (product_id1)
REFERENCES products(id);
/* Solo puedo referir como FK una de las columnas product pero no es problema para lo que se pide
de momento/* 
/* Exercici 1
Realitza una subconsulta que mostri tots els usuaris amb més de 30 transaccions 
utilitzant almenys 2 taules.*/

SELECT users_total.id, users_total.name, users_total.surname,COUNT(users_total.id) 
FROM users_total
JOIN transactions
ON users_total.id = transactions.user_id
GROUP BY users_total.id
HAVING COUNT(users_total.id) > 30;
# Como he unido las 3 tablas user en una no puedo hacerlo sin subquerys
/*Exercici 2
Mostra la mitjana de la suma de transaccions per IBAN de les targetes de crèdit 
en la companyia Donec Ltd. utilitzant almenys 2 taules.*/
SELECT company_name as Nom, iban, AVG(amount) as Mitjana
FROM transactions
JOIN credit_cards
ON transactions.card_id=credit_cards.id
JOIN companies
ON transactions.business_id=companies.company_id
WHERE company_name = 'Donec Ltd'
GROUP BY iban; 
