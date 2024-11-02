USE skastudy;

CREATE FUNCTION dbo.MinuteToHours(@minute INT)
RETURNS FLOAT
AS
BEGIN
	RETURN CAST(@minute AS FLOAT)/ 60.0 
END;

SELECT dbo.MinuteToHours(120) AS result;

CREATE FUNCTION dbo.CalculePayment(
    @minutesWorked INT,
    @hourlyRate DECIMAL(10,2),
    @bonus  DECIMAL(10, 2) = 0
)
RETURN DECIMAL(10, 2)
AS
BEGIN
    DECLARE @totalPayment DECIMAL(10,2);
    DECLARE @hoursWorked FLOAT;

    SET @hoursWorked = dbo.MinuteToHours(@minutesWorked);
    SET @totalPayment = (@hoursWorked * hourlyRate) + @bonus;

    RETURN @totalPayment;
END;

SELECT dbo.CalculePayment(120, 1.50, 100.00) AS result;


