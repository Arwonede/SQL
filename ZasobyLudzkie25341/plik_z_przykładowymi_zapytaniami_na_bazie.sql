#####wyświetli utworzone widoki
SELECT * FROM historia_zatrudnienia_pracownika;
SELECT * FROM pracownicy_stan_zatrudnienia;
SELECT * FROM pracownicy_z_adresami;
SELECT * FROM pracownicy_z_benefitami;
SELECT * FROM pracownicy_z_dzialu_IT;
SELECT * FROM pracownicy_z_kwalifikacjami;
SELECT * FROM pracownicy_z_urlopami;
SELECT * FROM pracownicy_z_wynagrodzeniem;
SELECT * FROM pracownicy_z_wysokim_placa;
SELECT * FROM szkolenia_pracowników;
SELECT * FROM widok_pracownicy_przełożeni;

#####przykładowe zapytania wykożystujące JOIN
#JOIN - połączenie, które zwraca wiersze, które mają pasujące wartości w obu tabelach
SELECT Pracownicy.nazwisko, Pracownicy.imię, Wynagrodzenia.kwota_wynagrodzenia, Kwalifikacje.nazwa_kwalifikacji, Historia_zatrudnienia.data_rozpoczęcia_pracy, Adres.miasto
FROM Pracownicy
INNER JOIN Wynagrodzenia ON Pracownicy.ID_pracownika = Wynagrodzenia.ID_pracownika
INNER JOIN Kwalifikacje ON Pracownicy.ID_pracownika = Kwalifikacje.ID_pracownika
INNER JOIN Historia_zatrudnienia ON Pracownicy.ID_pracownika = Historia_zatrudnienia.ID_pracownika
INNER JOIN Adres ON Pracownicy.ID_adres = Adres.ID_adres;

#LEFT JOIN - połączenie, które zwraca wszystkie wiersze z lewej tabeli i pasujące wiersze z prawej tabeli. Jeśli nie ma pasującego wiersza w prawej tabeli, zostanie zwrócony wiersz z wartościami NULL
SELECT Pracownicy.nazwisko, Pracownicy.imię, Stany_zatrudnienia.nazwa_stanu_zatrudnienia, Działy.nazwa_działu, Stanowiska.nazwa_stanowiska
FROM Pracownicy
LEFT JOIN Stany_zatrudnienia ON Pracownicy.ID_stanu_zatrudnienia = Stany_zatrudnienia.ID_stanu_zatrudnienia
LEFT JOIN Działy ON Pracownicy.ID_działu = Działy.ID_działu
LEFT JOIN Stanowiska ON Pracownicy.ID_stanowiska = Stanowiska.ID_stanowiska;

#RIGT JOIN - połączenie, które zwraca wszystkie wiersze z prawej tabeli i pasujące wiersze z lewej tabeli. Jeśli nie ma pasującego wiersza w lewej tabeli, zostanie zwrócony wiersz z wartościami NULL
SELECT Pracownicy.nazwisko, Pracownicy.imię, Urlopy.data_rozpoczęcia, Urlopy.data_zakończenia
FROM Pracownicy
RIGHT JOIN Urlopy ON Pracownicy.ID_pracownika = Urlopy.ID_pracownika;

#FULL JOIN (alternatywnie UNION)- połączenie, które zwraca wszystkie wiersze z obu tabel, niezależnie od tego, czy mają one pasujące wartości. Jeśli nie ma pasującego wiersza w jednej z tabel, zostanie zwrócony wiersz z wartościami NULL
SELECT imię, nazwisko, data_urodzenia FROM Pracownicy WHERE ID_stanowiska = 1
UNION
SELECT imię, nazwisko, data_urodzenia FROM Pracownicy WHERE ID_stanowiska = 2;

#lub

SELECT Pracownicy.imię, Pracownicy.nazwisko, Stanowiska.nazwa_stanowiska
FROM Pracownicy
LEFT JOIN Stanowiska ON Pracownicy.ID_stanowiska = Stanowiska.ID_stanowiska
UNION
SELECT Pracownicy.imię, Pracownicy.nazwisko, Stanowiska.nazwa_stanowiska
FROM Pracownicy
RIGHT JOIN Stanowiska ON Pracownicy.ID_stanowiska = Stanowiska.ID_stanowiska;


#####przykładowe aktualizacje danych
UPDATE Pracownicy
SET imię = 'Jan', nazwisko = 'Kowalski'
WHERE ID_pracownika = 100;

UPDATE Wynagrodzenia
SET kwota_wynagrodzenia = 27500
WHERE ID_wynagrodzenia = 1;

