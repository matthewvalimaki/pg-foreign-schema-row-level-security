CREATE EXTENSION pgcrypto;

CREATE TABLE customer (
	id SERIAL PRIMARY KEY,
    username VARCHAR(40) NOT NULL CHECK (username <> ''),
	password TEXT NOT NULL CHECK (password <> ''),

	is_system BOOLEAN NOT NULL DEFAULT FALSE,
	is_test BOOLEAN NOT NULL DEFAULT FALSE,
	
	modtime timestamptz DEFAULT current_timestamp
);
ALTER TABLE customer ENABLE ROW LEVEL SECURITY;

GRANT ALL PRIVILEGES ON TABLE customer to test;
GRANT ALL PRIVILEGES ON TABLE customer to test2;
GRANT SELECT (id, username, is_system, is_test) ON customer TO test3;

/* Insert customer whom `id` will become 1 */
INSERT INTO customer (username, password, is_test) VALUES ('test', crypt('Abc@1234', gen_salt('bf')), TRUE);

/* Insert customer whom `id` will become 2 */
INSERT INTO customer (username, password, is_test) VALUES ('test2', crypt('Abc@1234', gen_salt('bf')), TRUE);

/* Insert customer whom `id` will become 3 */
INSERT INTO customer (username, password, is_test) VALUES ('test3', crypt('Abc@1234', gen_salt('bf')), TRUE);

CREATE POLICY policy_customer_log ON customer
    FOR ALL
    TO PUBLIC
    USING (username = current_user);
