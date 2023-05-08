########## tworzenie tabel w połączeniu z relacjami
CREATE TABLE Stany_zatrudnienia (
    ID_stanu_zatrudnienia INT AUTO_INCREMENT PRIMARY KEY,
    nazwa_stanu_zatrudnienia VARCHAR(50) NOT NULL
);

CREATE TABLE Działy (
    ID_działu INT AUTO_INCREMENT PRIMARY KEY,
    nazwa_działu VARCHAR(50) NOT NULL,
    opis_działu VARCHAR(255)
);

CREATE TABLE Stanowiska (
    ID_stanowiska INT AUTO_INCREMENT PRIMARY KEY,
    nazwa_stanowiska VARCHAR(50) NOT NULL,
    opis_stanowiska VARCHAR(255),
    ID_działu INT NOT NULL,
    FOREIGN KEY (ID_działu) REFERENCES Działy(ID_działu)
);

CREATE TABLE Adres (
    ID_adres INT AUTO_INCREMENT PRIMARY KEY,
    ulica VARCHAR(50) NOT NULL,
    nr_domu VARCHAR(10) NOT NULL,
    miasto VARCHAR(30) NOT NULL,
    kod_pocztowy VARCHAR(6) NOT NULL,
    kraj VARCHAR(30) NOT NULL
);

CREATE TABLE Pracownicy (
    ID_pracownika INT AUTO_INCREMENT PRIMARY KEY,
    imię VARCHAR(30) NOT NULL,
    nazwisko VARCHAR(30) NOT NULL,
    data_urodzenia DATE NOT NULL,
    pesel VARCHAR(11) UNIQUE NOT NULL,
    numer_telefonu VARCHAR(20) UNIQUE NOT NULL,
    adres_email VARCHAR(50) UNIQUE NOT NULL,
    ID_stanu_zatrudnienia INT NOT NULL,
    ID_stanowiska INT NOT NULL,
    ID_działu INT NOT NULL,
    ID_adres INT NOT NULL,
    FOREIGN KEY (ID_stanu_zatrudnienia) REFERENCES Stany_zatrudnienia(ID_stanu_zatrudnienia),
    FOREIGN KEY (ID_stanowiska) REFERENCES Stanowiska(ID_stanowiska),
    FOREIGN KEY (ID_działu) REFERENCES Działy(ID_działu),
    FOREIGN KEY (ID_adres) REFERENCES Adres(ID_adres)
);

CREATE TABLE Wynagrodzenia (
    ID_wynagrodzenia INT AUTO_INCREMENT PRIMARY KEY,
    kwota_wynagrodzenia FLOAT NOT NULL,
    ID_pracownika INT NOT NULL,
    FOREIGN KEY (ID_pracownika) REFERENCES Pracownicy(ID_pracownika)
);

CREATE TABLE Kwalifikacje (
    ID_kwalifikacje INT AUTO_INCREMENT PRIMARY KEY,
    nazwa_kwalifikacji VARCHAR(50) NOT NULL,
    opis_kwalifikacji VARCHAR(255),
    ID_pracownika INT NOT NULL,
    FOREIGN KEY (ID_pracownika) REFERENCES Pracownicy(ID_pracownika)
);

CREATE TABLE Urlopy (
    ID_urlopu INT AUTO_INCREMENT PRIMARY KEY,
    data_rozpoczęcia DATE NOT NULL,
    data_zakończenia DATE NOT NULL,
    rodzaj_urlopu VARCHAR(20) NOT NULL,
    ID_pracownika INT NOT NULL,
    FOREIGN KEY (ID_pracownika) REFERENCES Pracownicy(ID_pracownika)
);

CREATE TABLE Szkolenia (
    ID_szkolenia INT AUTO_INCREMENT PRIMARY KEY,
    nazwa_szkolenia VARCHAR(50) NOT NULL,
    opis_szkolenia VARCHAR(255),
    data_rozpoczęcia_szkolenia DATE NOT NULL,
    data_zakończenia_szkolenia DATE NOT NULL,
    koszt_szkolenia FLOAT NOT NULL,
    ID_pracownika INT NOT NULL,
    FOREIGN KEY (ID_pracownika) REFERENCES Pracownicy(ID_pracownika)
);

