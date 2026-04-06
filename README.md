# worflow :
#-  terraform plan -out=myplan -target=module.vpc -target=module.ec2 -target=module.rds      ==> to ensure that the dns name to initiale kubernetes providers is available
#-  terraform apply "myplan"
#-  terraform plan -out=myplan -target=module.kubernetes ==> if possible, we can implement an interval of x min before to launch this in the pipeline
#-  terraform apply "myplan"