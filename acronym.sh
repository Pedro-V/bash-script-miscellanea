#!/bin/bash

# Essa shell function recebe um número e adiciona retorna Pling se for
# divisível por 3, Plang se for por 5 e Plong se for por 7.
# Retorna o próprio número caso não for divisível por ninguém.
raindrops () {
    (( $1 % 3 )) || result+=Pling
    (( $1 % 5 )) || result+=Plang
    (( $1 % 7 )) || result+=Plong
    echo ${result:-$1}
}

# Mensagem de erro genérica citando o nome do próprio script
error () {
  printf "Usage: ${0##*/} %s\n" "$*"
  exit 1
}

# Retire o # da linha abaixo para executar a função raindrops
#raindrops "$@"

# Calcula a diferença de Hamming entre duas strannds de DNA
hamming() {
    (( $# != 2 )) && error '<string1> <string2>'
    a=$1 b=$2
    (( ${#a} != ${#b} )) && error 'left and right strands must be of equal length'

    declare -i count
    for (( i=0; i< ${#a}; i++ )); do
        [[ "${a:i:1}" != "${b:i:1}" ]] && count+=1
    done

    printf '%d\n' "$count"
}

#hamming 'AATG' 'AAAA'

# Recebe uma frase e retorna o acrônimo dessa frase
# ex: Clube de Regatas do Flamengo -> CRF
acronym() {
    acro=
    cleaned=$*
    cleaned=${cleaned//[_-]/' '}
    cleaned=${cleaned//[[:punct:]]/''}
    cleaned="$(echo "$cleaned" | sed -e 's/d[aeo]s/\x0/g' -e 's/d[aeo]/\x0/g')" # Exclui palavras como dos, da, de...
    cleaned=${cleaned//of/''} #exclui "of"
    # A decisão de escrever várias substituições foi para deixar mais claro
    # a compreensão das REGEX

    for (( i=1; i<=$(echo "$cleaned" | wc -w); i++ )); do
        word="$(echo "$cleaned" | awk -v vawk="$i" '{print $vawk;}')"
        word=${word^}
        acro+=${word:0:1}
    done

    echo "$acro"

}

#acronym "Clube de Regatas do Flamengo"