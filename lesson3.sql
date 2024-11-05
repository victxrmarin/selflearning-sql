CREATE DATABASE exercicio3;
USE exercicio3;

CREATE TABLE Clients(
	id INT IDENTITY(1,1) PRIMARY KEY,
	client_name VARCHAR(55) NOT NULL,
	email VARCHAR(55) UNIQUE NOT NULL,
	phone_number VARCHAR(20),
	sign_date SMALLDATETIME DEFAULT GETDATE()
);

CREATE TABLE Orders(
	order_id INT IDENTITY(1,1) PRIMARY KEY,
	client_id INT NOT NULL,
	order_date SMALLDATETIME NOT NULL, 
	total_price DECIMAL(10,2) NOT NULL,
	FOREIGN KEY ( client_id ) REFERENCES Clients(id)
);

INSERT INTO Clients(client_name, email, phone_number) VALUES
('João Silva', 'joao.silva@example.com', '11987654321'),
('Maria Oliveira', 'maria.oliveira@example.com', '11998765432'),
('Carlos Pereira', 'carlos.pereira@example.com', '11996543210');


INSERT INTO Orders (client_id, order_date, total_price) VALUES
(1, '2024-11-01 14:30', 250.75),
(2, '2024-11-02 09:15', 500.00),
(3, '2024-11-03 11:45', 120.50),
(1, '2024-11-04 15:00', 350.00),
(2, '2024-11-05 10:00', 275.99),
(3, '2024-11-06 16:30', 450.25);


SELECT c.client_name, o.order_date, o.total_price
	FROM Clients c
	INNER JOIN Orders o ON o.client_id = c.id
	WHERE o.order_date >= '2024-10-01 14:30'
	ORDER BY o.order_date DESC;

CREATE FUNCTION dbo.DiscountCalc(
	@price DECIMAL(10,2)
) 
RETURNS DECIMAL(10,2)
AS
BEGIN
	DECLARE @discount DECIMAL(10,2)

	IF @price > 1000 
	BEGIN
		SET @discount = @price - (@price * 0.1)
		RETURN @discount;
	END;

	ELSE IF @price > 500 
	BEGIN
		SET @discount = @price - (@price * 0.05)
		RETURN @discount;
	END;

	RETURN @price;
END;

--

CREATE PROCEDURE InsertOrder
	@client_id INT,
	@order_date SMALLDATETIME,
	@total_price DECIMAL(10,2)
AS
BEGIN
	DECLARE @exist BIT

	SELECT @exist = CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END
	FROM Clients 
	WHERE id = @client_id;

	IF @exist != 1
	BEGIN
		RAISERROR('Client ID does not exists!',0,0)
		RETURN;
	END;

	INSERT INTO Orders (client_id,order_date, total_price)
	VALUES (@client_id, @order_date, @total_price);

	SELECT 'Order add sucessfully!' AS Message;
END;

EXEC InsertOrder 1, '2024-11-08 10:30', 400.00;

--

CREATE PROCEDURE UpdateOrderPrice
	@order_id INT,
	@new_price DECIMAL(10,2)
AS
BEGIN
	UPDATE Orders 
	SET total_price = dbo.DiscountCalc(@new_price)
	WHERE order_id = @order_id;
END;

EXEC UpdateOrderPrice 1, 520.00

--

CREATE PROCEDURE DeleteOrder
	@order_id INT
AS
BEGIN
	DELETE FROM Orders
	WHERE order_id = @order_id;
END;

EXEC DeleteOrder 1;

--

CREATE FUNCTION dbo.AllOrdersByClients(
	@client_id INT
) RETURNS INT
AS
BEGIN
	DECLARE @client_orders INT

	SELECT @client_orders = COUNT(*) FROM Orders
	WHERE client_id = @client_id
	
	RETURN @client_orders;
END;

SELECT dbo.AllOrdersByClients(1) AS Result;