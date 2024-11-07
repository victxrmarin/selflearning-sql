IF EXISTS ( SELECT TOP 1 1 FROM Orders )
 BEGIN
	SELECT total_price, 
	RANK() OVER (ORDER BY total_price DESC) AS Expensive -- Rankeia de acordo com a query
	FROM Orders;
END;


CREATE PROCEDURE PlaceOrder
    @client_id INT,
    @order_id INT,
    @total_price DECIMAL(10,2)
AS
BEGIN
    BEGIN TRANSACTION; -- Começa a transação

    BEGIN TRY
        DECLARE @client_status VARCHAR(50);
        SELECT @client_status = CASE
									WHEN status = 1 THEN 'Ativo'
									ELSE 'Inativo'
								END
			FROM Clients 
			WHERE id = @client_id;

        IF @client_status IS NULL OR @client_status != 'Ativo'
        BEGIN
            PRINT 'Cliente não encontrado ou está inativo!';
            ROLLBACK;
            RETURN;
        END

        INSERT INTO Orders (order_id, client_id, total_price, order_date)
        VALUES (@order_id, @client_id, @total_price, GETDATE());

        UPDATE Clients
        SET status = TRY_CAST('Pedido Realizado' AS BIT)
        WHERE id = @client_id;

        COMMIT;
        PRINT 'Pedido realizado com sucesso!';
    END TRY

    BEGIN CATCH
        ROLLBACK;
        PRINT 'Erro: ' + ERROR_MESSAGE();
    END CATCH;
END;


SELECT name,
	   CASE
	 	 WHEN status = 1 THEN 'Ativo'
		 ELSE 'Inativo'
	   END AS Stat
	FROM Clients
	ORDER BY Stat ASC;
