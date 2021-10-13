SELECT DISTINCT ProductName from Products
WHERE UnitPrice = (SELECT MAX(UnitPrice) from Products) AND CategoryID = 1;



SELECT ShipCity from Orders WHERE DATEDIFF(day, ShippedDate, RequiredDate) > 10;




SELECT * from Customers WHERE CustomerID in (SELECT CustomerID from Orders where ShippedDate is NULL);






DROP TABLE #cust_cnt;

WITH Empl_Id_And_Count as (SELECT TOP 1 EmployeeID, COUNT(*) as total_count
FROM [dbo].Orders
GROUP BY EmployeeID
ORDER BY total_count DESC
)


SELECT CustomerID
INTO #cust_cnt
from Orders
WHERE EmployeeID in (SELECT EmployeeID as id from Empl_Id_And_Count) GROUP BY CustomerID 



SELECT COUNT(*) from #cust_cnt






SELECT COUNT(*) FROM Orders
WHERE EmployeeID = 1 
AND ShipCountry = 'France'
AND DATEDIFF(year, DATEFROMPARTS(1996, 1,1), RequiredDate) = 0



SELECT CurOrders.ShipCountry
FROM Orders as TotalOrders
CROSS APPLY(
	SELECT ShipCountry from Orders as CountryOrders
	WHERE CountryOrders.CustomerID = TotalOrders.CustomerID
) as CurOrders
GROUP BY ShipCity, CurOrders.ShipCountry
HAVING COUNT(ShipCity) > 2


SELECT Products.ProductName, SUM(Quantity) from [Order Details]
INNER JOIN Products
ON [Order Details].ProductID = Products.ProductID
GROUP BY Products.ProductName
HAVING SUM(Quantity) < 1000;




SELECT DISTINCT ContactName FROM Customers
INNER JOIN Orders on Customers.CustomerID = Orders.CustomerID
WHERE NOT ShipCity = CITY





SELECT TOP 1 CategoryName from Categories
INNER JOIN Products ON Products.CategoryID = Categories.CategoryID
INNER JOIN (SELECT ProductID 
from Orders
INNER JOIN [Order Details] on [Order Details].OrderID = Orders.OrderID
INNER JOIN Customers ON Customers.CustomerID = Orders.CustomerID
WHERE DATEDIFF(year, RequiredDate, DATEFROMPARTS(1997,1,1)) = 0
AND NOT Customers.Fax IS NULL 
) as FilteredProducts ON FilteredProducts.ProductID = Products.ProductID
GROUP BY CategoryName
ORDER BY COUNT(CategoryName) DESC






SELECT SUM([Order Details].Quantity), Employees.FirstName, Employees.LastName
from Orders
INNER JOIN[Order Details] ON Orders.OrderID = [Order Details].OrderID
INNER JOIN Employees ON Employees.EmployeeID = Orders.EmployeeID
WHERE DATEDIFF(month,RequiredDate, DATEFROMPARTS(1996, 9, 1)) >= 0
AND DATEDIFF(month, RequiredDate, DATEFROMPARTS(1996, 9, 1)) < 3
GROUP BY Employees.FirstName, Employees.LastName;