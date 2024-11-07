SP_HELP; -- Mostra todas as Tabelas, Functions, Owner e Object_type
SELECT name FROM sysobjects WHERE xtype ='U'; -- Mostra só o nome da tabela

SP_HELP Clients; -- Mostra as colunas da tabela e o tipo
SP_HELP Orders;

-- Mais exercicios

SELECT c.name, COUNT(o.client_id) AS total 
	FROM Clients c
	INNER JOIN Orders o ON o.client_id = c.id
	GROUP BY c.name
	HAVING COUNT(client_id) > 2
	ORDER BY total DESC;

SELECT c.name, o.total_price 
	FROM Clients c
	 INNER JOIN Orders o ON o.client_id = c.id
	 WHERE total_price > ( SELECT AVG(total_price) FROM Orders)
	 ORDER BY total_price DESC;

EXEC sp_rename 'Clients.client_name',  'name', 'COLUMN'; -- EXEC pra trocar nome da coluna;

SELECT  o.order_id, c.name, o.total_price, 
		category = CASE
					   WHEN o.total_price > 1000 THEN 'Alto'
					   WHEN o.total_price BETWEEN 500 AND 999 THEN 'Médio'
					   WHEN o.total_price < 500 THEN 'Baixo'
				   END
		FROM Orders o
		INNER JOIN Clients c ON c.id = o.client_id
		ORDER BY o.total_price DESC;

CREATE PROCEDURE UpdateClientEmail
	@id INT,
	@newEmail VARCHAR(124)
AS
BEGIN
	IF EXISTS(SELECT 1 FROM Clients WHERE id = @id)
	BEGIN
		UPDATE Clients 
		SET email = @newEmail
		WHERE id = @id;

		PRINT 'Email Updated!';
	END
	ELSE
	BEGIN
		PRINT 'Id does not exists!'
	END;
END

EXEC UpdateClientEmail 1, 'victormarin@example.com';