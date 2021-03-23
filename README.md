# DirectRemove-SCVMHost
TSQL Script to manually remove an orphaned host or cluster from VMM

THIS WILL DELETE DATA FROM THE VMM DATABASE

NO GUARANTEES OR WARRANTIES

YOU MUST KNOW HOW TO BACKUP AND RESTORE YOUR VMM DATABASE

This script contains my additions as of 2021-01-20 and VMM 2019 to the script originally published at these sites, with all the same disclaimers and caveats

https://helshabini.wordpress.com/2011/11/14/manually-remove-hyper-v-host-cluster-from-scvmm-2012-database/

https://www.miru.ch/how-to-manually-remove-a-host-from-scvmm-2012-sp1/

https://philipflint.com/2017/07/24/how-to-delete-a-host-that-is-in-pending-state-in-scvmm/

To run this script

1. Stop the VMM Service
2. Launch SQL Server Management Studio and select your VMM database.
3. New Query with current connection

BACKUP DATABASE VirtualManagerDB TO DISK = 'C:\Support\VirtualManagerDB.bak';

4. Execute the backup
5. New Query with current connection

SELECT [HostID], [ComputerName]
FROM [tbl_ADHC_Host]
WHERE [ComputerName] = '{host name}'

6. Note the HostID
7. New Query with current connection
8. Paste the Script DirectRemove-SCVMHost script
9. Replace {YourHostID} with the HostID identified above.
10. Execute and review the output for errors.

11. Restart the VMM Service
