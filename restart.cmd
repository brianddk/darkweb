@echo off
set username=%1
set vmname=%2
call gcloud compute ssh %username%@%vmname% --command "sudo shutdown now"
call gcloud compute instances tail-serial-port-output %vmname%
call gcloud compute instances list
call gcloud compute instances start %vmname% --async
