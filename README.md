# Bash script miscellanea

Esse repositório contém vários scripts escritos em `bash` com diferentes objetivos. Tem desde um gerador de relatório de sistemas Unix até um jogo da velha. Alguns desses scripts são possíveis soluções para a [track de Bash no Exercism.com](https://exercism.org/tracks/bash).

## Como rodar cada script?

Depois do repositório ter sido replicado na sua máquina, basta executar o nome do script usando `$ ./bash_script.sh` **no diretório que os scripts estão localizados**.

Exemplo:

```bash
# Clone o repositório e acesse o diretório
git clone https://github.com/Pedro-V/bash-script-miscellanea

cd bash-script-miscellanea

# Execute o script
./jogo-da-velha.sh
```

## Lista dos scripts

Abaixo segue o nome e um resumo sobre cada script do repositório.

* `jogo-da-velha.sh` - Um jogo da velha bem simples, com dois modos: contra o computador e versus.
* `loan-calc.sh` - Calculadora de empréstimo dado o montante, juros e duração.
* `report_generator.sh` - Gera um relatório curto do seu sistema Unix. Caso um arquivo seja especificado na execução do programa, abre um arquivo HTML do relatório no `firefox`.
* `acronym.sh` - Recebe uma palavra (ex: "Clube de Regatas do Flamengo") e converte para seu acrônimo (ex: "CRF"). Também contém outras duas shell functions
