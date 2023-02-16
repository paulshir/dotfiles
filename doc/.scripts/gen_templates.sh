#!/bin/bash
srcDir=.scripts/templates
destDir=.foam/templates

t=$1
tn=${2:-$1}

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
    pushd $srcDir > /dev/null
    files=$(ls {{type}}-*)
    popd > /dev/null

    for f in $files; do
        file=$srcDir/$f
        fn=$(echo $f | sed "s/{{type}}/$t/g");
        echo "Processing $fn"
        filen=$destDir/$fn
        wrk="$filen.wrk"
        cp $file $wrk
        sed -i.bak "s/{{type}}/$t/g" $wrk
        sed -i.bak "s/{{type_name}}/$tn/g" $wrk

        if [[ -f "$filen" ]]; then
            if ! (diff $wrk $filen || confirm "$fn file already exists and it's contents differ. Do you want to continue [y/N]?"); then
                echo "Skipping"
                continue
            fi
        fi

        mv $wrk $filen
    done
}

gen $t $tn

rm -rf $destDir/*.wrk
rm -rf $destDir/*.bak