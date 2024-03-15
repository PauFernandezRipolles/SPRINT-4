/* NIVELL 3
Crea una taula amb la qual puguem unir les dades del nou arxiu products.csv amb la base de dades 
creada, tenint en compte que des de transaction tens product_ids. Genera la següent consulta:
Exercici 1
Necessitem conèixer el nombre de vegades que s'ha venut cada producte.*/
/* Después de haber creado la tabla en el Nivel 1 modificandola en excel, ahora veo que, para poder 
contar las ventas de cada producto, no es suficiente. En lugar de volver a crear la tabla transactions
de nuevo, creo una tabla intermedia entre transactions y products que se llamará compras y tendrá 
un id propio como PK, transaction_id como FK y product_id para cada producto comprado. Cada fila tendrá 
un solo producto y se repetiría transaction_id tantas veces como productos en la misma 
transacción.
Para hacerlo utilizo PowerQuery ya que es la manera más ràpida y clara. exporto la tabla desde PowerBI y 
la importo como las anteriores i creo PK i FK's */
ALTER TABLE compres RENAME COLUMN ï»¿id to id;
ALTER TABLE compres ADD PRIMARY KEY (id);
ALTER TABLE compres MODIFY COLUMN transaction_id VARCHAR(50),
ADD CONSTRAINT fk_transaction FOREIGN KEY (transaction_id) 
REFERENCES transactions(id);
ALTER TABLE compres MODIFY COLUMN product_id VARCHAR(50),
ADD CONSTRAINT fk_product FOREIGN KEY (product_id) 
REFERENCES products(id);
/*Necessitem conèixer el nombre de vegades que s'ha venut cada producte.*/
SELECT COUNT(product_id) vegades_venut, product_name, product_id
FROM compres
JOIN products
ON products.id=compres.product_id
GROUP BY product_id
ORDER BY vegades_venut DESC;

/* Retoco las FK para dar coherencia al modelo final*/
ALTER TABLE `trans_sprint4`.`transactions` 
DROP FOREIGN KEY `fk_product1`;
ALTER TABLE `trans_sprint4`.`transactions` 
DROP INDEX `fk_product1` ;

ALTER TABLE credit_cards 
ADD CONSTRAINT fk_estat_tarjetes FOREIGN KEY (id)
REFERENCES estat_tarjetes(id);
