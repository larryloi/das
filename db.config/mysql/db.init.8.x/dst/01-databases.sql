CREATE USER 'chronos'@'%'IDENTIFIED WITH mysql_native_password BY 'chronos';
GRANT ALL PRIVILEGES ON *.* TO 'chronos'@'%';
FLUSH PRIVILEGES;
CREATE USER 'i2'@'%'IDENTIFIED WITH mysql_native_password BY 'i2';
GRANT ALL PRIVILEGES ON *.* TO 'i2'@'%';
FLUSH PRIVILEGES;
CREATE USER 'aino'@'%'IDENTIFIED WITH mysql_native_password BY 'aino';
GRANT ALL PRIVILEGES ON *.* TO 'aino'@'%';
FLUSH PRIVILEGES;