UPDATE Kwalifikacje
SET nazwa_kwalifikacji = 'Prawo jazdy A'
WHERE ID_kwalifikacje = 5;

UPDATE Urlopy
SET rodzaj_urlopu = 'Bezpłatny'
WHERE ID_urlopu = 6;

UPDATE Stanowiska
SET opis_stanowiska = 'Pracownik odpowiada za zespół księgowości'
WHERE ID_stanowiska = 10;


#####wykożystanie przykładowych funkcji i filtrów
SELECT imię, nazwisko FROM Pracownicy
JOIN Wynagrodzenia ON Pracownicy.ID_pracownika = Wynagrodzenia.ID_pracownika
WHERE kwota_wynagrodzenia = (SELECT MAX(kwota_wynagrodzenia) FROM Wynagrodzenia);

SELECT nazwa_działu FROM Działy
LEFT JOIN Stanowiska ON Działy.ID_działu = Stanowiska.ID_działu
WHERE Stanowiska.ID_stanowiska IS NULL;

SELECT imię, nazwisko FROM Pracownicy
WHERE YEAR(CURDATE()) - YEAR(data_urodzenia) <= 26;

SELECT imię, nazwisko FROM Pracownicy
JOIN Kwalifikacje ON Pracownicy.ID_pracownika = Kwalifikacje.ID_pracownika
WHERE nazwa_kwalifikacji = 'Uprawnienia na wózki widłowe';

SELECT AVG(kwota_wynagrodzenia) as srednie_wynagrodzenie, Działy.nazwa_działu FROM Wynagrodzenia
JOIN Pracownicy ON Wynagrodzenia.ID_pracownika = Pracownicy.ID_pracownika
JOIN Działy ON Pracownicy.ID_działu = Działy.ID_działu
GROUP BY Działy.nazwa_działu;

SELECT COUNT(ID_pracownika) FROM Pracownicy;

SELECT SUM(kwota_wynagrodzenia) FROM Wynagrodzenia;

SELECT * FROM Pracownicy WHERE nazwisko LIKE '%ski';

SELECT * FROM Pracownicy WHERE data_urodzenia BETWEEN '1990-01-01' AND '2000-12-31';


#####wykorzystanie grupowania
SELECT Działy.nazwa_działu, COUNT(Pracownicy.ID_pracownika)
FROM Pracownicy
JOIN Działy ON Pracownicy.ID_działu = Działy.ID_działu
GROUP BY Działy.nazwa_działu;

SELECT Działy.nazwa_działu, SUM(Wynagrodzenia.kwota_wynagrodzenia) as suma_wynagrodzeń
FROM Działy
INNER JOIN Pracownicy ON Działy.ID_działu = Pracownicy.ID_działu
INNER JOIN Wynagrodzenia ON Pracownicy.ID_pracownika = Wynagrodzenia.ID_pracownika
WHERE Wynagrodzenia.kwota_wynagrodzenia BETWEEN 7000 AND 10000
GROUP BY Działy.nazwa_działu
HAVING SUM(Wynagrodzenia.kwota_wynagrodzenia) BETWEEN 7000 AND 10000;

SELECT nazwa_stanu_zatrudnienia, COUNT(*)
FROM Pracownicy
JOIN Stany_zatrudnienia
ON Pracownicy.ID_stanu_zatrudnienia = Stany_zatrudnienia.ID_stanu_zatrudnienia
GROUP BY nazwa_stanu_zatrudnienia;


#####wykorzystanie sortowania
SELECT Pracownicy.nazwisko, Pracownicy.imię, Wynagrodzenia.kwota_wynagrodzenia
FROM Pracownicy
JOIN Wynagrodzenia ON Pracownicy.ID_pracownika = Wynagrodzenia.ID_pracownika
ORDER BY Wynagrodzenia.kwota_wynagrodzenia DESC, Pracownicy.nazwisko, Pracownicy.imię;

SELECT Pracownicy.imię, Pracownicy.nazwisko, Historia_zatrudnienia.data_rozpoczęcia_pracy
FROM Pracownicy
JOIN Historia_zatrudnienia ON Pracownicy.ID_pracownika = Historia_zatrudnienia.ID_pracownika
ORDER BY Historia_zatrudnienia.data_rozpoczęcia_pracy, Pracownicy.nazwisko, Pracownicy.imię;


#####usuwanie danych z bazy
DELETE FROM Urlopy WHERE ID_urlopu = 8;

DELETE FROM Benefity WHERE ID_benefitu = 26;
