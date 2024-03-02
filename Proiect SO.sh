#!/bin/bash

# Numele fișierului CSV
CSV_FILE="parc_auto.csv"

# Funcție pentru crearea fișierului CSV
initialize_csv() {
    echo "ID,Marca,Model,An,Capacitate,Norma,Pret" > "$CSV_FILE"
}

# Funcție pentru generarea unui ID nou
generate_id() {
    local last_id=$(tail -n 1 "$CSV_FILE" | cut -d',' -f1)
    echo $((last_id + 1))
}

# Funcție pentru adăugarea unei noi înregistrări
add_car() {
    local id=$(generate_id)
    local marca
    local model
    local an
    local fuel
    local capacitate
    local norma
    local pret

    echo "Introduceți marca mașinii:"
    read marca
    echo "Introduceți modelul mașinii:"
    read model
    echo "Introduceți anul mașinii:"
    read an
    echo "Introduceți tipul de combustibil:"
    read fuel
    echo "Introduceti capacitatea cilindrica(cc):"
    read capacitate
    echo "Introduceti norma de poluare:"
    read norma
    echo "Introduceti pretul de achizitie (Euro):"
    read pret

    echo "$id,$marca,$model,$an,$fuel,$capacitate,$norma,$pret" >> "$CSV_FILE"
    echo "Mașină adăugată cu succes."
}

# Funcție pentru ștergerea unei înregistrări după ID
delete_car() {
    local id=$1
    sed -i "/^$id,/d" "$CSV_FILE"
    echo "Mașină ștearsă cu succes."
}
# Funcție pentru extragerea, sortearea și limitarea rezultatelor
extract_cars() {
    local numar=$1
    local criteriu=$2

    tail -n +2 "$CSV_FILE" | sort -t',' -k$criteriu -nr | head -n $numar
}

# Funcție pentru actualizarea unei înregistrări după ID
update_car() {
    local id=$1
    local marca
    local model
    local an
    local fuel
    local capacitate
    local norma
    local pret

    echo "Introduceți noile date pentru mașină:"
    echo "Marca (lăsați gol pentru a păstra neschimbat):"
    read marca
    echo "Model (lăsați gol pentru a păstra neschimbat):"
    read model
    echo "An (lăsați gol pentru a păstra neschimbat):"
    read an
    echo "Combustibil (lăsați gol pentru a păstra neschimbat):"
    read fuel
    echo "Capacitate cilindrica:"
    read capacitate
    echo "Norma de poluare"
    read norma
    echo "Pretul de achizitie:"
    read pret

    sed -i "s/^$id,\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\),\([^,]*\)/$id,${marca:-\1},${model:-\2},${an:-\3},${fuel:-\4},${capacitate:-\5},${norma:-\6},${pret:-\7}/" "$CSV_FILE"
    echo "Mașină actualizată cu succes."
# Funcție pentru afișarea meniului și citirea opțiunii utilizatorului
show_menu() {
    while true; do
        echo "=== MENIU ==="
        echo "1. Creare fișier CSV"
        echo "2. Adăugare mașină"
        echo "3. Ștergere mașină"
        echo "4. Extrage, sortează și limitează rezultatele"
        echo "5. Actualizare mașină"
        echo "6. Ieșire"

        read -p "Introduceți opțiunea: " option
        echo

        case $option in
            1)
                initialize_csv
                ;;
            2)
                add_car
                ;;
            3)
                echo "Introduceți ID-ul mașinii pe care doriți să o ștergeți:"
                read id
                delete_car "$id"
                ;;
            4)
                echo "Introduceți numărul de mașini pe care doriți să le extrageți:"
                read numar
                echo "Introduceți criteriul de sortare (1 - Marca, 2 - Model, 3 - An, 4 - Fuel, 5 - capacitate, 6 - norma, 7 - pretul):"
                read criteriu
                extract_cars "$numar" "$criteriu"
                ;;
            5)
                echo "Introduceți ID-ul mașinii pe care doriți să o actualizați:"
                read id
                update_car "$id"
                ;;
            6)
                echo "Programul a fost încheiat."
                exit 0
                ;;
            *)
                echo "Opțiune invalidă. Vă rugăm să selectați o opțiune validă."
                ;;
        esac

        echo
    done
}

# Apelul funcției show_menu pentru a începe programul
show_menu


