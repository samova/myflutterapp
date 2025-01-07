DROP TABLE IF EXISTS catemaster;
DROP TABLE IF EXISTS recorddata;
DROP TABLE IF EXISTS icontable;

CREATE TABLE catemaster (
    cateid TEXT PRIMARY KEY,
    catetype TEXT NOT NULL,
    category TEXT NOT NULL,
    icon TEXT NOT NULL,
    budget INTEGER NOT NULL
);
CREATE TABLE recorddata (
    recordid TEXT PRIMARY KEY,
    catetype TEXT NOT NULL,
    category TEXT NOT NULL,
    amount INTEGER NOT NULL,
    date TEXT NOT NULL,
    note TEXT NOT NULL
);

CREATE TABLE iconmaster(icon TEXT PRIMARY KEY);