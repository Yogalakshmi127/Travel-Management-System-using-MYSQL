-- TRAVEL MANAGEMENT SYSTEM

-- TABLE - TO MANAGE CUSTOMER DETAILS
create table tcustomers(customer_id int auto_increment primary key,
customer_name varchar(255) not null, age int,phone_no varchar(15) not null,
email_id varchar(255) unique,address varchar(255));
insert into tcustomers values(1,"Varshini",26,"8987564839","varshini23@gmail.com","23/A,customs colony,thoraipakkam");
insert into tcustomers values(2,"Lishma",24,"1234567893","lishma09@gmail.com","23/A,golden avenue,ashok nagar");
insert into tcustomers values(3,"Boomija",21,"8987564321","boomija14@gmail.com","36,Thiruvalluvar nagar,adyar");
insert into tcustomers values(4,"Akshu",20,"8984564839","akshu12@gmail.com","34, 36th cross street,Thiruvanmiyur");
insert into tcustomers values(5,"Jagan",23,"8987564654","jagan16@gmail.com","155,West anna nagar,pallikranai");
select * from tcustomers;
drop table tcustomers;

-- TABLE - MANAGE TRAVEL PACKAGES
create table tpackages(package_id int auto_increment primary key,package_name varchar(100) not null,destination varchar(100) not null,price decimal(10,2) not null,start_date date not null,end_date date not null);
insert into tpackages values(1,"Fully Loaded Georgia Tour","Georgia",250000,'2024-07-12','2024-07-19');
insert into tpackages values(2,"Experience HongKong and Makur Tour","HongKong",350000,'2024-07-15','2024-07-22');
insert into tpackages values(3,"Tropical Bali Escape","Bali",550000,'2024-05-12','2024-05-15');
insert into tpackages values(4,"London Swiss Paris Delight Tour","Paris",600000,'2024-09-23','2024-09-23');
insert into tpackages values(5,"Best of Europe Tour","Europe",700000,'2024-10-22','2024-10-29');

select * from tpackages;
drop table tpackages;

-- TABLE - MANAGE TRAVEL BOOKNGS
create table tbookings(booking_id int auto_increment primary key,customer_id int,package_id int,booking_date date,status varchar(50),foreign key(customer_id) references tcustomers(customer_id),foreign key(package_id) references tpackages(package_id));
insert into tbookings(customer_id,package_id,booking_date,status) values(1,1,'2024-07-10','Confirmed');
insert into tbookings(customer_id,package_id,booking_date,status) values(2,2,'2024-07-01','Confirmed');
insert into tbookings(customer_id,package_id,booking_date,status) values(3,3,'2024-05-10','Confirmed');
insert into tbookings(customer_id,package_id,booking_date,status) values(4,4,'2024-09-20','Confirmed');
insert into tbookings(customer_id,package_id,booking_date,status) values(5,5,'2024-10-10','Confirmed');
select * from tbookings;

-- TABLE - MANAGE TRAVEL PAYMENT
create table tpayments(payment_id int auto_increment primary key,booking_id int,amount decimal(20,5),payment_date date,payment_method varchar(50),foreign key(booking_id) references tbookings(booking_id));
insert into tpayments(booking_id,amount,payment_date,payment_method) values(1,250000,'2024-07-10','Credit Card');
insert into tpayments(booking_id,amount,payment_date,payment_method) values(2,350000,'2024-07-01','Debit Card');
insert into tpayments(booking_id,amount,payment_date,payment_method) values(3,550000,'2024-05-10','Cash');
insert into tpayments(booking_id,amount,payment_date,payment_method) values(4,600000,'2024-09-20','Credit Card');
insert into tpayments(booking_id,amount,payment_date,payment_method) values(5,700000,'2024-10-10','UPI');
select * from tpayments;
drop table tpayments;
 
 -- creating table for customer feedback
CREATE TABLE Feedback (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    package_id INT,
    feedback_text TEXT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    feedback_date DATE,
    FOREIGN KEY (customer_id) REFERENCES tcustomers(customer_id),
    FOREIGN KEY (package_id) REFERENCES tpackages(package_id)
);
select * from feedback;

