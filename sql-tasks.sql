USE `bank`;
-- 1.Вибрати усіх клієнтів, чиє ім'я має менше ніж 6 символів.

SELECT* FROM client WHERE length(FirstName)<6;

-- 2.Вибрати львівські відділення банку.

SELECT* FROM department WHERE DepartmentCity='Lviv';

-- 3.Вибрати клієнтів з вищою освітою та посортувати по прізвищу.

SELECT* FROM client WHERE Education='high' ORDER BY LastName ;

-- 4.Виконати сортування у зворотньому порядку над таблицею Заявка і вивести 5 останніх елементів.

SELECT* FROM application ORDER BY Sum DESC LIMIT 5;

-- 5.Вивести усіх клієнтів, чиє прізвище закінчується на OV чи OVA.

SELECT* FROM client WHERE LastName LIKE '%OV' OR LastName LIKE '%OVA';

-- 6.Вивести клієнтів банку, які обслуговуються київськими відділеннями.

SELECT distinct FirstName,LastName,DepartmentCity  FROM  client JOIN department dep ON client.Department_idDepartment=dep.idDepartment
 WHERE dep.DepartmentCity="Kyiv";

-- 7.Знайти унікальні імена клієнтів.

SELECT distinct FirstName FROM client;

-- 8.Вивести дані про клієнтів, які мають кредит більше ніж на 5000 тисяч гривень.

SELECT  c.FirstName,c.LastName,app.Sum FROM  client c JOIN application app ON c.idClient=app.Client_idClient
 WHERE app.Sum > 5000;

-- 9.Порахувати кількість клієнтів усіх відділень та лише львівських відділень.
SELECT COUNT(client.idClient) FROM client;

SELECT COUNT(client.idClient) FROM client JOIN dep ON client.Department_idDepartment=dep.idDepartment
 WHERE dep.DepartmentCity='Lviv';

-- 10.Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.
SELECT MAX(Sum) FROM application GROUP BY Client_idClient;

-- 11. Визначити кількість заявок на крдеит для кожного клієнта.
SELECT c.FirstName,c.LastName,COUNT(app.idApplication) FROM application app JOIN client c ON app.Client_idClient=c.idClient GROUP BY app.Client_idClient;
-- 12. Визначити найбільший та найменший кредити.
SELECT Client_idClient, MAX(Sum) FROM application;

SELECT Client_idClient, MIN(Sum) FROM application;
-- 13. Порахувати кількість кредитів для клієнтів,які мають вищу освіту.
SElECT COUNT(app.Sum) FROM application app JOIN client c ON app.Client_idClient=c.idClient
where c.Education='high';
--  14. Вивести дані про клієнта, в якого середня сума кредитів найвища.

SELECT c.FirstName, avg(app.Sum) as avg FROM client c JOIN application app
ON c.idClient=app.Client_idClient group by c.idClient ORDER BY avg DESC LIMIT 1;

-- 15. Вивести відділення, яке видало в кредити найбільше грошей

SELECT dep.idDepartment,dep.DepartmentCity,Sum(app.Sum) as SUM FROM department dep JOIN client c ON dep.idDepartment=c.Department_idDepartment JOIN application app ON c.idClient=app.Client_idClient  group by dep.idDepartment ORDER BY SUM DESC LIMIT 1;

-- 16. Вивести відділення, яке видало найбільший кредит.
SELECT dep.idDepartment,dep.DepartmentCity, MAX(app.Sum) as MAX FROM department dep JOIN client c ON dep.idDepartment=c.Department_idDepartment JOIN application app ON c.idClient=app.Client_idClient group by dep.idDepartment ORDER BY MAX DESC LIMIT 1;

-- 17. Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.



update application app JOIN client c ON app.Client_idClient=c.idClient
set app.Sum='6000'
where c.Education='high';

-- 18. Усіх клієнтів київських відділень пересилити до Києва.
UPDATE client c JOIN department dep ON c.Department_idDepartment=dep.idDepartment
SET c.City = 'Kyiv'
WHERE dep.DepartmentCity='Kyiv';

-- 19. Видалити усі кредити, які є повернені.

DELETE FROM application WHERE CreditState = 'Returned';

-- 20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.


DELETE app FROM application app
JOIN client ON app.Client_idClient = client.idClient
WHERE (LastName LIKE '_[oaeiuy]%'
  OR LastName LIKE'_a%'
  OR LastName LIKE'_e%'
  OR LastName LIKE'_i%'
  OR LastName LIKE'_u%'
  OR LastName LIKE'_y%');


-- 21.Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000

SELECT dep.idDepartment, dep.DepartmentCity,SUM(app.Sum) as SUM FROM department dep JOIN client c ON dep.idDepartment=c.Department_idDepartment  JOIN application app ON c.idClient=app.Client_idClient WHERE dep.DepartmentCity='Lviv' AND app.SUM>5000 group by dep.idDepartment ;

-- 22.Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000

SELECT c.FirstName,c.LastName,app.Sum,app.CreditState FROM client c JOIN application app ON c.idClient=app.idApplication WHERE app.CreditState='Returned' AND app.Sum>5000;

-- 23.Знайти максимальний неповернений кредит.

select MAX(Sum),CreditState from application WHERE CreditState='Not returned';

-- 24.Знайти клієнта, сума кредиту якого найменша

SELECT c.FirstName,c.LastName, MIN(app.Sum) FROM CLIENT c JOIN application app ON c.idClient=app.Client_idClient ;

-- 25.Знайти кредити, сума яких більша за середнє значення усіх кредитів
SELECT* FROM application WHERE Sum>(SELECT avg(Sum) FROM application);

-- 26. Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів
SELECT* FROM client where City=(
SELECT c.City FROM client c JOIN
application app ON c.idClient=app.Client_idClient
group by app.Client_idClient order by COUNT(app.Client_idClient) DESC LIMIT 1 );

-- 27. Місто клієнта з найбільшою кількістю кредитів
SELECT c.City, COUNT(app.Client_idClient) FROM client c JOIN application app ON c.idClient=app.Client_idClient group by app.Client_idClient order by COUNT(app.Client_idClient) DESC LIMIT 1 ;
