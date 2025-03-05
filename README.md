# 📌 Guida Step-by-Step: Esecuzione di uno Script Python con HTCondor

Questa guida spiega passo dopo passo come eseguire uno script Python su HTCondor, partendo da un file di esempio. Non serve alcuna conoscenza pregressa: segui ogni passaggio e il tuo job verrà sottomesso con successo! 🚀

---

## **1️⃣ Preparazione del file Bash per eseguire Python**
### 🔹 Cosa abbiamo?
Abbiamo un file di esempio chiamato `examplePy.sh`, che contiene un riferimento generico (`CHANGEME`) che deve essere sostituito con il nome del nostro script Python.

**Esempio di `examplePy.sh`:**
```bash
#!/bin/bash

cd /path/to/your/script_directory

LANG=en_US
LC_NUMERIC=en_US.UTF-8

/path/to/your/conda_environment/bin/python /path/to/your/script_directory/CHANGEME
```

### 🔹 Cosa dobbiamo modificare?

#### **1️⃣ Impostare il percorso corretto della cartella dello script**
Nella riga:
```bash
cd /path/to/your/script_directory
```
Devi sostituire `/path/to/your/script_directory` con il **percorso in cui è salvato il tuo script Python**.

Esempio:
Se la tua struttura di cartelle è questa:
```
/home/user/
│-- my_project/
│   │-- my_script.py
│   │-- dataset/
```
Allora la riga da modificare sarà:
```bash
cd /home/user/my_project
```

#### **2️⃣ Impostare il percorso corretto per l'environment Conda**
Nella riga:
```bash
/path/to/your/conda_environment/bin/python
```
Devi sostituire `/path/to/your/conda_environment/bin/python` con il **path corretto dell'eseguibile Python del tuo environment Conda**.

Per trovare il path del tuo Python Conda, esegui:
```bash
which python
```
all'interno dell'environment corretto.

Esempio:
Se Conda è installato in `/home/user/anaconda3/envs/ml_env/`, la riga diventerà:
```bash
/home/user/anaconda3/envs/ml_env/bin/python
```

Ora il tuo `examplePy.sh` è pronto per essere modificato e salvato!

### 🔹 Creazione del file definitivo
Creiamo un nuovo file in cui sostituiamo `CHANGEME` con il nostro script:

```bash
cat examplePy.sh | sed s/CHANGEME/my_script.py/g > run.my_script.py.sh
```

🔹 **Cosa fa questo comando?**
- `cat examplePy.sh` → Legge il contenuto del file di esempio.
- `sed s/CHANGEME/my_script.py/g` → Sostituisce `CHANGEME` con `my_script.py`.
- `> run.my_script.py.sh` → Salva il risultato in un nuovo file `run.my_script.py.sh`.

Ora abbiamo un file `run.my_script.py.sh` pronto per eseguire Python!

---

## **2️⃣ Rendere lo script Bash eseguibile**
Prima di poterlo eseguire, dobbiamo dargli i permessi di esecuzione:

```bash
chmod +x run.my_script.py.sh
```

🔹 **Cosa fa questo comando?**
- `chmod +x` → Rende il file eseguibile.

Per testarlo, puoi eseguire:
```bash
./run.my_script.py.sh
```
Se tutto è corretto, eseguirà Python con il tuo script!

---

## **3️⃣ Creare il file di submit per HTCondor**
HTCondor non lavora direttamente con gli script Bash, quindi serve un file di configurazione che gli dica cosa fare.

Abbiamo un file di template chiamato `to_submit.sh`, che contiene `CHANGEME` e va modificato.

**Esempio di `to_submit.sh`:**
```bash
#!/bin/bash

universe = vanilla

environment = "JOBID=$(Cluster).$(Process)"

# Specifica lo script Bash che avvia lo script Python
executable = /path/to/your/script_directory/CHANGEME

# Passiamo i parametri nello stile argparse
arguments = "--arg1 a --arg2 b ..."

log = /path/to/your/script_directory/CHANGEME.log
error = /path/to/your/script_directory/CHANGEME.err
output = /path/to/your/script_directory/CHANGEME.out

request_cpus = 16
request_memory = 256G
request_gpus = 1

queue 
```

🔹 **Cosa dobbiamo fare?**
Modifichiamolo con:
```bash
cat to_submit.sh | sed s/CHANGEME/run.my_script.py.sh/g > job.run.my_script.py.sh
```

🔹 **Cosa fa questo comando?**
- `cat to_submit.sh` → Legge il file `to_submit.sh`.
- `sed s/CHANGEME/run.my_script.py.sh/g` → Sostituisce `CHANGEME` con il nostro script.
- `> job.run.my_script.py.sh` → Salva il risultato nel nuovo file `job.run.my_script.py.sh`.

Ora HTCondor sa quale script deve eseguire!

---

## **4️⃣ Caso speciale: Script Python senza argparse**
Se il tuo script **NON ha parametri da argparse**, allora il file `to_submit.sh` deve essere modificato **rimuovendo la linea arguments**.

**Modifica corretta per script senza argparse:**
```bash
#!/bin/bash

universe = vanilla

environment = "JOBID=$(Cluster).$(Process)"

executable = /path/to/your/script_directory/run.my_script.py.sh

log = /path/to/your/script_directory/script.log
error = /path/to/your/script_directory/script.err
output = /path/to/your/script_directory/script.out

request_cpus = 16
request_memory = 256G
request_gpus = 1

queue
```

---

## **5️⃣ Sottomettere il job a HTCondor**
Ora possiamo lanciare il job con:
```bash
condor_submit job.run.my_script.py.sh -name ettore
```

## **Author**

E.C. Amato // AranCi012