INSERT INTO Feedback (customer_id, package_id, feedback_text, rating, feedback_date) 
VALUES (1, 1, 'Amazing experience!', 5, '2024-07-20');
INSERT INTO Feedback (customer_id, package_id, feedback_text, rating, feedback_date) 
values (2, 2, 'Overall Good!', 4.5, '2024-07-23');
INSERT INTO Feedback (customer_id, package_id, feedback_text, rating, feedback_date) 
values(3, 3, 'Average Experience', 3, '2024-05-16');
INSERT INTO Feedback (customer_id, package_id, feedback_text, rating, feedback_date) 
values(4, 4,'Good',2.5,'2024-05-24');
INSERT INTO Feedback (customer_id, package_id, feedback_text, rating, feedback_date) 
values(5,5,'Very Poor',1,'2024-10-30');


-- Finding and updating status of Ticket Booking using CASE
SELECT booking_id, 
       customer_id, 
       package_id, 
       booking_date, 
       CASE 
           WHEN status = 'Confirmed' THEN 'Confirmed Booking'
           WHEN status = 'Cancelled' THEN 'Cancelled Booking'
           ELSE 'Pending'
       END as status_label
FROM tbookings;

-- Get all confirmed bookings for packages priced between 300,000 and 600,000, ordered by booking date
SELECT b.booking_id, c.customer_name, p.package_name, b.booking_date, b.status
FROM tbookings b
JOIN tcustomers c ON b.customer_id = c.customer_id
JOIN tpackages p ON b.package_id = p.package_id
WHERE b.status = 'Confirmed' AND p.price BETWEEN 350000 AND 700000
ORDER BY b.booking_date;

-- Find customers who have made a booking for a package in 'Georgia' or 'Bali' with their booking status
SELECT c.customer_name, p.package_name, b.status
FROM tbookings b
JOIN tcustomers c ON b.customer_id = c.customer_id
JOIN tpackages p ON b.package_id = p.package_id
WHERE p.destination IN ('Georgia', 'Bali');
 
-- Retrieve booking details and add a custom label based on the amount paid
SELECT b.booking_id, c.customer_name, p.package_name, py.amount,
       CASE
           WHEN py.amount > 500000 THEN 'High Payment'
           ELSE 'Regular Payment'
       END as payment_label
FROM tpayments py
JOIN tbookings b ON py.booking_id = b.booking_id
JOIN tcustomers c ON b.customer_id = c.customer_id
JOIN tpackages p ON b.package_id = p.package_id;

-- Find all packages with at least one confirmed booking:
SELECT p.package_name, p.destination
FROM tpackages p
WHERE EXISTS (SELECT 1 FROM tbookings b WHERE b.package_id = p.package_id AND b.status = 'Confirmed');

-- LIST ALL CUSTOMERS AND THEIR BOOKINGS (left join)
select tc.customer_name,tb.booking_id,tp.package_name,tb.booking_date,tb.status
from tbookings tb
left join tcustomers tc on tb.customer_id = tc.customer_id
left join tpackages tp on tb.package_id = tp.package_id;
 
-- LIST ALL BOOKINGS ALONG WITH PAYMENT DETAILS (right join)
select tb.booking_id,tc.customer_name,tp.package_name,tb.booking_date,
tb.status,tpay.amount,tpay.payment_date,tpay.payment_method from tbookings tb
right join tcustomers tc on tb.customer_id = tc.customer_id
right join tpackages tp on tb.package_id = tp.package_id
right join tpayments tpay on tb.booking_id = tpay.booking_id;

-- UPDATE THE VALUE OF COLUMN 'STATUS' IN TABLE TBOOKINGS
update tbookings set status = "Cancelled" where booking_id = 2;
update tbookings set status = "Cancelled" where booking_id = 4;
select * from tbookings;

-- ALTER THE TABLE BY ADDDING COLUMN AND UPDATING THE VALUES
alter table tcustomers add gender varchar(10);
update tcustomers set gender = "female" where customer_id = "1";
update tcustomers set gender = "female" where customer_id = "2";
update tcustomers set gender = "female" where customer_id = "3";
update tcustomers set gender = "female" where customer_id = "4";
update tcustomers set gender = "male" where customer_id = "5";

-- DELETE THE DATA
delete from tpayments where booking_id=4;

-- VIEW TO SIMPLIFY BOOKING DETAILS
create view bookingdetails as select b.booking_id,p.package_name,b.booking_date,b.status
from tbookings b
join tcustomers c on b.customer_id = c.customer_id
join tpackages p on b.package_id = p.package_id;
select * from bookingdetails;

-- Retrieving the feedback data
SELECT f.feedback_text, f.rating, c.customer_name, p.package_name 
FROM Feedback f
JOIN tcustomers c ON f.customer_id = c.customer_id
JOIN tpackages p ON f.package_id = p.package_id;



