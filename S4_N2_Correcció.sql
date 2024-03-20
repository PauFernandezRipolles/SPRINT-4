/*Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si 
les últimes tres transaccions van ser declinades i genera la següent consulta:
Exercici 1
Quantes targetes estan actives?*/
CREATE TABLE estat_tarjetes (
	id VARCHAR (50) primary key,
    trans_ultima int,
    trans_penultima int,
    trans_avantpenultima int
);
UPDATE transactions
SET timestamp = STR_TO_DATE(timestamp, '%d/%m/%Y %H:%i');
ALTER TABLE transactions MODIFY COLUMN timestamp DATETIME;
INSERT INTO estat_tarjetes (id, trans_ultima, trans_penultima, trans_avantpenultima)
SELECT card_id,
    (SELECT declined FROM transactions as t1 WHERE t1.card_id  = tarjetes_uniques.card_id
    ORDER BY timestamp DESC LIMIT 1) as trans_ultima,
    (SELECT declined FROM transactions as t2 WHERE t2.card_id  = tarjetes_uniques.card_id  
    ORDER BY timestamp DESC LIMIT 1 OFFSET 1) as trans_penultima,
    (SELECT declined FROM transactions as t3 WHERE t3.card_id  = tarjetes_uniques.card_id 
    ORDER BY timestamp DESC LIMIT 1 OFFSET 2) as trans_avantpenultima
FROM (SELECT DISTINCT card_id FROM transactions) as tarjetes_uniques;
SELECT COUNT(id) as tarjetes_actives
FROM estat_tarjetes
WHERE trans_ultima = 0;

ALTER TABLE estat_tarjetes
ADD COLUMN activa BOOLEAN DEFAULT 1;

UPDATE estat_tarjetes
SET activa = CASE
    WHEN trans_ultima = 0 AND trans_penultima = 0 AND trans_avantpenultima = 0 THEN 0
    ELSE 1
END;

SELECT COUNT(id)
FROM estat_tarjetes
WHERE activa = 1;