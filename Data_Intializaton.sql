INSERT INTO USER (Username, Name, Email, Phone, Password, Role) VALUES
('rahulhost', 'Rahul Sharma', 'rahul.sharma@gmail.com', '9876543210', 'rahulpass', 'HOST'),
('sneha_guest', 'Sneha Iyer', 'sneha.iyer@gmail.com', '9123456780', 'snehapass', 'GUEST'),
('arvindhost', 'Arvind Kumar', 'arvind.kumar@gmail.com', '9988776655', 'arvindpass', 'HOST'),
('priya_guest', 'Priya Singh', 'priya.singh@gmail.com', '9876501234', 'priyapass', 'GUEST'),
('neerajhost', 'Neeraj Patel', 'neeraj.patel@gmail.com', '9876512345', 'neerajpass', 'HOST'),
('akash_guest', 'Akash Verma', 'akash.verma@gmail.com', '8765432109', 'akashpass', 'GUEST'),
('divya_host', 'Divya Menon', 'divya.menon@gmail.com', '9988123456', 'divyapass', 'HOST'),
('vijay_guest', 'Vijay Reddy', 'vijay.reddy@gmail.com', '9123498765', 'vijaypass', 'GUEST'),
('pallavi_host', 'Pallavi Desai', 'pallavi.desai@gmail.com', '9876540987', 'pallavipass', 'HOST'),
('adminuser', 'Admin User', 'admin@gmail.com', '9000000000', 'adminpass', 'ADMIN');

INSERT INTO LOCATION (City, State, Country, ZipCode) VALUES
('Bengaluru', 'Karnataka', 'India', '560001'),
('Hyderabad', 'Telangana', 'India', '500001'),
('Mumbai', 'Maharashtra', 'India', '400001'),
('Chennai', 'Tamil Nadu', 'India', '600001'),
('New Delhi', 'Delhi', 'India', '110001'),
('Pune', 'Maharashtra', 'India', '411001'),
('Kolkata', 'West Bengal', 'India', '700001'),
('Ahmedabad', 'Gujarat', 'India', '380001'),
('Jaipur', 'Rajasthan', 'India', '302001'),
('Lucknow', 'Uttar Pradesh', 'India', '226001');

INSERT INTO PROPERTY (HostID, LocationID, Title, Address, Description, PricePerNight) VALUES
(1, 1, '2BHK Apartment', 'MG Road, Bengaluru', 'Spacious 2BHK near city center', 3200.00),
(3, 2, 'Modern Studio', 'Madhapur, Hyderabad', 'Well-designed studio with AC', 2500.00),
(5, 3, 'Sea View Apartment', 'Marine Drive, Mumbai', 'Beautiful sea-facing flat', 4500.00),
(7, 4, 'Chettinad House', 'Mylapore, Chennai', 'Heritage house with courtyard', 2800.00),
(1, 5, 'Luxorius Flat', 'Connaught Place, New Delhi', 'Premium apartment in heart of the city', 5200.00),
(3, 6, 'Budget Friendly Room', 'FC Road, Pune', 'Affordable stay with all basic facilities', 1500.00),
(5, 7, 'Riverside Bunglow', 'Howrah, Kolkata', 'Spacious Bunglow by the river', 6000.00),
(7, 8, 'City Center Property', 'CG Road, Ahmedabad', 'Walkable to shops and restaurants', 2700.00),
(9, 9, 'Jaipur heritage Bunglow', 'Amer Road, Jaipur', 'Royal experience in heritage Bunglow', 4000.00),
(9, 10, 'Guesthouse in Lucknow', 'Hazratganj, Lucknow', 'Comfortable and centrally located', 2300.00),
(3, 3, '3BHK Flat', 'Goregaon East, Mumbai', 'Spacious 3BHK near filmc city', 4500.00),
(1, 1, 'No-Booking Loft', 'Church Street, Bengaluru', 'Modern loft no bookings yet', 4000.00),
(3, 3, 'Empty Studio', 'Bandra, Mumbai', 'Studio apartment waiting for first guest', 2800.00);

