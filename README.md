# 📌 Guida Step-by-Step: Esecuzione di uno Script Python con HTCondor

Questa guida spiega passo dopo passo come eseguire uno script Python su HTCondor, partendo da un file di esempio. Non serve alcuna conoscenza pregressa: segui ogni passaggio e il tuo job verrà sottomesso con successo! 🚀

---

## **1️⃣ Preparazione del file Bash per eseguire Python**
### 🔹 Cosa abbiamo?
Abbiamo un file di esempio chiamato `_examplePy.sh`, che contiene un riferimento generico (`CHANGEME`) che deve essere sostituito con il nome del nostro script Python.

**Esempio di `_examplePy.sh`:**
```bash
#!/bin/bash

cd /lustrehome/nome_utente/directory_script

#come per attivare l'environment surv
#conda activate surv

LANG=en_US
LC_NUMERIC=en_US.UTF-8

/lustrehome/nome_utente/.conda/envs/nome_environment/bin/python /lustrehome/nome_utente/directory_script/CHANGEME
```

Il problema è che `CHANGEME` deve essere sostituito con il vero nome dello script Python (es. `train_on_recas.py`).

### 🔹 Cosa dobbiamo fare?
Creiamo un nuovo file in cui sostituiamo `CHANGEME` con il nostro script:

```bash
cat _examplePy.sh | sed s/CHANGEME/train_on_recas.py/g > run.train_on_recas.py.sh
```

🔹 **Cosa fa questo comando?**
- `cat _examplePy.sh` → Legge il contenuto del file di esempio.
- `sed s/CHANGEME/train_on_recas.py/g` → Sostituisce `CHANGEME` con `train_on_recas.py`.
- `> run.train_on_recas.py.sh` → Salva il risultato in un nuovo file `run.train_on_recas.py.sh`.

Ora abbiamo un file `run.train_on_recas.py.sh` pronto per eseguire Python!

---

## **2️⃣ Rendere lo script Bash eseguibile**
Prima di poterlo eseguire, dobbiamo dargli i permessi di esecuzione:

```bash
chmod +x run.train_on_recas.py.sh
```

🔹 **Cosa fa questo comando?**
- `chmod +x` → Rende il file eseguibile.

Per testarlo, puoi eseguire:
```bash
./run.train_on_recas.py.sh
```
Se tutto è corretto, eseguirà Python con il tuo script!

---

## **3️⃣ Creare il file di submit per HTCondor**
HTCondor non lavora direttamente con gli script Bash, quindi serve un file di configurazione che gli dica cosa fare.

Abbiamo un file di template chiamato `to_submit`, che contiene `CHANGEME` e va modificato.

Modifichiamolo con:
```bash
cat to_submit | sed s/CHANGEME/run.train_on_recas.py.sh/g > job.run.train_on_recas.py.sh
```

🔹 **Cosa fa questo comando?**
- `cat to_submit` → Legge il file `to_submit`.
- `sed s/CHANGEME/run.train_on_recas.py.sh/g` → Sostituisce `CHANGEME` con il nostro script.
- `> job.run.train_on_recas.py.sh` → Salva il risultato nel nuovo file `job.run.train_on_recas.py.sh`.

Ora HTCondor sa quale script deve eseguire!

---

## **4️⃣ Sottomettere il job a HTCondor**
Ora possiamo lanciare il job con:
```bash
condor_submit job.run.train_on_recas.py.sh -name ettore
```

🔹 **Cosa fa questo comando?**
- `condor_submit job.run.train_on_recas.py.sh` → Sottomette il job.
- `-name ettore` → Specifica il nodo di computing "ettore".

Se tutto è corretto, il tuo job partirà e verrà eseguito su HTCondor! 🎉

---

## **5️⃣ Debugging: Cosa fare se non funziona?**
Se il job non parte, usa questi comandi per capire il problema:

🔹 **Vedere la coda dei job:**
```bash
condor_q
```

🔹 **Analizzare il problema:**
```bash
condor_q -better-analyze <JOB_ID>
```
(Sostituisci `<JOB_ID>` con l'ID del tuo job)

🔹 **Vedere i log del job:**
```bash
cat script.out  # Output del job
cat script.err  # Errori del job
cat script.log  # Log del job
```

---

## **✅ Riepilogo veloce**
1️⃣ **Prepariamo lo script Bash**
   ```bash
   cat _examplePy.sh | sed s/CHANGEME/train_on_recas.py/g > run.train_on_recas.py.sh
   chmod +x run.train_on_recas.py.sh
   ```

2️⃣ **Creiamo il file di submit per HTCondor**
   ```bash
   cat to_submit | sed s/CHANGEME/run.train_on_recas.py.sh/g > job.run.train_on_recas.py.sh
   ```

3️⃣ **Sottomettiamo il job a HTCondor**
   ```bash
   condor_submit job.run.train_on_recas.py.sh -name ettore
   ```

Ora sei pronto per far girare i tuoi job su HTCondor! 🚀🔥

Se hai problemi, controlla i log e la coda dei job con `condor_q` e `cat script.err`. Se hai bisogno di aiuto, contattami! 😊

