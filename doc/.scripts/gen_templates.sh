#!/bin/bash
cd .foam/templates

confirm() {
    read -r -p "${1} " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

gen() {
    t=$1
    tn=${2:-$1}

    for f in $(ls {{type}}-*); do
        echo "Processing $f for $t"
        fn=$(echo $f | sed "s/{{type}}/$t/g");
        wrk="$fn.wrk"
        cp $f $wrk
        sed -i.bak "s/{{type}}/$t/g" $wrk
        sed -i.bak "s/{{type_name}}/$tn/g" $wrk

        if [[ -f "$fn" ]]; then
            diff $wrk $fn || confirm "$fn file already exists and it's contents differ. Do you want to continue [y/N]?" || echo "Skipping" && continue
        fi

        mv $wrk $fn
    done
}

for s in home work shared; do
    gen $s
done

# gen '${TM_BLAH}' generic

rm -rf *.wrk
rm -rf *.bak