INSERT INTO RESERVATION (PropertyID, GuestID, StartDate, EndDate) VALUES
(1, 2, '2024-09-22', '2024-09-25'),
(2, 4, '2024-10-15', '2024-10-17'),
(3, 6, '2024-11-02', '2024-11-04'),
(4, 8, '2024-12-08', '2024-12-10'),
(5, 2, '2025-01-01', '2025-01-03'),
(6, 4, '2025-01-05', '2025-01-07'),
(7, 6, '2025-02-10', '2025-02-12'),
(8, 8, '2025-03-15', '2025-03-20'),
(9, 2, '2025-04-25', '2025-04-28'),
(10,4, '2025-05-01', '2025-05-05'),
(3, 2, '2025-06-10', '2025-06-13'),
(2, 4, '2025-06-15', '2025-06-17'),
(10, 4, '2025-07-01', '2025-07-03'),
(2, 2, '2025-08-01', '2025-08-05'),  
(3, 2, '2025-09-10', '2025-09-12'),  
(4, 4, '2025-08-15', '2025-08-18'),
(1, 2, '2023-05-10', '2023-05-15'),
(2, 4, '2025-10-20', '2025-10-23'),
(3, 6, '2022-01-10', '2022-01-15');

INSERT INTO PAYMENT (ReservationID, Amount, PaymentDate, PaymentMethod, Status) VALUES
(1, 9600.00, '2024-09-19', 'UPI', 'SUCCESS'),
(2, 5100.00, '2024-10-11', 'Credit Card', 'SUCCESS'),
(3, 13750.00, '2024-10-30', 'Net Banking', 'SUCCESS'),
(4, 14500.00, '2024-12-04', 'UPI', 'SUCCESS'),
(5, 10450.00, '2024-12-29', 'Credit Card', 'SUCCESS'),
(6, 3100.00, '2025-01-03', 'UPI', 'PROCESSING'),
(7, 12200.00, '2025-02-04', 'Net Banking', 'SUCCESS'),
(8, 16500.00, '2025-03-10', 'Credit Card', 'SUCCESS'),
(9, 9400.00, '2025-04-21', 'UPI', 'FAILED'),
(9, 9400.00, '2025-04-21', 'Credit Card', 'SUCCESS'),
(10, 14050.00, '2025-04-27', 'UPI', 'SUCCESS'),
(14, 10000.00, '2025-07-25', 'Credit Card', 'SUCCESS'),
(15, 9500.00, '2025-09-01', 'UPI', 'PROCESSING'),
(16, 12000.00, '2025-08-10', 'Credit Card', 'FAILED'),
(6, 3100.00, DATE_SUB(CURDATE(), INTERVAL 400 DAY), 'UPI', 'PROCESSING'), -- fake data to test the last query of the queries list
(17, 8000.00, '2023-05-05', 'UPI', 'PROCESSING');

INSERT INTO CANCELLATION (ReservationID, CancelDate, Reason, RefundAmount) VALUES
(1, '2024-09-18', 'Change in travel plans', 9600.00),
(2, '2024-10-14', 'Found better option', 0.00),
(3, '2024-10-31', 'Unexpected emergency', 13750.00),
(5, '2024-12-27', 'Personal reasons', 5225.00),
(6, '2025-01-01', 'Schedule conflict', 3100.00),
(14, '2025-07-28', 'Change in plan', 10000.00),  
(15, '2025-09-02', 'Work conflict', 4750.00),    
(16, '2025-08-11', 'Emergency', 3000.00);

INSERT INTO REVIEW (PropertyID, GuestID, Rating, Comment, ReviewPostDate) VALUES
(1, 2, 5, 'Amazing stay in Bengaluru, super clean!', '2024-09-25'),
(2, 4, 4, 'Nice location in Hyderabad.', '2024-10-18'),
(3, 6, 5, 'Seaview is worth every penny.', '2024-11-04'),
(4, 8, 3, 'Chennai home is nice but needs upkeep.', '2024-12-11'),
(5, 2, 5, 'Luxury experience in Delhi!', '2025-01-03'),
(6, 4, 4, 'The room was neat and clean.', '2025-01-08'),
(7, 6, 5, 'Riverside view made my day.', '2025-02-12'),
(8, 8, 4, 'Very convenient and sweet place to visit.', '2025-03-21'),
(9, 2, 5, 'Loved the royal bungalow in Jaipur.', '2025-04-28'),
(10, 4, 4, 'Guesthouse was very comfy.', '2025-05-06'),
(2, 2, 2, 'Not as clean as expected.', '2025-08-06'),
(3, 2, 3, 'Decent stay.', '2025-09-12'),
(4, 4, 5, 'Loved the heritage vibes!', '2025-08-18');	