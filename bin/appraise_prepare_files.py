#!/usr/bin/env python3

"""
Prepares files that can be imported into Appraise for relative ranking.
Output: 1 file per document in each WMT19's testset targeted (DE->EN, EN->DE and EN->RU).
"""

from bs4 import BeautifulSoup
import os
import subprocess


idir = "../data/wmt/"
odir = "../data/appraise_import/"


def clean_text(sgml_doc):
    text = sgml_doc.get_text()
    clean_text = os.linesep.join([s for s in text.splitlines() if s])
    clean_text = clean_text.replace("&", "&amp;") # there are some '&' characters. Appraise's importer does not convert them
    return clean_text


def dummy_ref(input):
    """Create a dummy reference (NA in each line) with as many lines as the input file."""
    return os.linesep.join(["NA" for s in input.splitlines()])



def prep_files_3way(sl, tl, f_sl, f_ht, f_mt):
    sl_f = "" # source text
    tl_ht = "" # human translation
    tl_mt = "" # machine translation
    
    lidir = idir + sl + tl + "/"

    with open(lidir + f_sl, 'r') as inf:
        sl_f=inf.read()
    with open(lidir + f_ht, 'r') as inf:
        tl_ht=inf.read()
    with open(lidir + f_mt, 'r') as inf:
        tl_mt=inf.read()
    

    soup_sl = BeautifulSoup(sl_f, 'html.parser')
    soup_ht = BeautifulSoup(tl_ht, 'html.parser')
    soup_mt = BeautifulSoup(tl_mt, 'html.parser')

    docs_sl = soup_sl.find_all("doc")
    docs_ht = soup_ht.find_all("doc")
    docs_mt = soup_mt.find_all("doc")


    print(len(docs_ht))
    doc_ids = list(range(1,len(docs_ht)+1))
    len(doc_ids)
    print(doc_ids)


    counter=-1
    for doc_sl, doc_ht, doc_mt in zip(docs_sl, docs_ht, docs_mt):
        counter+=1
        doc_id = doc_ht['docid']
        doc_lang = doc_ht['origlang']
        #doc_id2 = str(doc_ids[counter]).zfill(3) + "_" + doc_id + "_" + doc_lang
        doc_id2 = sl + tl + "_" + str(doc_ids[counter]).zfill(3) + "_" + doc_id
        print(doc_id2)

        with open(odir + doc_id2 + ".sl", "w") as text_file:
            print(clean_text(doc_sl), file=text_file)
        with open(odir + doc_id2 + ".tl", "w") as text_file:
            print(dummy_ref(clean_text(doc_ht)), file=text_file)
        with open(odir + doc_id2 + ".ht", "w") as text_file:
            print(clean_text(doc_ht), file=text_file)
        with open(odir + doc_id2 + ".mt", "w") as text_file:
            print(clean_text(doc_mt), file=text_file)

        result = subprocess.run('python ../third/build_xml3.py -id w19_' + sl + tl + \
        ' -source ' + sl + ' -target ' + tl + ' ' + \
        odir + doc_id2 + '.sl ' + odir + doc_id2 + '.tl ' \
        + odir + doc_id2 + '.ht ' + odir + doc_id2 + '.mt > ' \
        + odir + "appraise-ranking-w19-" + doc_id2 + ".xml 2> " \
        + odir + "appraise-ranking-w19-" + doc_id2 + ".err",
        shell=True)
        #break


# TODO refactorise: most of the code in this function duplicated from prep_files_3way
def prep_files_4way(sl, tl, f_sl, f_ref, f_ht, f_mt):
    sl_f = "" # source text
    tl_ref = "" # human translation (reference at WMT. The evaluation was monolingual for de->en)
    tl_ht = "" # human translation (evaluated at WMT)
    tl_mt = "" # machine translation
    
    lidir = idir + sl + tl + "/"

    with open(lidir + f_sl, 'r') as inf:
        sl_f=inf.read()
    with open(lidir + f_ref, 'r') as inf:
        tl_ref=inf.read()
    with open(lidir + f_ht, 'r') as inf:
        tl_ht=inf.read()
    with open(lidir + f_mt, 'r') as inf:
        tl_mt=inf.read()
    


    soup_sl = BeautifulSoup(sl_f, 'html.parser')
    soup_ref = BeautifulSoup(tl_ref, 'html.parser')
    soup_ht = BeautifulSoup(tl_ht, 'html.parser')
    soup_mt = BeautifulSoup(tl_mt, 'html.parser')

    docs_sl = soup_sl.find_all("doc")
    docs_ref = soup_ref.find_all("doc")
    docs_ht = soup_ht.find_all("doc")
    docs_mt = soup_mt.find_all("doc")


    print(len(docs_ref))
    print(len(docs_ht))
    doc_ids = list(range(1,len(docs_ht)+1))
    len(doc_ids)
    print(doc_ids)


    counter=-1
    for doc_sl, doc_ref, doc_ht, doc_mt in zip(docs_sl, docs_ref, docs_ht, docs_mt):
        counter+=1
        doc_id = doc_ht['docid']
        doc_lang = doc_ht['origlang']
        #doc_id2 = str(doc_ids[counter]).zfill(3) + "_" + doc_id + "_" + doc_lang
        doc_id2 = sl + tl + "_" + str(doc_ids[counter]).zfill(3) + "_" + doc_id
        print(doc_id2)

        with open(odir + doc_id2 + ".sl", "w") as text_file:
            print(clean_text(doc_sl), file=text_file)
        with open(odir + doc_id2 + ".tl", "w") as text_file:
            print(dummy_ref(clean_text(doc_ht)), file=text_file)
        with open(odir + doc_id2 + ".ref", "w") as text_file:
            print(clean_text(doc_ref), file=text_file)
        with open(odir + doc_id2 + ".ht", "w") as text_file:
            print(clean_text(doc_ht), file=text_file)
        with open(odir + doc_id2 + ".mt", "w") as text_file:
            print(clean_text(doc_mt), file=text_file)

        result = subprocess.run('python ../third/build_xml3.py -id w19_' + sl + tl + \
        ' -source ' + sl + ' -target ' + tl + ' ' + \
        odir + doc_id2 + '.sl ' + odir + doc_id2 + '.tl ' \
        + odir + doc_id2 + '.ref ' \
        + odir + doc_id2 + '.ht ' + odir + doc_id2 + '.mt > ' \
        + odir + "appraise-ranking-w19-" + doc_id2 + ".xml 2> " \
        + odir + "appraise-ranking-w19-" + doc_id2 + ".err",
        shell=True)
        #break

    
    
    

sl="en"
tl="de"
f_sl="newstest2019-ende-src.en.sgm"
f_ht="newstest2019-ende-ref.de.sgm"
f_mt="newstest2019.Facebook_FAIR.6862.en-de.sgm"
prep_files_3way(sl, tl, f_sl, f_ht, f_mt)

sl="en"
tl="ru"
f_sl="newstest2019-enru-src.en.sgm"
f_ht="newstest2019-enru-ref.ru.sgm"
f_mt="newstest2019.Facebook_FAIR.6724.en-ru.sgm"
prep_files_3way(sl, tl, f_sl, f_ht, f_mt)

sl="de"
tl="en"
f_sl="newstest2019-deen-src.de.sgm"
f_ref="newstest2019-deen-ref.en.sgm"
f_mt="newstest2019.Facebook_FAIR.6750.de-en.sgm"
f_ht="wmt19.newstest2019.HUMAN.de-en.sgm"
prep_files_4way(sl, tl, f_sl, f_ref, f_ht, f_mt)

