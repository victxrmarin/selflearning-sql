CREATE TABLE Employees(
  id INT NOT NULL IDENTITY(1,1),
  FirstName VARCHAR(55),
  LastName VARCHAR(55),
  Email VARCHAR(55),
  HireDate DATE
);

CREATE PROCEDURE AddEmployee
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Email VARCHAR(100),
    @HireDate DATETIME
AS
BEGIN
    INSERT INTO Employees (FirstName, LastName, Email, HireDate)
    VALUES (@FirstName, @LastName, @Email, @HireDate);
END;

EXEC AddEmployees 'Victor', 'Marin', 'victormarin.dev@gmail.com', GETDATE();

-- Logica dentro da Procedure

CREATE PROCEDURE AddEmployee
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Email VARCHAR(100),
    @HireDate DATETIME
AS
BEGIN
    DECLARE @EmailCount INT;
    
    SELECT @EmailCount = COUNT(*) 
    FROM Employees
    WHERE Email = @Email

    IF @EmailCount > 0 
    BEGIN 
        RAISERROR('Email já está em uso') -- Forma de informar um erro | Console.error
        RETURN;
    END;
    INSERT INTO Employees (FirstName, LastName, Email, HireDate)
    VALUES (@FirstName, @LastName, @Email, @HireDate);

    SELECT 'Funcionário adicionado com sucesso!' AS Message; -- Retorna uma mensagem de sucesso | Console.log
END;

EXEC AddEmployees 'Victor', 'Marin', 'victormarin.dev@gmail.com', GETDATE();
