Create Database Customers_Orders_Products 

Use Customers_Orders_Products

CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY,
  Name VARCHAR(50),
  Email VARCHAR(100)
);

INSERT INTO Customers (CustomerID, Name, Email)
VALUES
  (1, 'John Doe', 'johndoe@example.com'),
  (2, 'Jane Smith', 'janesmith@example.com'),
  (3, 'Robert Johnson', 'robertjohnson@example.com'),
  (4, 'Emily Brown', 'emilybrown@example.com'),
  (5, 'Michael Davis', 'michaeldavis@example.com'),
  (6, 'Sarah Wilson', 'sarahwilson@example.com'),
  (7, 'David Thompson', 'davidthompson@example.com'),
  (8, 'Jessica Lee', 'jessicalee@example.com'),
  (9, 'William Turner', 'williamturner@example.com'),
  (10, 'Olivia Martinez', 'oliviamartinez@example.com');

CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerID INT,
  ProductName VARCHAR(50),
  OrderDate DATE,
  Quantity INT
);

INSERT INTO Orders (OrderID, CustomerID, ProductName, OrderDate, Quantity)
VALUES
  (1, 1, 'Product A', '2023-07-01', 5),
  (2, 2, 'Product B', '2023-07-02', 3),
  (3, 3, 'Product C', '2023-07-03', 2),
  (4, 4, 'Product A', '2023-07-04', 1),
  (5, 5, 'Product B', '2023-07-05', 4),
  (6, 6, 'Product C', '2023-07-06', 2),
  (7, 7, 'Product A', '2023-07-07', 3),
  (8, 8, 'Product B', '2023-07-08', 2),
  (9, 9, 'Product C', '2023-07-09', 5),
  (10, 10, 'Product A', '2023-07-10', 1);


CREATE TABLE Products (
  ProductID INT PRIMARY KEY,
  ProductName VARCHAR(50),
  Price DECIMAL(10, 2)
);

INSERT INTO Products (ProductID, ProductName, Price)
VALUES
  (1, 'Product A', 10.99),
  (2, 'Product B', 8.99),
  (3, 'Product C', 5.99),
  (4, 'Product D', 12.99),
  (5, 'Product E', 7.99),
  (6, 'Product F', 6.99),
  (7, 'Product G', 9.99),
  (8, 'Product H', 11.99),
  (9, 'Product I', 14.99),
  (10, 'Product J', 4.99);

  Select * From Customers

  Select Name,Email
  From Customers
  Where Name like 'J%';

  Select OrderID,ProductName,Quantity
  From Orders;

 Select Sum(Quantity) As TotalQuantity
 From Orders;

 Select Name
 From Customers As C
 Join Orders as O ON C.CustomerID=O.CustomerID;

 Select ProductName
 From Products
 Where Price>10.00;

 Select C.Name As CustomerName , O.OrderDate
 From Customers as C
 Join Orders As O On C.CustomerID=O.CustomerID
 where O.OrderDate>='2023-07-05';

 Select AVG(Price) as AVGPrice
 From Products;

 Select C.Name As CustomerNmae,SUM(O.Quantity)
 From Customers as C
 Join Orders as O ON c.CustomerID= O.CustomerID
 Group By C.Name;

 Select * From Products as P
 Left Join Orders as O ON P.ProductName=O.ProductName
 Where O.OrderID is NULL;


SELECT TOP 5 C.Name AS CustomerName, SUM(o.Quantity) AS TotalQuantity
FROM Customers as  C
JOIN Orders as O ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID, C.Name
ORDER BY TotalQuantity DESC;

ALTER TABLE Products
ADD Category VARCHAR(50);

SELECT Category , AVG(Price) AS AveragePrice
FROM Products
GROUP BY Category;

SELECT C.CustomerID, C.Name
FROM Customers as C
LEFT JOIN Orders as O ON C.CustomerID = O.CustomerID
WHERE O.OrderID IS NULL;

Select OrderId,ProductName,Quantity
From Orders as O
join Customers As C ON O.CustomerID=C.CustomerID
Where NAme Like 'M%';

Select SUM(Price * Quantity) As TotalRevenue
From Products as P
Join Orders as O ON O.ProductName=P.ProductName;

Select Name, SUM(Quantity*Price) As IndividualRevenue
From Customers as C
Left Join Orders as O ON  C.CustomerID=O.CustomerID
Left Join Products as P ON O.ProductName=P.ProductName
Group By C.CustomerID,C.Name;

SELECT C.CustomerID, C.Name
FROM Customers as C
WHERE (
    SELECT COUNT(DISTINCT P.Category)
    FROM Products as P) = (SELECT COUNT(DISTINCT P.Category)
    FROM Products P
    JOIN Orders O ON P.ProductName = O.ProductName
    WHERE O.CustomerID = C.CustomerID
);

SELECT DISTINCT C.CustomerID, C.Name
FROM Customers as C
JOIN Orders O ON C.CustomerID = O.CustomerID
JOIN Orders V ON C.CustomerID = V.CustomerID
WHERE Datediff(Day,V.OrderDate,O.OrderDate)=1;

SELECT top 3 P.ProductName, AVG(O.Quantity) AS AverageQuantityOrdered
FROM Products P
JOIN Orders O ON P.ProductName = O.ProductName
GROUP BY P.ProductName
ORDER BY AverageQuantityOrdered DESC;

SELECT
  COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Orders) AS Percentage
FROM
  Orders
WHERE
  Quantity > (SELECT AVG(Quantity) FROM Orders);

