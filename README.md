# DirectRemove-SCVMHost
TSQL Script to manually remove an orphaned host or cluster from VMM

THIS WILL DELETE DATA FROM THE VMM DATABASE

NO GUARANTEES OR WARRANTIES

YOU MUST KNOW HOW TO BACKUP AND RESTORE YOUR VMM DATABASE

This script contains my additions as of 2021-01-20 and VMM 2019 to the script originally published at these sites, with all the same disclaimers and caveats

https://helshabini.wordpress.com/2011/11/14/manually-remove-hyper-v-host-cluster-from-scvmm-2012-database/

https://www.miru.ch/how-to-manually-remove-a-host-from-scvmm-2012-sp1/

To run this script
Launch SQL Server Management Studio and select your VMM database.
Expand Tables, select dbo.tbl_ADHC_Host and right-click and choose Select top 1000 rows.  Find the GUID for the host to be deleted

Create a new Query and backup the database

-- To backup the database (replace "VirtualManagerDB" with your VMM Database name and "C:\Support" with a folder name to store the backup). Then copy the backup somewhere else.

BACKUP DATABASE VirtualManagerDB TO DISK = 'C:\Support\VirtualManagerDB.bak';

GO

Create a new query and copy/paste the script comments replacing "VirtualManagerDB" with your VMM Database name and replacing YourHostGUID with the HostGUID identified above.
Execute and review the output for errors.
