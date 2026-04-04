#!/usr/bin/env python3

import os
import re
import json
import subprocess as cmd
from pathlib import Path

#path = "/etc/rancher/k3s/k3s.yaml"
path = "./test/test.txt"

def parser (key) -> str:
    if os.path.isfile(path) :
        with open(path) as file :
            for line in file :
                if re.search(key+"*",line) :
                        return line.replace(key,'').lstrip()


data ={
     "ca" : parser("certificate-authority-data:"),
     "client" : parser("client-certificate-data:"),
     "key" : parser("client-key-data:")
}

cmd.run(["touch","credential.json"])
with open("credential.json","w") as f :
     json.dump(data,f)

chemin_complet = Path("credential.json").resolve()
cmd.run(["aws", "secretsmanager", "put-secret-value", "--secret-id", "credentials", "--secret-string", f"file://{chemin_complet}"])