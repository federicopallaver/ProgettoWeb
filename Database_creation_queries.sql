CREATE TABLE USERS (
ID INTEGER NOT NULL,
EMAIL VARCHAR(256) NOT NULL,
PASSWORD VARCHAR(32) NOT NULL,
NAME VARCHAR(40),
LASTNAME VARCHAR(40),
ISADMIN BOOLEAN,
AVATAR VARCHAR(32),
CONSTRAINT USERS_PK PRIMARY KEY (ID),
CONSTRAINT USERS_EMAIL_UNIQUE UNIQUE (EMAIL)
);


CREATE TABLE SHOPPING_LISTS (
ID INTEGER NOT NULL,
NAME VARCHAR(40) NOT NULL,
DESCRIPTION VARCHAR(512),
CATEGORY VARCHAR(20) NOT NULL,
IMAGE VARCHAR(32),
CONSTRAINT SHOPPING_LISTS_PK PRIMARY KEY (ID),
CONSTRAINT SHOPPING_LISTS_FK FOREIGN KEY (CATEGORY) REFERENCES SHOPPING_LIST_CATEGORIES (ID) ON DELETE CASCADE
);


CREATE TABLE PRODUCTS (
ID INTEGER NOT NULL,
NAME VARCHAR(32),
NOTES VARCHAR(256),
LOGO VARCHAR(32),
PICTURE VARCHAR(32),
CATEGORY VARCHAR(20) NOT NULL,
CONSTRAINT PRODUCTS_PK PRIMARY KEY (ID),
CONSTRAINT PRODUCTS_FK FOREIGN KEY (CATEGORY) REFERENCES PRODUCT_CATEGORIES (ID) ON DELETE CASCADE
);

CREATE TABLE PRODUCT_CATEGORIES (
ID INTEGER NOT NULL,
NAME VARCHAR(20),
CONSTRAINT PRODUCT_CATEGORIES_PK PRIMARY KEY (ID)
);

CREATE TABLE SHOPPING_LIST_CATEGORIES (
ID INTEGER NOT NULL,
NAME VARCHAR(20),
CONSTRAINT SHOPPING_LIST_CATEGORIES_PK PRIMARY KEY (ID)
);

CREATE TABLE USER_SHOPPING_LISTS (
ID_USER INTEGER NOT NULL,
ID_SHOPPING_LIST INTEGER NOT NULL,
CONSTRAINT USER_SHOPPING_LISTS_PK PRIMARY KEY (ID_USER, ID_SHOPPING_LIST),
CONSTRAINT USER_SHOPPING_LISTS_FK FOREIGN KEY (ID_SHOPPING_LIST) REFERENCES SHOPPING_LISTS (ID) ON DELETE CASCADE,
CONSTRAINT USER_SHOPPING_LISTS_FK FOREIGN KEY (ID_USER) REFERENCES USERS (ID) ON DELETE CASCADE
);