CREATE TABLE Historia_zatrudnienia (
    ID_historii INT AUTO_INCREMENT PRIMARY KEY,
    data_rozpoczęcia_pracy DATE NOT NULL,
    data_zakończenia_pracy DATE,
    ID_pracownika INT NOT NULL,
    ID_stanowiska INT NOT NULL,
    ID_działu INT NOT NULL,
    FOREIGN KEY (ID_pracownika) REFERENCES Pracownicy(ID_pracownika),
    FOREIGN KEY (ID_stanowiska) REFERENCES Stanowiska(ID_stanowiska),
    FOREIGN KEY (ID_działu) REFERENCES Działy(ID_działu)
);

CREATE TABLE Benefity (
    ID_benefitu INT AUTO_INCREMENT PRIMARY KEY,
    nazwa_benefitu VARCHAR(50),
    ID_pracownika INT NOT NULL,
    FOREIGN KEY (ID_pracownika) REFERENCES Pracownicy(ID_pracownika)
);

CREATE TABLE Przełożony (
    ID_przełożonego INT AUTO_INCREMENT PRIMARY KEY,
    imie_przełożonego VARCHAR(30),
    nazwisko_przełożonego VARCHAR(30),
    ID_pracownika INT NOT NULL,
    FOREIGN KEY (ID_pracownika) REFERENCES Pracownicy(ID_pracownika)
);

/* oddzielnie relacje można tworzyć poprzez modyfikowanie danych np.:
   ALTER TABLE nazwa_tabeli
   ADD FOREIGN KEY (nazwa_id_kolumny) REFERENCES nazwa_tabeli_relacji(nazwa_id_kolumny)*/



########## tworzenie indeksu na kolumnach dla tabeli oraz kilku kolumn
# na potrzeby projektu, aby nie obciążać danych w prawdziwych bazach stworzę kilka przykładowych indeksów
CREATE INDEX index_stany_zatrudnienia ON Stany_zatrudnienia (nazwa_stanu_zatrudnienia);

CREATE INDEX index_działy ON Działy (nazwa_działu);

CREATE INDEX index_stanowiska ON Stanowiska (nazwa_stanowiska);
CREATE INDEX index_stanowiska_dział ON Stanowiska (ID_działu);

CREATE INDEX index_adres ON Adres (miasto, kod_pocztowy);

ALTER TABLE Pracownicy ADD INDEX index_status_pracownika (imię, nazwisko, ID_stanowiska, ID_działu);
ALTER TABLE Stanowiska ADD INDEX index_status_pracownika (nazwa_stanowiska, ID_działu);
ALTER TABLE Działy ADD INDEX index_status_pracownika (nazwa_działu);
ALTER TABLE Przełożony ADD INDEX index_status_pracownika (imie_przełożonego, nazwisko_przełożonego, ID_pracownika);

CREATE INDEX index_wynagrodzenia ON Wynagrodzenia (kwota_wynagrodzenia);

CREATE INDEX index_kwalifikacje ON Kwalifikacje (nazwa_kwalifikacji);
CREATE INDEX index_kwalifikacje_pracownika ON Kwalifikacje (ID_pracownika);

CREATE INDEX index_urlopy ON Urlopy (rodzaj_urlopu, ID_pracownika);
CREATE INDEX index_data_urlopów ON Urlopy (data_rozpoczęcia, data_zakończenia);

CREATE INDEX index_szkolenia ON Szkolenia (nazwa_szkolenia, ID_pracownika);
CREATE INDEX index_data_szkolenia ON Szkolenia (data_rozpoczęcia_szkolenia, data_zakończenia_szkolenia);

CREATE INDEX index_historia_zatrudnienia ON Historia_zatrudnienia (data_rozpoczęcia_pracy, ID_pracownika);
CREATE INDEX index_historia_stanowisko ON Historia_zatrudnienia (ID_stanowiska);

#jest mało rodzaji benefitów, więc raczej nie trzeba ustawiać indeksu, ale zrobiłem, aby dla każdej tabeli zrobić przynajmniej jeden indeks
CREATE INDEX index_benefity ON Benefity (nazwa_benefitu);

