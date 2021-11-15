#!/bin/bash

# 
for i in {356..381}
do
    wget $(printf "https://ia802606.us.archive.org/BookReader/BookReaderImages.php?zip=/29/items/mathematischewer01weieuoft/mathematischewer01weieuoft_jp2.zip&file=mathematischewer01weieuoft_jp2/mathematischewer01weieuoft_%04d.jp2&id=mathematischewer01weieuoft&scale=4&rotate=0", $i) -O "./myDownload/Mathematische_Werke_von_Karl_Weierstrass_$i.jpg"
done

