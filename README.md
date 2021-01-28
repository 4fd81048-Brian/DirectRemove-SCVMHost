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

1. Launch SQL Server Management Studio and select your VMM database.
2. New Query with current connection

BACKUP DATABASE VirtualManagerDB TO DISK = 'C:\Support\VirtualManagerDB.bak';

3. Execute the backup
4. New Query with current connection

SELECT [HostID], [ComputerName]
FROM [tbl_ADHC_Host]
WHERE [ComputerName] = 'GBODC-S2D-N2.ad.ugdsb.on.ca'

5. Note the HostID
6. New Query with current connection
7. Paste the Script DirectRemove-SCVMHost script
8. Replace {YourHostID} with the HostID identified above.
9. Execute and review the output for errors.