CREATE INDEX index_przełożony ON Przełożony (nazwisko_przełożonego, imie_przełożonego, ID_pracownika);

#do usuwania indeksów służy
/*DROP INDEX index_nazwa ON tabela_nazwa*/



########## tworzenie widoków dla przykładowej bazy
CREATE VIEW widok_pracownicy_przełożeni AS
SELECT Pracownicy.nazwisko, Pracownicy.imię, Stanowiska.nazwa_stanowiska, Działy.nazwa_działu, Przełożony.nazwisko_przełożonego, Przełożony.imie_przełożonego
FROM Pracownicy
JOIN Stanowiska ON Pracownicy.ID_stanowiska = Stanowiska.ID_stanowiska
JOIN Działy ON Pracownicy.ID_działu = Działy.ID_działu
JOIN Przełożony ON Pracownicy.ID_pracownika = Przełożony.ID_pracownika;

CREATE VIEW pracownicy_z_adresami AS
SELECT nazwisko, imię, ulica, nr_domu, miasto, kod_pocztowy, kraj
FROM Pracownicy
JOIN Adres ON Pracownicy.ID_adres = Adres.ID_adres;

CREATE VIEW pracownicy_z_wynagrodzeniem AS
SELECT nazwisko, imię, kwota_wynagrodzenia
FROM Pracownicy
JOIN Wynagrodzenia ON Pracownicy.ID_pracownika = Wynagrodzenia.ID_pracownika;

CREATE VIEW pracownicy_z_kwalifikacjami AS
SELECT nazwisko, imię, nazwa_kwalifikacji
FROM Pracownicy
JOIN Kwalifikacje ON Pracownicy.ID_pracownika = Kwalifikacje.ID_pracownika;

CREATE VIEW pracownicy_z_benefitami AS
SELECT nazwa_benefitu, nazwisko, imię
FROM Benefity
JOIN Pracownicy ON Benefity.ID_pracownika = Pracownicy.ID_pracownika;

CREATE VIEW historia_zatrudnienia_pracownika AS
SELECT nazwisko, imię, nazwa_stanowiska, nazwa_działu, data_rozpoczęcia_pracy, data_zakończenia_pracy
FROM Historia_zatrudnienia
LEFT JOIN Pracownicy ON Historia_zatrudnienia.ID_pracownika = Pracownicy.ID_pracownika
RIGHT JOIN Stanowiska ON Historia_zatrudnienia.ID_stanowiska = Stanowiska.ID_stanowiska
RIGHT JOIN Działy ON Historia_zatrudnienia.ID_działu = Działy.ID_działu;

CREATE VIEW pracownicy_stan_zatrudnienia AS
SELECT nazwisko, imię, pesel, nazwa_stanu_zatrudnienia
FROM Pracownicy
JOIN Stany_zatrudnienia ON Pracownicy.ID_stanu_zatrudnienia = Stany_zatrudnienia.ID_stanu_zatrudnienia;

CREATE VIEW szkolenia_pracowników AS
SELECT nazwa_szkolenia, koszt_szkolenia, nazwisko, imię
FROM Szkolenia
JOIN Pracownicy ON Szkolenia.ID_pracownika = Pracownicy.ID_pracownika
WHERE koszt_szkolenia > 500;

CREATE VIEW pracownicy_z_urlopami AS
SELECT nazwisko, imię, rodzaj_urlopu
FROM Pracownicy
JOIN Urlopy ON Pracownicy.ID_pracownika = Urlopy.ID_pracownika;

CREATE VIEW pracownicy_z_dzialu_IT AS
SELECT nazwisko, imię, nazwa_działu
FROM Pracownicy
JOIN Działy ON Pracownicy.ID_działu = Działy.ID_działu
WHERE nazwa_działu = 'Dział IT';

CREATE VIEW pracownicy_z_wysokim_placa AS
SELECT nazwisko, imię, kwota_wynagrodzenia
FROM Pracownicy
JOIN Wynagrodzenia ON Pracownicy.ID_pracownika = Wynagrodzenia.ID_pracownika
WHERE kwota_wynagrodzenia > 10000;

########## wyświetlenie przykładowego widoku
SELECT * FROM widok_pracownicy_przełożeni;