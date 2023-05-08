####### UWAGA POLECENIA SĄ NIEODWRACALNE #######

#######usuwa wszystkie widoki
DROP VIEW historia_zatrudnienia_pracownika;
DROP VIEW pracownicy_stan_zatrudnienia;
DROP VIEW pracownicy_z_adresami;
DROP VIEW pracownicy_z_benefitami;
DROP VIEW pracownicy_z_dzialu_IT;
DROP VIEW pracownicy_z_kwalifikacjami;
DROP VIEW pracownicy_z_urlopami;
DROP VIEW pracownicy_z_wynagrodzeniem;
DROP VIEW pracownicy_z_wysokim_placa;
DROP VIEW szkolenia_pracowników;
DROP VIEW widok_pracownicy_przełożeni;


#######czyści zawartość tabel
DELETE FROM Adres;
DELETE FROM Benefity;
DELETE FROM Działy;
DELETE FROM Historia_zatrudnienia;
DELETE FROM Kwalifikacje;
DELETE FROM Pracownicy;
DELETE FROM Przełożony;
DELETE FROM Stanowiska;
DELETE FROM Stany_zatrudnienia;
DELETE FROM Szkolenia;
DELETE FROM Urlopy;
DELETE FROM Wynagrodzenia;


#######usunięcie całej tabeli
DROP TABLE Adres;
DROP TABLE Benefity;
DROP TABLE Działy;
DROP TABLE Historia_zatrudnienia;
DROP TABLE Kwalifikacje;
DROP TABLE Pracownicy;
DROP TABLE Przełożony;
DROP TABLE Stanowiska;
DROP TABLE Stany_zatrudnienia;
DROP TABLE Szkolenia;
DROP TABLE Urlopy;
DROP TABLE Wynagrodzenia;


#######usunięcie całej bazy danych
DROP DATABASE s25341;