#!/bin/bash
#--------------------------------------------------------------------------------#
#                                    SV_OPTS                                     #
#--------------------------------------------------------------------------------#
# Setting var for mount parameters
export sv_opts="rw,noatime,compress-force=zstd:1,space_cache=v2"
# "noatime"                    increases performance and reduces SSD writes.
# "compress-force=zstd:1"      is optimal for NVME devices. Omit the :1 to use the default level of 3. Zstd accepts a value range of 1-15, with higher levels trading speed and memory for higher compression ratios.
# "space_cache=v2"             creates cache in memory for greatly improved performance.