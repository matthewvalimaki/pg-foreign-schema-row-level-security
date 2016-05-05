## Initialize
1) Have a Postgres database available
```
docker run --name postgres -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d onjin/alpine-postgres
```
This creates user `postgres` with password `postgres`.

2) Create databases
* Create `customer` database
* Create `microservice1` database

3) Execute `db/security.sql` against the database server.
4) Execute `db/customer.sql` against `customer` database.
5) Execute `db/microservice1.sql` against `microservice1` database.

### Foreign Schema
1) Connect as `postgres` to `microservice1` database.
```
psql -U postgres -W microservice1
```

2) Test foreign schema
Execute the following query against `microservice1` database:
```
SELECT feedback, customer.username, customer.password FROM feedback INNER JOIN customer ON customer.id = feedback.customer_id;
```

Output should be:
```
  feedback  | username |                           password
------------+----------+--------------------------------------------------------------
 Feedback 1 | test     | $2a$06$hQU31q0WMPnv.9I2pVcVZeoEuyIeU2r.4fDXIQhhED9KWhKC1/exm
(1 row)
```

3) Disconnect.

### Row-Level Security
1) Connect as `postgres` to `customer` database.
```
psql -U postgres -W customer
```

2) Test query as super user
Execute the following query against `customer` database:
```
SELECT * FROM customer;
```

Output should be:
```
 id | username |                           password                           | is_system | is_test |            modtime
----+----------+--------------------------------------------------------------+-----------+---------+-------------------------------
  1 | test     | $2a$06$mBIeYWLAmzykrt68cnHQLe6Km.w1ZG1XxdaZMHJvWQoe.44G9pVGq | f         | t       | 2016-05-05 17:00:33.443258+00
  2 | test2    | $2a$06$BbJYZdYZkSPpM.I/L3K9reDVQyqgOu4yHqfllY6qRQjjkgTQ8qYL. | f         | t       | 2016-05-05 17:00:33.443258+00
(2 rows)
```

3) Disconnect.

4) Connect as `test` to `customer` database.
```
psql -U test -W customer
```

Output should be:
```
 id | username |                           password                           | is_system | is_test |            modtime
----+----------+--------------------------------------------------------------+-----------+---------+-------------------------------
  1 | test     | $2a$06$mBIeYWLAmzykrt68cnHQLe6Km.w1ZG1XxdaZMHJvWQoe.44G9pVGq | f         | t       | 2016-05-05 17:00:33.443258+00
(1 row)
```

5) Disconnect.

6) Connect as `test2` to `customer` database.
```
psql -U test2 -W customer
```

Output should be:
```
 id | username |                           password                           | is_system | is_test |            modtime
----+----------+--------------------------------------------------------------+-----------+---------+-------------------------------
  2 | test2    | $2a$06$BbJYZdYZkSPpM.I/L3K9reDVQyqgOu4yHqfllY6qRQjjkgTQ8qYL. | f         | t       | 2016-05-05 17:00:33.443258+00
(1 row)
```

7) Disconnect.

8) Connect as `test3` to `customer` database.
```
psql -U test3 -W customer
```

Output should be:
```
 id | username | is_system | is_test
----+----------+-----------+---------
  3 | test3    | f         | t
(1 row)
```