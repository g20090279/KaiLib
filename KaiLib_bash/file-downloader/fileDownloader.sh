#!/bin/bash

bookName="1960-Muir-The_theory_of_determinants_in_the_historical_order_of_development"
filename="Muir_the_theory_of_determinants"

if [ ! -d "$bookName" ]; then
    mkdir "$bookName"
fi

# 
for i in {1..1016}
do
    # echo "./$bookName/$fileName_$i.jpg";
    wget $(printf "https://ia600201.us.archive.org/BookReader/BookReaderImages.php?zip=/17/items/theoryofdetermin01muiruoft/theoryofdetermin01muiruoft_jp2.zip&file=theoryofdetermin01muiruoft_jp2/theoryofdetermin01muiruoft_%04d.jp2&id=theoryofdetermin01muiruoft&scale=2&rotate=0", $i) -O "./$bookName/$fileName_$i.jpg"
done

