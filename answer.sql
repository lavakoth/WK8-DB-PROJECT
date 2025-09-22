-- Create Database
CREATE DATABASE IF NOT EXISTS LibraryDB;
USE LibraryDB;

-- Table: Authors
CREATE TABLE Authors (
    AuthorID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Bio TEXT
);

-- Table: Categories
CREATE TABLE Categories (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) UNIQUE NOT NULL,
    Description TEXT
);

-- Table: Books
CREATE TABLE Books (
    BookID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    ISBN VARCHAR(13) UNIQUE NOT NULL,
    PublicationYear YEAR,
    CopiesAvailable INT DEFAULT 1,
    TotalCopies INT DEFAULT 1
);

-- Junction Table: BookAuthors (Many-to-Many)
CREATE TABLE BookAuthors (
    BookID INT,
    AuthorID INT,
    PRIMARY KEY (BookID, AuthorID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID) ON DELETE CASCADE,
    FOREIGN KEY (AuthorID) REFERENCES Authors(AuthorID) ON DELETE CASCADE
);

-- Junction Table: BookCategories (Many-to-Many)
CREATE TABLE BookCategories (
    BookID INT,
    CategoryID INT,
    PRIMARY KEY (BookID, CategoryID),
    FOREIGN KEY (BookID) REFERENCES Books(BookID) ON DELETE CASCADE,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID) ON DELETE CASCADE
);

-- Table: Members
CREATE TABLE Members (
    MemberID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15),
    MembershipType ENUM('Standard', 'Premium') DEFAULT 'Standard',
    JoinDate DATE DEFAULT CURDATE(),
    UnpaidFines DECIMAL(10,2) DEFAULT 0.00
);

-- Table: Borrowings
CREATE TABLE Borrowings (
    BorrowingID INT AUTO_INCREMENT PRIMARY KEY,
    BookID INT NOT NULL,
    MemberID INT NOT NULL,
    BorrowDate DATE DEFAULT CURDATE(),
    DueDate DATE NOT NULL,
    ReturnDate DATE,
    FOREIGN KEY (BookID) REFERENCES Books(BookID) ON DELETE RESTRICT,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID) ON DELETE RESTRICT
);

-- Table: Fines
CREATE TABLE Fines (
    FineID INT AUTO_INCREMENT PRIMARY KEY,
    BorrowingID INT UNIQUE NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    Paid BOOLEAN DEFAULT FALSE,
    PaymentDate DATE,
    FOREIGN KEY (BorrowingID) REFERENCES Borrowings(BorrowingID) ON DELETE CASCADE
);

-- Table: Reservations
CREATE TABLE Reservations (
    ReservationID INT AUTO_INCREMENT PRIMARY KEY,
    BookID INT NOT NULL,
    MemberID INT NOT NULL,
    ReservationDate DATE DEFAULT CURDATE(),
    Status ENUM('Active', 'Fulfilled', 'Cancelled') DEFAULT 'Active',
    FOREIGN KEY (BookID) REFERENCES Books(BookID) ON DELETE CASCADE,
    FOREIGN KEY (MemberID) REFERENCES Members(MemberID) ON DELETE CASCADE
);