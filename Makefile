deploy:
	cd src && zip -r ../src.zip . && cd ..	
	terraform plan
	terraform apply -auto-approve