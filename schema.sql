drop table if exists accounts;
drop table if exists account_type;
drop table if exists authdetails;
drop table if exists transactions;
drop table if exists transaction_types;

create table authdetails(
	  id integer primary key autoincrement,
	  username string not null,
	  lastlogin integer,
	  password string not null
);

create table account_type(
	id integer,
	type text
);

create table accounts(
	id integer primary key autoincrement, 
	accountid integer,
	accountbalance integer,
	accounttype integer,
	foreign key (accountid) references authdetails(id), 
	foreign key (accounttype) references account_type(id)
);

create table transaction_types(
	id integer,
	type text
);

create table transactions(
	id integer not null,
	transaction_datetime integer not null,
	accountid integer not null,
	transaction_type integer not null,
	transaction_amount,
	balance_after integer,
	transaction_name text,
	foreign key (accountid) references accounts(accountid),
	foreign key (id) references authdetails(id),
	foreign key (transaction_type) references transaction_types(id)
);

insert into authdetails (username, password) values ('john', 'XUFAKrxLKna5cZ2REBfFkg==');
insert into authdetails (username, password) values ('jane', 'XUFAKrxLKna5cZ2REBfFkg==');
insert into authdetails (username, password) values ('jack', 'XUFAKrxLKna5cZ2REBfFkg==');
insert into authdetails (username, password) values ('molly', 'XUFAKrxLKna5cZ2REBfFkg==');
insert into authdetails (username, password) values ('moe', 'XUFAKrxLKna5cZ2REBfFkg==');

insert into account_type (id, type) values (1, 'savings');
insert into account_type (id, type) values (2, 'current');

insert into transaction_types(id, type) values (1, 'debit');
insert into transaction_types(id, type) values (2, 'credit');

insert into accounts (accountid, accountbalance, accounttype) values (1, 500, 1);
insert into accounts (accountid, accountbalance, accounttype) values (2, 100, 1);
insert into accounts (accountid, accountbalance, accounttype) values (3, 9000,1);
insert into accounts (accountid, accountbalance, accounttype) values (4, 500, 1);
insert into accounts (accountid, accountbalance, accounttype) values (5, 500, 1);
insert into accounts (accountid, accountbalance, accounttype) values (1, 500, 2);
insert into accounts (accountid, accountbalance, accounttype) values (2, 500, 2);
insert into accounts (accountid, accountbalance, accounttype) values (3, 500, 2);
insert into accounts (accountid, accountbalance, accounttype) values (4, 500, 2);
insert into accounts (accountid, accountbalance, accounttype) values (5, 500, 2);

insert into transactions (id, transaction_datetime, accountid, transaction_type, transaction_amount, balance_after, transaction_name) values (1, 11123, 1, 1, 100, 400, "ATM Withdrawal");
insert into transactions (id, transaction_datetime, accountid, transaction_type, transaction_amount, balance_after, transaction_name) values (1, 11123, 1, 1, 100, 300, "ATM Withdrawal");
insert into transactions (id, transaction_datetime, accountid, transaction_type, transaction_amount, balance_after, transaction_name) values (1, 11123, 1, 1, 100, 200, "ATM Withdrawal");
insert into transactions (id, transaction_datetime, accountid, transaction_type, transaction_amount, balance_after, transaction_name) values (1, 11123, 1, 1, 100, 100, "ATM Withdrawal");
insert into transactions (id, transaction_datetime, accountid, transaction_type, transaction_amount, balance_after, transaction_name) values (1, 11121, 1, 2, 1, 101, "Interest");
