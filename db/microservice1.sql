CREATE EXTENSION postgres_fdw;

/* Declare connection mapping to a foreign server with foreign server object */
CREATE SERVER foreign_server_customer
        FOREIGN DATA WRAPPER postgres_fdw
        OPTIONS (host 'localhost', port '5432', dbname 'customer');

/* Declare user mapping for each user you want to access the remote server */
CREATE USER MAPPING FOR postgres
        SERVER foreign_server_customer
        OPTIONS (user 'postgres', password 'postgres');
        
/* Import foreign table(s) from remote server */
IMPORT FOREIGN SCHEMA public LIMIT TO (customer)
        FROM SERVER foreign_server_customer INTO public;
        
CREATE TABLE feedback (
    id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL,
    
    feedback TEXT NOT NULL CHECK (feedback <> ''),
    
    modtime timestamptz DEFAULT current_timestamp
);

INSERT INTO feedback (customer_id, feedback) VALUES (1, 'Feedback 1');