\timing on

truncate customer;
\copy customer from '/data1/wy/ssb/data/customer.tbl' with (format csv, delimiter ',', header off);

truncate part;
\copy part from '/data1/wy/ssb/data/part.tbl' with (format csv, delimiter ',', header off);

truncate supplier;
\copy supplier from '/data1/wy/ssb/data/supplier.tbl' with (format csv, delimiter ',', header off);

truncate lineorder;
\copy lineorder from '/data1/wy/ssb/data/lineorder.tbl' with (format csv, delimiter ',', header off);
