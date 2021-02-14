# 1.Вибрати усіх клієнтів, чиє ім'я має менше ніж 6 символів.
SELECT * FROM client WHERE LENGTH(FirstName) < 6;
# 2.Вибрати львівські відділення банку.+
SELECT * FROM department WHERE DepartmentCity LIKE 'Lviv';
# 3.Вибрати клієнтів з вищою освітою та посортувати по прізвищу.
SELECT * FROM client WHERE Education LIKE 'high' ORDER BY LastName;
# 4.Виконати сортування у зворотньому порядку над таблицею Заявка і вивести 5 останніх елементів.
SELECT * FROM application ORDER BY idApplication DESC LIMIT 5;
# 5.Вивести усіх клієнтів, чиє прізвище закінчується на IV чи IVA.
SELECT * FROM client WHERE LastName LIKE '%IV' OR LastName LIKE '%IVA';
# 6.Вивести клієнтів банку, які обслуговуються київськими відділеннями.
SELECT * FROM client WHERE Department_idDepartment IN
                           (SELECT idDepartment FROM department WHERE DepartmentCity LIKE 'Kyiv');
# 7.Вивести імена клієнтів та їхні номера телефону, погрупувавши їх за іменами.
SELECT FirstName,Passport FROM client GROUP BY FirstName;
# 8.Вивести дані про клієнтів, які мають кредит більше ніж на 5000 тисяч гривень.
SELECT * FROM client WHERE idClient IN
                           (SELECT Client_idClient FROM application WHERE Sum > 5000 AND Currency = 'Gryvnia');
# 9.Порахувати кількість клієнтів усіх відділень та лише львівських відділень.
SELECT Sum(idClient) FROM client;
SELECT COUNT(idClient) FROM client WHERE Department_idDepartment IN
                                         (SELECT idDepartment FROM department WHERE DepartmentCity= 'Lviv');
# 10. Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.
SELECT MAX(Sum), FirstName, LastName FROM application
    JOIN client c ON c.idClient = application.Client_idClient
    GROUP BY FirstName, LastName;
# 11. Визначити кількість заявок на крдеит для кожного клієнта.
SELECT FirstName, LastName, COUNT(Client_idClient) AS application_credits FROM application
		JOIN client c ON application.Client_idClient = c.idClient
			GROUP BY Client_idClient;
# 12. Визначити найбільший та найменший кредити.
SELECT MIN(Sum), MAX(Sum) FROM application;
# 13. Порахувати кількість кредитів для клієнтів,які мають вищу освіту.
SELECT FirstName, LastName, COUNT(Client_idClient) AS application_credits FROM application
		JOIN client c ON application.Client_idClient = c.idClient WHERE c.Education='high'
			GROUP BY Client_idClient;
# 14. Вивести дані про клієнта, в якого середня сума кредитів найвища.
SELECT FirstName,LastName, AVG(Sum) AS max FROM client
    JOIN application a on client.idClient = a.Client_idClient
    GROUP BY FirstName, LastName ORDER BY max DESC LIMIT 1;
# 15. Вивести відділення, яке видало в кредити найбільше грошей
SELECT idDepartment,DepartmentCity, SUM(Sum) AS SUM FROM department
    	JOIN client c on department.idDepartment = c.Department_idDepartment
   		JOIN application a on c.idClient = a.Client_idClient
      	  GROUP BY idDepartment ORDER BY SUM DESC LIMIT 1;
# 16. Вивести відділення, яке видало найбільший кредит.
SELECT idDepartment, DepartmentCity, MAX(Sum) FROM department
   		 JOIN client c on department.idDepartment = c.Department_idDepartment
	     JOIN application a on c.idClient = a.Client_idClient;
# 17. Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.
UPDATE application
 JOIN client c on c.idClient = application.Client_idClient
 SET Currency = 'Gryvnia', Sum = 6000
 WHERE Education = 'high';
# 18. Усіх клієнтів київських відділень пересилити до Києва.
UPDATE client
JOIN department d on d.idDepartment = client.Department_idDepartment
SET City = 'Kiyv'
WHERE DepartmentCity='Kyiv';
# 19. Видалити усі кредити, які є повернені.
DELETE FROM application WHERE CreditState = 'Returned';
# 20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.
DELETE application FROM application
    JOIN client c on c.idClient = application.Client_idClient
WHERE c.LastName REGEXP '^.[aouei]';
# Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000
SELECT idDepartment, DepartmentCity, SUM(Sum) AS SUMA FROM department
JOIN client c on department.idDepartment = c.Department_idDepartment
JOIN application a on c.idClient = a.Client_idClient
WHERE DepartmentCity='Lviv' GROUP BY idDepartment HAVING SUMA>5000;
# Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000
SELECT * FROM client
JOIN application a on client.idClient = a.Client_idClient
WHERE Sum>5000 AND CreditState = 'Returned';
# Знайти максимальний неповернений кредит.
SELECT FirstName,LastName,MAX(Sum) AS SUMA FROM client
JOIN application a on client.idClient = a.Client_idClient
WHERE CreditState = 'Not returned' GROUP BY FirstName, LastName ORDER BY SUMA DESC LIMIT 1;
#Знайти клієнта, сума кредиту якого найменша
SELECT FirstName,LastName, MIN(Sum) AS SUMA FROM client
JOIN application a on client.idClient = a.Client_idClient
GROUP BY FirstName, LastName ORDER BY SUMA LIMIT 1;
#Знайти кредити, сума яких більша за середнє значення усіх кредитів
SELECT idApplication, Sum FROM application
  WHERE Sum > (SELECT AVG(Sum) FROM application);
#Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів*/
SELECT * FROM client
  WHERE City = (
    SELECT City FROM client
    JOIN application a on client.idClient = a.Client_idClient
    GROUP BY Client_idClient
    ORDER BY COUNT(Client_idClient) DESC LIMIT 1);
# місто чувака який набрав найбільше кредитів
SELECT FirstName,LastName,City,COUNT(Client_idClient) AS max_Count FROM client
    JOIN application a on client.idClient = a.Client_idClient
    GROUP BY Client_idClient
    ORDER BY max_Count DESC LIMIT 1;
