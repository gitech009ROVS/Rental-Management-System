# Rental Management System

A comprehensive database management system for managing property rentals, reservations, payments, and customer reviews. This project provides a robust solution for hosts to list properties and guests to make reservations with integrated payment processing and review management.

## Table of Contents

- [Features](#features)
- [Project Structure](#project-structure)
- [Database Schema](#database-schema)
- [Installation](#installation)
- [Database Setup](#database-setup)
- [Key Features & Functionality](#key-features--functionality)
- [Stored Procedures](#stored-procedures)
- [Sample Queries](#sample-queries)
- [Technologies Used](#technologies-used)
- [File Descriptions](#file-descriptions)
- [Contributing](#contributing)
- [License](#license)

## Features

### Core Functionality
- **User Management**: Support for three user roles - HOST, GUEST, and ADMIN
- **Property Management**: Hosts can list and manage rental properties with descriptions, pricing, and locations
- **Reservation System**: Guests can make reservations for properties with date validation
- **Payment Processing**: Integrated payment system with multiple payment methods and status tracking
- **Cancellation Management**: Automated refund calculation based on cancellation timing
- **Review System**: Guests can rate and review properties (1-5 star ratings)
- **Location Management**: Properties linked to geographic locations (city, state, country, zip code)

### Advanced Features
- **Role-Based Access Control**: Different permissions for Hosts, Guests, and Admins
- **Automated Refund Logic**: Intelligent refund calculation based on cancellation timeline
- **Repeat Customer Identification**: Track loyal customers for future discount opportunities
- **Payment Status Tracking**: Monitor payments (SUCCESS, PROCESSING, FAILED)
- **Data Cleanup**: Automatic deletion of stale and old payment records
- **Analytics Queries**: Built-in queries for business intelligence

## Project Structure

```
Rental-Management-System/
├── README.md                      # This file
├── DB_Schemas.sql                 # Database table definitions
├── DB_Setup.sql                   # Database creation script
├── Data_Intializaton.sql          # Sample data insertion
├── Queries.sql                    # Stored procedures and analytical queries
├── DBMS_PROJECT_REPORT.pdf        # Complete project documentation
└── DB_Model_Digrams/
    └── Relational_model.png       # Entity-Relationship Diagram
```

## Database Schema

### Core Tables

#### 1. **USER**
Manages system users with three roles.
```sql
UserID (INT, Primary Key, Auto-increment)
Username (VARCHAR 50, Unique, Not Null)
Name (VARCHAR 100, Not Null)
Email (VARCHAR 100, Unique, Not Null)
Phone (VARCHAR 20)
Password (VARCHAR 100, Not Null)
Role (ENUM: 'HOST', 'GUEST', 'ADMIN')
```

#### 2. **LOCATION**
Stores geographic information for properties.
```sql
LocationID (INT, Primary Key, Auto-increment)
City (VARCHAR 100, Not Null)
State (VARCHAR 100, Not Null)
Country (VARCHAR 100, Not Null)
ZipCode (VARCHAR 10)
```

#### 3. **PROPERTY**
Lists rental properties with pricing and descriptions.
```sql
PropertyID (INT, Primary Key, Auto-increment)
HostID (INT, Foreign Key → USER)
LocationID (INT, Foreign Key → LOCATION)
Title (VARCHAR 100, Not Null)
Address (VARCHAR 200, Not Null)
Description (TEXT)
PricePerNight (DECIMAL 10,2, Not Null)
```

#### 4. **RESERVATION**
Manages guest reservations with date validation.
```sql
ReservationID (INT, Primary Key, Auto-increment)
PropertyID (INT, Foreign Key → PROPERTY)
GuestID (INT, Foreign Key → USER)
StartDate (DATE, Not Null)
EndDate (DATE, Not Null)
CHECK: StartDate < EndDate
```

#### 5. **PAYMENT**
Tracks payment transactions for reservations.
```sql
PaymentID (INT, Primary Key, Auto-increment)
ReservationID (INT, Foreign Key → RESERVATION)
Amount (DECIMAL 10,2, Not Null)
PaymentDate (DATE, Not Null)
PaymentMethod (VARCHAR 100)
Status (ENUM: 'SUCCESS', 'PROCESSING', 'FAILED')
```

#### 6. **CANCELLATION**
Handles reservation cancellations with refund tracking.
```sql
CancellationID (INT, Primary Key, Auto-increment)
ReservationID (INT, Foreign Key → RESERVATION)
CancelDate (DATE, Not Null)
Reason (TEXT)
RefundAmount (DECIMAL 10,2, Default: 0.00)
```

#### 7. **REVIEW**
Stores guest reviews and ratings for properties.
```sql
ReviewID (INT, Primary Key, Auto-increment)
PropertyID (INT, Foreign Key → PROPERTY)
GuestID (INT, Foreign Key → USER)
Rating (INT, Check: 1-5)
Comment (TEXT)
ReviewPostDate (DATE)
```

### Entity Relationships
- **USER → PROPERTY**: One-to-Many (Host relationship)
- **LOCATION → PROPERTY**: One-to-Many
- **PROPERTY → RESERVATION**: One-to-Many
- **USER → RESERVATION**: One-to-Many (Guest relationship)
- **RESERVATION → PAYMENT**: One-to-Many
- **RESERVATION → CANCELLATION**: One-to-Many
- **PROPERTY → REVIEW**: One-to-Many
- **USER → REVIEW**: One-to-Many (Guest relationship)

## Installation

### Prerequisites
- MySQL Server (5.7 or higher)
- Database client (MySQL Workbench, DBeaver, or command line)
- Basic knowledge of SQL

### Setup Steps

1. **Clone the Repository**
   ```bash
   git clone https://github.com/gitech009ROVS/Rental-Management-System.git
   cd Rental-Management-System
   ```

2. **Create the Database**
   ```bash
   mysql -u root -p < DB_Setup.sql
   ```

3. **Create Tables**
   ```bash
   mysql -u root -p your_database_name < DB_Schemas.sql
   ```

4. **Load Sample Data**
   ```bash
   mysql -u root -p your_database_name < Data_Intializaton.sql
   ```

5. **Verify Installation**
   ```sql
   USE your_database_name;
   SELECT * FROM USER;
   SELECT * FROM PROPERTY;
   ```

## Key Features & Functionality

### User Roles and Permissions

| Role | Capabilities |
|------|-------------|
| **HOST** | Create and manage properties, view reservations, receive payments |
| **GUEST** | Browse properties, make reservations, write reviews, cancel bookings |
| **ADMIN** | Delete old failed payments, manage system data, user management |

### Refund Policy (Automated)
- **7+ days before reservation**: 100% refund
- **5-6 days before reservation**: 50% refund
- **2-4 days before reservation**: 25% refund
- **Less than 2 days**: No refund

### Data Retention Policy
- Automatic deletion of failed/processing payments older than 1 year
- Automatic deletion of reservations older than 1 year
- Automatic removal of unpaid reservations (no payment within 1 day)

## Stored Procedures

### 1. **UpdateProperty**
Allows hosts to update property details with authorization checks.
```sql
CALL UpdateProperty(hostID, propertyID, title, address, description, pricePerNight);
```
- **Security**: Only the property owner (host) can update their properties
- **Validation**: Raises error if user is not a host

### 2. **DeleteOldFailedPayments**
Admin-only procedure to clean up old payment records.
```sql
CALL DeleteOldFailedPayments(adminID);
```
- **Security**: Only admins can execute this procedure
- **Scope**: Deletes failed/processing payments older than 1 year
- **Validation**: Verifies admin role before execution

### 3. **cancelReservation**
Handles reservation cancellations with automatic refund calculation.
```sql
CALL cancelReservation(reservationID, reason);
```
- **Features**: Automatic refund calculation based on cancellation timing
- **Tracking**: Records cancellation reason and refund amount
- **Policy**: Implements tiered refund policy

## Sample Queries

### Business Intelligence Queries

1. **List All Properties with Host Names and Locations**
   ```sql
   SELECT P.PropertyID, U.Name, P.Title, P.PricePerNight, L.City, L.State
   FROM PROPERTY P
   JOIN USER U ON P.HostID = U.UserID
   JOIN LOCATION L ON P.LocationID = L.LocationID;
   ```

2. **Identify Loyal Customers (3+ visits)**
   ```sql
   SELECT U.Name, COUNT(ReservationID) AS VISIT_COUNT
   FROM USER U
   JOIN RESERVATION R ON U.UserID = R.GuestID
   WHERE U.Role = 'GUEST'
   GROUP BY U.UserID
   HAVING VISIT_COUNT > 2;
   ```

3. **Top 5 Properties by Rating**
   ```sql
   SELECT DENSE_RANK() OVER (ORDER BY AVG(Rating) DESC) AS RNK,
          P.PropertyID, P.Title, AVG(Rating) AS AVG_RATING
   FROM REVIEW R
   JOIN PROPERTY P ON R.PropertyID = P.PropertyID
   GROUP BY P.PropertyID
   ORDER BY RNK LIMIT 5;
   ```

4. **Top 5 Most Expensive Properties**
   ```sql
   SELECT DENSE_RANK() OVER (ORDER BY PricePerNight DESC) AS RNK,
          P.PropertyID, P.Title, PricePerNight
   FROM PROPERTY P
   ORDER BY RNK LIMIT 5;
   ```

5. **Total Revenue per Property (Net of Refunds)**
   - Uses Complex CTE query for accurate revenue calculation
   - Includes refund deductions from cancellations

6. **Property Reservation Counts**
   ```sql
   SELECT P.PropertyID, P.Title, COUNT(R.ReservationID) AS RESERVATION_COUNT
   FROM PROPERTY P
   LEFT JOIN RESERVATION R ON P.PropertyID = R.PropertyID
   GROUP BY P.PropertyID;
   ```

## Technologies Used

- **Database**: MySQL
- **Query Language**: SQL
- **Advanced Features**: Stored Procedures, Triggers, CTEs, Window Functions
- **Security**: Role-based access control, SQL injection prevention
- **Data Integrity**: Foreign keys, constraints, CHECK conditions

## File Descriptions

| File | Purpose |
|------|---------|
| `DB_Setup.sql` | Creates the database and selects it for use |
| `DB_Schemas.sql` | Defines all 7 tables with constraints and relationships |
| `Data_Intializaton.sql` | Populates database with sample data for testing |
| `Queries.sql` | Contains stored procedures and analytical queries |
| `DBMS_PROJECT_REPORT.pdf` | Complete project documentation and analysis |
| `DB_Model_Digrams/Relational_model.png` | ER diagram visualization |

## Data Integrity Features

- **Referential Integrity**: Foreign key constraints ensure valid relationships
- **Data Validation**: CHECK constraints for rating (1-5) and date logic
- **Cascading Deletes**: Automatic cleanup when parent records are deleted
- **Role-Based Authorization**: Procedures verify user role before modifications
- **Automatic Cleanup**: Scheduled deletion of stale and incomplete data

## Documentation

Comprehensive documentation including:
- Database design principles
- Normalization analysis (3NF)
- Query optimization strategies
- Use case diagrams
- Class diagrams
- ER diagrams with cardinality

See `DBMS_PROJECT_REPORT.pdf` for detailed documentation.

## Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Contribution Guidelines
- Follow SQL naming conventions (UPPERCASE for keywords)
- Add comments for complex queries
- Update documentation when adding features
- Test all changes with sample data
- Ensure backward compatibility

## Project Information

- **Type**: Database Management System (DBMS Project)
- **Database**: MySQL
- **Scope**: Rental property management platform
- **Status**: Complete and documented

## Future Enhancements

Potential improvements for future versions:
- Web application frontend (Django, Flask, or Node.js)
- REST API for integration
- Email notifications for reservations
- Advanced analytics dashboard
- Mobile application
- Rating system for hosts
- Messaging system between hosts and guests
- Loyalty rewards program
- Dynamic pricing based on demand

---

**Last Updated**: October 2026

For a visual representation of the database structure, see `DB_Model_Digrams/Relational_model.png`