SELECT DISTINCT C.CustomerID, C.Name
FROM Customers as C
WHERE NOT EXISTS (
    SELECT P.ProductID
    FROM Products AS P
    WHERE NOT EXISTS (
        SELECT O.OrderID
        FROM Orders AS O
        WHERE O.CustomerID = C.CustomerID
          AND O.ProductName = P.ProductName
    )
);

SELECT P.ProductID, P.ProductName
FROM Products AS P
WHERE  EXISTS (
    SELECT C.CustomerID
    FROM Customers AS C
    WHERE  EXISTS (
        SELECT O.OrderID
        FROM Orders AS O
        WHERE O.CustomerID = C.CustomerID
          AND O.ProductName = P.ProductName
    )
);

SELECT
 FORMAT(Orderdate,'') AS Month,
  SUM(Price * Quantity) AS TotalRevenue
FROM
  Orders As O
JOIN
  Products As P ON O.ProductName = P.ProductName
GROUP BY
 FORMAT(OrderDate, '')
ORDER BY
 FORMAT(OrderDate, '');


SELECT P.ProductID, P.ProductName
FROM Products P
WHERE (
    SELECT COUNT(DISTINCT C.CustomerID)
    FROM Customers C
    ) * 0.5 <= (
    SELECT COUNT(DISTINCT O.CustomerID)
    FROM Orders O
    WHERE O.ProductName = P.ProductName
    );

SELECT C.CustomerID, C.Name
FROM Customers C
WHERE Not EXISTS (
    SELECT P.ProductID
    FROM Products P
    WHERE P.Category = ''
      AND NOT EXISTS (
          SELECT O.OrderID
          FROM Orders O
          WHERE O.CustomerID = C.CustomerID
            AND O.ProductName = P.ProductName
      )
);

SELECT Top 5 C.CustomerID, C.Name, SUM(P.Price * O.Quantity) AS TotalSpent
FROM Customers AS C
JOIN Orders As O ON C.CustomerID = O.CustomerID
JOIN Products AS P ON O.ProductName = P.ProductName
GROUP BY C.CustomerID, C.Name
ORDER BY TotalSpent DESC;



SELECT
  O.CustomerID,
  C.Name,
  O.OrderID,
  O.ProductName,
  O.OrderDate,
  O.Quantity,
  SUM(O.Quantity) OVER (PARTITION BY O.CustomerID ORDER BY O.OrderDate) AS RunningTotal
FROM
  Orders O
JOIN
  Customers C ON O.CustomerID = C.CustomerID
ORDER BY
  O.CustomerID, O.OrderDate;

SELECT
 O.CustomerID,C.Name,O.OrderID,O.ProductName,O.OrderDate,O.Quantity,
 SUM(O.Quantity) OVER (PARTITION BY O.CustomerID ORDER BY O.OrderDate) AS RunningTotal
 FROM
  Orders O
JOIN
  Customers C ON O.CustomerID = C.CustomerID
ORDER BY
  O.CustomerID, O.OrderDate;

  WITH RankedOrders AS (
    SELECT
        O.CustomerID,
        O.OrderID,
        O.ProductName,
        O.OrderDate,
        O.Quantity,
        ROW_NUMBER() OVER (PARTITION BY O.CustomerID ORDER BY O.OrderDate DESC) AS OrderRank
    FROM
        Orders O
)

  SELECT
    R.CustomerID,
    C.Name,
    R.OrderID,
    R.ProductName,
    R.OrderDate,
    R.Quantity
FROM
    RankedOrders R
JOIN
    Customers C ON R.CustomerID = C.CustomerID
WHERE
    R.OrderRank <= 3
ORDER BY
    R.CustomerID, R.OrderDate DESC;

SELECT
    C.CustomerID,
    C.Name,
    SUM(P.Price * O.Quantity) AS TotalRevenue
FROM
    Customers C
JOIN
    Orders O ON C.CustomerID = O.CustomerID
JOIN
    Products P ON O.ProductName = P.ProductName
WHERE
    O.OrderDate >= GETDATE()
GROUP BY
    C.CustomerID, C.Name
ORDER BY
    TotalRevenue DESC;

SELECT P.ProductName, O.OrderDate, O.Quantity
FROM Customers AS C
JOIN Orders AS O ON C.CustomerID = O.CustomerID
JOIN Products AS P ON O.ProductName = P.ProductName
WHERE C.Country = 'YourCountry';

SELECT C.CustomerID, C.Name
FROM Customers AS C
WHERE (
  SELECT COUNT(DISTINCT DATEPART(MONTH, O.OrderDate))
  FROM Orders AS O
  WHERE O.CustomerID = C.CustomerID
    AND DATEPART(YEAR, O.OrderDate) = 2023 
) = 12;

SELECT C.CustomerID, C.Name
FROM Customers AS C
WHERE EXISTS (
  SELECT 1
  FROM Orders AS O1
  WHERE O1.CustomerID = C.CustomerID
    AND O1.ProductName = 'Product A' 
    AND EXISTS (
      SELECT 1
      FROM Orders AS O2
      WHERE O2.CustomerID = C.CustomerID
        AND O2.ProductName = 'Product A' 
        AND DATEADD(MONTH, 1, O1.OrderDate) = O2.OrderDate
    )
);

SELECT P.ProductName
FROM Products AS P
INNER JOIN Orders AS O ON P.ProductName = O.ProductName
WHERE O.CustomerID = 1 
GROUP BY P.ProductName
HAVING COUNT(O.OrderID) >= 2;




