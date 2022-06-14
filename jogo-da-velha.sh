#!/bin/bash 

#Um script bash para jogar o jogo da velha na CLI.

#Uma base para os espaços do tabuleiro
for i in {0..8}; do 
    free_spaces[i]=$(( "$i" + 1 ))
done

#Essas arrays listam os espaços consumidos/escolhidos por cada jogador.
declare -a consumed_spaces_1
declare -a consumed_spaces_2

#Escolhe um número aleatório que ainda não foi escolhido por ninguém.
take_random(){
    local number
    number=$((1 + $RANDOM % 9))
    until [[ ! " ${consumed_spaces_1[*]} " =~ " ${number} " &&
             ! " ${consumed_spaces_2[*]} " =~ " ${number} " ]]; do
        number=$((1 + $RANDOM % 9))
    done
    echo "$number"
}

#Essa é uma função feia e ineficiente pq eu quis fazer de uma só vez a checagem para ambos os jogadores.
#Essa função basicamente checa se os 3 números passados como argumento estão inclusos na array de algum jogador.
auxiliar(){
    val1=$1 val2=$2 val3=$3
    if [[ " ${consumed_spaces_1[*]} " =~ " ${val1} " &&
    " ${consumed_spaces_1[*]} " =~ " ${val2} " &&
    " ${consumed_spaces_1[*]} " =~ " ${val3} " ]]; then
        echo "True1"

    elif [[ " ${consumed_spaces_2[*]} " =~ " ${val1} " &&
    " ${consumed_spaces_2[*]} " =~ " ${val2} " &&
    " ${consumed_spaces_2[*]} " =~ " ${val3} " ]]; then
        echo "True2"
    fi
}

check_winner(){
    #Checa as linhas do tabuleiro
    for i in 1 4 7; do
        auxiliar $i $((i+1)) $((i+2))
    done
    #Checa as colunas do tabuleiro
    for i in 1 2 3; do
        auxiliar $i $((i+3)) $((i+6))
    done
    #Checa uma possível vitória cruzada
    auxiliar 1 5 9
    auxiliar 3 5 7
}

quad="
  1 | 2 | 3
 ---+---+---
  4 | 5 | 6
 ---+---+---
  7 | 8 | 9
"

#Parte principal
clear
echo "
Bem vindo ao jogo da velha no bash. Aqui você receberá um tabuleiro dessa forma:
$quad
e poderá jogar contra o computador ou contra um amigo localmente.
Lembre-se que a qualquer momento você pode cancelar o script usando CTRL-c

Para começar, devemos saber qual modo você deseja:
C - Computador
V/* - Versus
"
modo=
#Nome dos jogadores. No modo computador, o name2 se torna "computador"
name1=
name2=
#As marks são X ou O
mark1=
mark2=
read -r modo

#Identificação
if [[ ${modo^^} == "C" || ${modo^^} == "COMPUTADOR" ]]; then
    modo="C"
    echo "Muito bem, o modo escolhido foi contra o computador!
    "
    echo "Qual o nome do jogador?"
    read -r name1
    name2="computador"
else 
    echo "Muito bem, o modo escolhido foi versus!"
    echo "Qual o nome do jogador 1?"
    read -r name1
    echo "Qual o nome do jogador 2?"
    read -r name2
fi

#Marcas
echo "$name1, qual marca você escolhe: X ou O?"
read -r mark1
until [[ $mark1 == "X" || $mark1 == "O" ]]; do 
    echo "Insira um valor dentre X ou O"
    read -r mark1
done
if [[ $mark1 == "X" ]]; then
    mark2="O"
else
    mark2="X"
fi
echo "Estamos prontos para começar!"
sleep 3

while (( ${#free_spaces[@]} > 0 )); do
    clear
    echo "Escolha um dos números disponíveis para marcar o local.
    $quad"
    echo "Vez de $name1"
    read -r val1
    until [[  " ${free_spaces[*]} " =~ " ${val1} " ]]; do 
        echo "Quadrado já escolhido. Insira um valor dentre os disponíveis no quadro
        $quad"
        read -r val1
    done
    quad=${quad//$val1/$mark1}
    unset "free_spaces[$val1 - 1]"
    consumed_spaces_1+=("$val1")
    echo "$quad"
    echo "Vez de $name2"
    #Computador escolhe um número do tabuleiro
    if [[ ( $modo == "C" || $modo == "c" ) && ${#free_spaces[@]} -gt 0 && $(check_winner) == "" ]]; then
        sleep 2
        val2="$(take_random)"
        quad=${quad//$val2/$mark2}
        unset "free_spaces[$val2 - 1]"
        consumed_spaces_2+=("$val2")
    elif [[ ${#free_spaces[@]} -gt 0 && $(check_winner) == "" ]]; then
        read -r val2
        until [[  " ${free_spaces[*]} " =~ " ${val2} " ]]; do 
            echo "Insira um valor dentre os disponíveis no quadro
            $quad"
            read -r val2
        done
        quad=${quad//$val2/$mark2}
        unset "free_spaces[$val2 - 1]"
        consumed_spaces_2+=("$val2")
    fi
    if [[ $(check_winner) == "True1" ]]; then
        clear
        echo "$quad"
        echo "Fim de jogo, $name1 ganhou! Parabéns"
        break
    elif [[ $(check_winner) == "True2" ]]; then
        clear
        echo "$quad"
        echo "Fim de jogo, $name2 ganhou!"
        break
    elif [[ $(check_winner) == "" && ${#free_spaces[@]} == 0 ]]; then
        clear
        echo "$quad"
        echo "Deu empate!"
        break
    fi

done
