CREATE USER 'chronos'@'%'IDENTIFIED WITH mysql_native_password BY 'chronos';
GRANT ALL PRIVILEGES ON *.* TO 'chronos'@'%';
FLUSH PRIVILEGES;
