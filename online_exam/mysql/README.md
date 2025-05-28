docker run -e "ACCEPT_EULA=Y" \
           -e "SA_PASSWORD=Admin@123" \
           -p 1433:1433 \
           --name sql2022 \
           -v sql2022data:/var/opt/mssql \
           -d mcr.microsoft.com/mssql/server:2022-latest



✅ Connection Details for DataGrip:
Field	Value
Host	localhost (or container IP)
Port	1433
User	sa
Password	YourStrong@Passw0rd (as set in env)
Database	Leave as default or enter master
Driver	SQL Server (Microsoft)


Then, in DataGrip, connect using:

User: sa

Password: YourStrong@Passw0rd
