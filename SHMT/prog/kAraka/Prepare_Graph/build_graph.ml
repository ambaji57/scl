(* Copyright: Amba Kulkarni (2014-17) Sanjeev Panchal (2015-17)  *)
(* 2015-17: Indian Institute of Advanced Study, Shimla           *)



open Scanf;

open Pada_structure; (* corresponds to clips_head.txt *)

open Bank_lexer; 
module Gram = Camlp4.PreCast.MakeGram Bank_lexer 
;
open Bank_lexer.Token;

open Constraint;

value morphs = Gram.Entry.mk "morphs"
;

(* Global Variables *)
value finite_verb_in_sentence = ref 1000; 
value iwi_pos = ref 1000;  (* Assumption: A sentence has less than 1000 words *)
(*value evam_pos = ref 1000;*)  (* Assumption: A sentence has less than 1000 words *)
value yaxA_pos = ref 1000; 
value yaWA_pos = ref 1000; 
value waWA_pos = ref 1000; 
value waxA_pos = ref 1000; 
value yawra_pos = ref 1000; 
value wawra_pos = ref 1000; 
value yaxi_pos = ref 1000; 
value warhi_pos = ref 1000; 
value waw_pos = ref 1000; 
value cew_pos = ref 1000;
value yawaH_pos = ref 1000; 
value awaH_pos = ref 1000; 
value wawaH_pos = ref 1000; 
value yaxyapi_pos = ref 1000;
value waWApi_pos = ref 1000; 
value aWApi_pos = ref 1000; 
value yAvaw_pos = ref 1000;
value wAvaw_pos = ref 1000; 
value kinwu_pos = ref 1000; 
value paranwu_pos = ref 1000; 
value aWa_pos = ref 1000; 
value yaw_pos = ref 1000; 
value yasmAw_pos = ref 1000; 
value wasmAw_pos = ref 1000; 
value hi_pos = ref 1000; 
value yax_pos = ref 1000; 
value total_wrds = ref 0; 

value datapath = "SCLINSTALLDIR/SHMT/prog/kAraka/Prepare_Graph/DATA/";

(* Grammar of morph_analyses coming from sentence *)

EXTEND Gram
  GLOBAL: morphs;
  morphs:
    [ [ l = morph_rec; `EOI -> l
      | l = morph_rec -> failwith "Wrong morph data"
    ] ] ;
  morph_rec:
    [ [ -> []
      | l = morph_rec; t = morph ->  (* left (terminal) recursion essential *)
    l @ [ t ]
    ] ] ;
  morph:
    [ [ s = sup -> Sup s 
      | w = wif -> Wif w 
      | k = kqw -> Kqw k
      | a = avy -> Avy a
      | aw = avywaxXiwa -> AvywaxXiwa aw
      | ak = avykqw -> Avykqw ak
      | w = waxXiwa -> WaxXiwa w
    ] ] ;

  sup:
    [ [ "(sup"; "(id"; i = INT; ")"; 
        "(mid"; m = INT; ")"; 
        "(word"; w = IDENT; ")"; 
        "(rt"; r = IDENT; ")"; 
        "(pUrvapaxa"; cp = IDENT; ")"; 
        "(uwwarapaxa"; cu = IDENT; ")"; 
        "(lifgam"; ling = IDENT; ")"; 
        "(viBakwiH"; vib = INT; ")"; 
        "(vacanam"; vac = IDENT; ")"; 
        "(level"; lev = INT; ")";
    ")" -> 
    (int_of_string i,int_of_string m,w,r,cp,cu,ling,int_of_string vib,vac,int_of_string lev)
    ] ] ;

  wif:
    [ [ "(wif"; "(id"; i = INT; ")"; 
        "(mid"; m = INT; ")"; 
        "(word"; w = IDENT; ")"; 
        "(rt"; r = IDENT; ")"; 
        "(pUrvapaxa"; cp = IDENT; ")"; 
        "(uwwarapaxa"; cu = IDENT; ")"; 
        "(upasarga"; upa = IDENT; ")"; 
        "(sanAxi_prawyayaH"; san = IDENT; ")"; 
        "(prayogaH"; voice = IDENT; ")"; 
        "(lakAraH"; la = IDENT; ")"; 
        "(puruRaH"; per = IDENT; ")"; 
        "(vacanam"; vac = IDENT; ")"; 
        "(paxI"; padi = IDENT; ")"; 
        "(XAwuH"; rtwithiw = IDENT; ")"; 
        "(gaNaH"; gana = IDENT; ")"; 
        "(level"; lev = INT; ")";
    ")" -> 
    (int_of_string i,int_of_string m,w,r,cp,cu,upa,san,voice,la,per,vac,padi,rtwithiw,gana,int_of_string lev)
    ] ] ;

  kqw:
    [ [ "(kqw"; "(id"; i = INT; ")"; 
        "(mid"; m = INT; ")"; 
        "(word"; w = IDENT; ")"; 
        "(kqw_vrb_rt"; kqwrt = IDENT; ")"; 
        "(upasarga"; upa = IDENT; ")"; 
        "(sanAxi_prawyayaH"; san = IDENT; ")"; 
        "(kqw_prawyayaH"; kp = IDENT; ")"; 
        "(prayogaH"; p = IDENT; ")"; 
        "(XAwuH"; rtwithiw = IDENT; ")"; 
        "(gaNaH"; gana = IDENT; ")"; 
        "(rt"; r = IDENT; ")"; 
        "(pUrvapaxa"; cp = IDENT; ")"; 
        "(uwwarapaxa"; cu = IDENT; ")"; 
        "(lifgam"; ling = IDENT; ")"; 
        "(viBakwiH"; vib = INT; ")"; 
        "(vacanam"; vac = IDENT; ")"; 
        "(level"; lev = INT; ")";
    ")" -> 
    (int_of_string i,int_of_string m,w,kqwrt,upa,san,kp,p,rtwithiw,gana,r,cp,cu,ling,int_of_string vib,vac,int_of_string lev)
    ] ] ;

  avy:
    [ [ "(avy"; "(id"; i = INT; ")"; 
        "(mid"; m = INT; ")"; 
        "(word"; w = IDENT; ")"; 
        "(rt"; r = IDENT; ")"; 
        "(pUrvapaxa"; cp = IDENT; ")"; 
        "(uwwarapaxa"; cu = IDENT; ")"; 
        "(level"; lev = INT; ")";")" -> 
    (int_of_string i,int_of_string m,w,r,cp,cu,int_of_string lev)
    ] ] ;

  avywaxXiwa:
    [ [ "(avywaxXiwa"; "(id"; i = INT; ")"; 
               "(mid"; m = INT; ")"; 
               "(word"; w = IDENT; ")"; 
               "(rt"; r = IDENT; ")"; 
               "(pUrvapaxa"; cp = IDENT; ")"; 
               "(uwwarapaxa"; cu = IDENT; ")"; 
               "(waxXiwa_prawyayaH"; taddhita = IDENT; ")"; 
               "(level"; lev = INT; ")";
    ")" -> 
    (int_of_string i,int_of_string m,w,r,cp,cu,taddhita,int_of_string lev)
    ] ] ;

  avykqw:
    [ [ "(avykqw"; "(id"; i = INT; ")"; 
           "(mid"; m = INT; ")"; 
           "(word"; w = IDENT; ")"; 
           "(rt"; r = IDENT; ")"; 
           "(pUrvapaxa"; cp = IDENT; ")"; 
           "(uwwarapaxa"; cu = IDENT; ")"; 
           "(upasarga"; upa = IDENT; ")";
           "(sanAxi_prawyayaH"; san = IDENT; ")";
           "(kqw_prawyayaH"; kqw = IDENT; ")"; 
           "(XAwuH"; rtwithiw = IDENT; ")"; 
           "(gaNaH"; gana = IDENT; ")"; 
           "(level"; lev = INT; ")";
     ")" -> 
    (int_of_string i,int_of_string m,w,r,cp,cu,upa,san,kqw,rtwithiw,gana,int_of_string lev)
    ] ] ;

  waxXiwa:
    [ [ "(waxXiwa"; "(id"; i = INT; ")"; 
            "(mid"; m = INT; ")"; 
            "(word"; w = IDENT; ")"; 
            "(rt"; r = IDENT; ")"; 
            "(pUrvapaxa"; cp = IDENT; ")"; 
            "(uwwarapaxa"; cu = IDENT; ")"; 
            "(waxXiwa_rt"; taddhitart = IDENT; ")"; 
            "(waxXiwa_prawyayaH"; taddhita = IDENT; ")"; 
            "(lifgam"; ling = IDENT; ")"; 
            "(viBakwiH"; vib = INT; ")"; 
            "(vacanam"; vac = IDENT; ")";
            "(level"; lev = INT; ")";
    ")" -> 
    (int_of_string i,int_of_string m,w,r,cp,cu,taddhita,taddhitart,ling,int_of_string vib,vac,int_of_string lev)
    ] ] ;
END
;

value relation_array = Array.make 101 "";

value split2 str fmt =  Scanf.sscanf str fmt (fun x y -> (x,y))
;

value rec read_file chin acc fmt =
      try let line = input_line chin in
      let (a,b) = split2 line fmt in 
      let acc = List.append acc [(a,b)] in
            read_file chin acc fmt
    with 
    [ End_of_file -> do { close_in chin; acc}
    ]
;

value read_list file fmt =
let chin = open_in file in
 read_file chin [] fmt
;

value relations_encodings = 
        read_list (datapath ^"AkAfkRA/relations.txt") "%s %d"
;

value encode rel = try List.assoc rel relations_encodings
           with [ Not_found -> 0 ]
;

value get_assoc key assoc_array =
     try 
	List.assoc key assoc_array
     with [ Not_found -> ""]
;
     
value afgavikaara_list = 
        read_list (datapath ^"AkAfkRA/afgavikAra.txt") "%s %s"
;

value nirXAraNa_list = 
        read_list (datapath ^"AkAfkRA/nirXAraNa.txt") "%s %s"
;

value wAxarWya_list = [ ("yUpa","xAru"); ]
;

value analyse strm = let morphs = 
  try Gram.parse morphs Loc.ghost strm with
       [ Loc.Exc_located loc (Error.E msg) -> do
      { output_string stdout "\n\n"
      ; flush stdout 
      ; Format.eprintf "Lexical error: %a in line %a in example \n%!" 
               Error.print msg Loc.print loc 
      ; failwith "Parsing aborted\n"
      }
       | Loc.Exc_located loc (Stream.Error msg) -> do
      { output_string stdout "\n\n"
      ; flush stdout 
      ; Format.eprintf "Syntax error: %s in example \n%!" msg 
      ; failwith "Parsing aborted\n"
      }
       | Loc.Exc_located loc ex -> do
      { output_string stdout "\n"
      ; flush stdout 
      ; Format.eprintf "Fatal error in example \n%!" 
      ; raise ex
      }
       | ex -> raise ex
       ]  in morphs
;

value distinct_2 m1 m2 = match m1 with
  [ Wif (id1,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)
  | Kqw (id1,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)
  | Avykqw (id1,_,_,_,_,_,_,_,_,_,_,_)
  | AvywaxXiwa (id1,_,_,_,_,_,_,_)
  | Sup (id1,_,_,_,_,_,_,_,_,_)
  | Avy (id1,_,_,_,_,_,_)
  | WaxXiwa (id1,_,_,_,_,_,_,_,_,_,_,_) -> match m2 with
  	[ Wif (id2,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)
  	| Kqw (id2,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)
 	| Avykqw (id2,_,_,_,_,_,_,_,_,_,_,_)
 	| AvywaxXiwa (id2,_,_,_,_,_,_,_)
 	| Sup (id2,_,_,_,_,_,_,_,_,_)
 	| Avy (id2,_,_,_,_,_,_)
 	| WaxXiwa (id2,_,_,_,_,_,_,_,_,_,_,_) -> 
                if not (id1=id2) 
                then True
                else False
        ]
   ]
;

value distinct_3 m1 m2 m3 =   distinct_2 m1 m2 
                           && distinct_2 m1 m3 
                           && distinct_2 m2 m3
;

value compound word uwwarapaxa = not(word=uwwarapaxa)
;

value not_compound word uwwarapaxa = not (compound word uwwarapaxa)
;

value no_boundary_crossing id1 id2 =
      if id1 < kinwu_pos.val && id2 > kinwu_pos.val then False
      else if id1 < paranwu_pos.val && id2 > paranwu_pos.val then False
      else if id1 < aWa_pos.val && id2 > aWa_pos.val then False
     (* else if id1 < yaw_pos.val && id2 > yaw_pos.val then False
yaw ia ambiguous. It can be a pronoun as wwell. *)
      (* else if id1 < iwi_pos.val && id2 > iwi_pos.val then False 
 mawwaH eva iwi vixXi; mawwaH is connected to vixXi, intervenned by iwi. *)
      (*else if id1 < evam_pos.val && id2 > evam_pos.val then False*)
      else if id1 < wasmAw_pos.val && id2 > wasmAw_pos.val then False
      else if id1 < (hi_pos.val-1) && id2 > hi_pos.val then False
     (* else if id1 < wawra_pos.val && id2 > wawra_pos.val then False 
yaH buxXiwvAw wawra kevalam AwmAnam paSyawi ...*)
      else if id1 < warhi_pos.val && id2 > warhi_pos.val then False
      else if (id1 < waw_pos.val && id2 > waw_pos.val)
           && ((yaw_pos.val < 1000) || (cew_pos.val < 1000)) then False
(* If there is waw, then there should be either yaw or cew, else it is not a boundary marker *)
      else if id1 < waxA_pos.val && id2 > waxA_pos.val then False
      else if id1 < waWA_pos.val && id2 > waWA_pos.val && yaWA_pos.val < 1000 then False
      else True
;


value print_relation cho = fun
  [ Relation (i1 , i2 , i3 , i4 , i5 , i6)  -> do
         { output_string cho (string_of_int i1); output_string cho " "
         ; output_string cho (string_of_int i2); output_string cho " "
         ; output_string cho (string_of_int (encode i3)); output_string cho " "
         ; output_string cho (string_of_int i4); output_string cho " "
         ; output_string cho (string_of_int i5); output_string cho " #"
         ; output_string cho i3; output_string cho " "
         ; output_string cho i6; output_string cho " \n"
         } (* else ()*)
  ]
;
(* value rec print_relation_list = fun 
  [ [] -> ()
  | [ r :: l ] -> do { print_relation r
             ; print_relation_list l
             }
  ]
;
*)
value mk_tuple r = match r with
   [ Relation (a,b,c,d,e,f) -> [Relationc (a,b,encode c,d,e)]
   ]
 ;
 
value rec mk_tuple_lst acc = fun
   [ [] -> acc
   | [r :: l ] -> let tpl = mk_tuple r in
                  let acc1 = tpl@acc in
                  mk_tuple_lst acc1 l
   ]
;

value pronoun3 rt = (rt="yax" || rt="wax" || rt="ewax" || rt="ixam" || rt="sarva" || rt="sarvA" || rt="svIya" || rt="svIyA" || rt="kim" || rt="Bavaw" || rt="uBa"|| rt="uBA" || rt="yAvaw" || rt = "wAvaw" || rt = "axas" || rt="kiFciw" || rt="kiFcana" || rt="Awman" || rt="sva" || rt="svA") 
;
value pronominal12 rt = (rt="yuRmax" || rt="asmax")
;
value pronominal123 rt = pronominal12 rt || pronoun3 rt
;
value aBihiwa rt vac1 vac2 per =    (vac1=vac2)  
                 && (  (per="ma" && rt = "yuRmax") 
                    || (per="u" && rt = "asmax") 
                    || (per="pra"  
                    && not (rt = "asmax")
                    && not (rt = "yuRmax")
                   )
                )
;
value noun_agreement vac1 vac2 gen1 gen2 =     
                             (vac1=vac2)
                          && (gen1=gen2 || gen1="a" || gen2 = "a")
;
value noun_agreement_vibh vac1 vac2 gen1 gen2 vib1 vib2 =    
                                    (vac1=vac2)
                                 && (vib1=vib2)
                                 && (gen1=gen2 || gen1="a" || gen2="a")
;

value niyawalifga kqw = kqw="lyut" || kqw="GaF"
;

(* TODO: Modify the Grammar for ignoring comments in the files *)
value populate_from file trie =
  let ic = open_in file in
  try while True do 
            { let word = Transduction.code_raw_WX (input_line ic) 
            ; trie.val := Trie.enter trie.val word
            }
  with [ End_of_file -> close_in ic 
       | Trie.Redundancy -> output_string stderr ("Fatal error: duplicated word in" ^ file ^"\n")
       ]
  ; 

value build_trie file = 
  let trie = ref Trie.empty in
      do { populate_from file trie
     ; (trie.val)
     }
;

value member_of word trie =
       Trie.mem (Transduction.code_raw_WX word) trie
;
    
value members_of rt upasarga trie =
       if upasarga = "X" 
       then member_of rt trie
       else member_of (upasarga^"_"^rt) trie
;
    
value kriyAviSeRaNas = build_trie (datapath ^ "yogyawA/kriyAviSeRaNa_list")
;

value karaNa_verbs = build_trie (datapath ^ "AkAfkRA/karaNa_XAwu_list")
;

value sampraxAna_verbs = build_trie (datapath ^ "AkAfkRA/sampraxAna_XAwu_list")
;

value apAxAna_verbs = build_trie (datapath ^ "AkAfkRA/apAxAna_XAwu_list")
;

value kAlAXikaraNas = build_trie (datapath ^ "yogyawA/kAlAXikaraNa_list")
;

value xeSAXikaraNas = build_trie (datapath ^ "yogyawA/xeSAXikaraNa_list")
;

value kAlAXvas = build_trie (datapath ^ "yogyawA/kAlAXva_list")
;

(* value shashthii_kqw_verbs = build_trie (datapath ^ "RaRTI_kqw_list")
;
*)
value sakarmaka_verbs =  build_trie (datapath ^ "AkAfkRA/sakarmaka_XAwu_list")
;

value xvikarmakas1 = build_trie (datapath ^ "AkAfkRA/xvikarmaka_XAwu_list1")
;

value xvikarmakas2 = build_trie (datapath ^ "AkAfkRA/xvikarmaka_XAwu_list2")
;

value aaxikarma_verbs =  build_trie (datapath ^ "AkAfkRA/Axikarma_XAwu_list")
;

 (* In gawyarWaka, buxXi, prawyavasAnArWa and shabxakarma, only sakarmaka dhaatus are considered: see extract.sh programme for details *)
value gawyarWa_verbs = build_trie (datapath ^ "AkAfkRA/gawyarWa_XAwu_list")
;

value buxXyarWa_verbs = build_trie (datapath ^ "AkAfkRA/buxXyarWa_XAwu_list")
;

value shabxakarma_verbs = build_trie (datapath ^ "AkAfkRA/Sabxakarma_XAwu_list")
;

value prawyavasAnArWa_verbs = build_trie (datapath ^ "AkAfkRA/prawyavasAnArWa_XAwu_list")
;

value shliR_Axi_verbs = build_trie (datapath ^ "AkAfkRA/SliR_Axi_list")
;

value akarmaka_verbs = build_trie (datapath ^ "AkAfkRA/akarmaka_XAwu_list")
;

value vAkyakarma_verbs = build_trie (datapath ^ "AkAfkRA/vAkyakarma_XAwu_list")
;

value shakAxi = build_trie (datapath ^ "AkAfkRA/SakAxi_list")

(* Ocaml does not allow variables starting with Caps. Hence SakAxi -> shakAxi *)
;

value karwqsamAnAXikaraNa_verbs = build_trie (datapath ^ "AkAfkRA/karwqsamAnAXikaraNa_XAwu_list")
;

value karmasamAnAXikaraNa_verbs = build_trie (datapath ^ "AkAfkRA/karmasamAnAXikaraNa_XAwu_list")
;

(* value karmakqw_verbs = build_trie (datapath ^ "karma_kqw_list")
;
*)
value bhaavavaaci_kqw = build_trie (datapath ^ "AkAfkRA/BAva_kqw_list")
;

(* value avy_verb_list = build_trie (datapath ^ "avy_verb_list")
;
*)
value samboXana_sUcaka = build_trie (datapath ^ "AkAfkRA/samboXana_sUcaka_list")
;

value avy_viSeRaNam_list = build_trie (datapath ^ "yogyawA/avy_viSeRaNam_list")
;

value intensifiers_list = build_trie (datapath ^ "yogyawA/intensifiers_list")
;

value viRayAXikaraNa_nouns = build_trie (datapath ^ "AkAfkRA/viRayAXikaraNa_list")
;

value upapaxa2_list = build_trie (datapath ^ "AkAfkRA/upapaxa_2")
;

value upapaxa3_list = build_trie (datapath ^ "AkAfkRA/upapaxa_3")
;

value upapaxa4_list = build_trie (datapath ^ "AkAfkRA/upapaxa_4")
;

value upapaxa5_list = build_trie (datapath ^ "AkAfkRA/upapaxa_5")
;

value upapaxa6_list = build_trie (datapath ^ "AkAfkRA/upapaxa_6")
;

value upapaxa7_list = build_trie (datapath ^ "AkAfkRA/upapaxa_7")
;

value upapaxa_aXikaraNa = build_trie (datapath ^ "AkAfkRA/upapaxa_aXikaraNa_list")
;

value upapaxa_viSeRaNas = build_trie (datapath ^ "AkAfkRA/upapaxa_viSeRaNa_list")
;

value upapaxa_sambanXa = build_trie (datapath ^ "AkAfkRA/upapaxa_sambanXa_list")
;

value saMKyeya = build_trie (datapath ^ "yogyawA/saMKyeya_list")
;

value pUraNa = build_trie (datapath ^ "yogyawA/pUraNa_list")
;

value guNa = build_trie (datapath ^ "yogyawA/guNa_list")
;

value guNavacana = build_trie (datapath ^ "yogyawA/guNavacana_list")
;

(*value xravyavAcI = build_trie (datapath ^ "yogyawA/xravyavAcI_list")
; *)

 (* kqxanwa list is introduced, since we still do not have an exhastive kqxanwa analyser ; we need it for viSeRaNas and RaRTI sambanXa*)

value kqxanwas = build_trie (datapath ^ "AkAfkRA/kqxanwa_list")
;

 (* waxXiwAnwa_list is introduced, since we still do not have an exhastive waxXXiwa analyser ; we need it for viSeRaNas *)
value taddhitaantas = build_trie (datapath ^ "yogyawA/waxXiwAnwa_list")
;

(* value uwwara_guNavAcI = build_trie (datapath ^ "yogyawA/uwwarapaxa_guNavAcI_list")
; *)

value sambanXavAcI = build_trie (datapath ^ "yogyawA/sambanXavAcI_list")
;

value viRayi_list = build_trie (datapath ^ "AkAfkRA/viRayi_list")
;

value non_RaRTI_list = build_trie (datapath ^ "yogyawA/non_RaRTI_list")
;

value aXikaraNa_type word rt = 
          if member_of word kAlAXikaraNas then "kAlAXikaraNam"
          else if member_of rt kAlAXikaraNas then "kAlAXikaraNam"
          else if member_of word xeSAXikaraNas then "xeSAXikaraNam"
          else "aXikaraNam"
;
(* Sanjeev: write a note on why do you need all these classification.
   Give justification with Panini's suutra for each of them
   Draw a Venn diagram showing the overlaps among these sets
*)
value verb_type rt upasarga =  
          if members_of rt upasarga akarmaka_verbs then "akarmaka"
          else if members_of rt upasarga xvikarmakas2 then "xvikarmakas2"
          else if members_of rt upasarga xvikarmakas1 then "xvikarmakas1"
          else if members_of rt upasarga gawyarWa_verbs then "gawi"
          else if members_of rt upasarga buxXyarWa_verbs  then "buxXi"
          else if members_of rt upasarga prawyavasAnArWa_verbs then "prawyavasAnArWa"
          else if members_of rt upasarga shabxakarma_verbs then "Sabxakarma"
          else if members_of rt upasarga sakarmaka_verbs then "sakarmaka" else ""
;

(* yogyawA *)
value kv_or_spl_aXi id1 mid1 id2 mid2 word = 
          if member_of (word^" avy") kriyAviSeRaNas
          then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"100.1")] 
          else if member_of word kAlAXikaraNas 
          then [ Relation (id1,mid1,"kAlAXikaraNam",id2,mid2,"100.2") ]
          else if member_of word xeSAXikaraNas 
          then [ Relation (id1,mid1,"xeSAXikaraNam",id2,mid2,"100.3") ]
          else []
;

value previous id = id-1
;

value next id = id+1
;

value prose_order id1 id2 text_type = 
          if text_type="prose" then id1 < id2 else True
(*not (id1=id2)*)
;

value word_order id1 id2 =  id1 < id2
;

value yaxi_no_warhi word =  
       if ( (    word="cew"
              && warhi_pos.val = 1000
              && waw_pos.val = 1000 
            )
           || (  word="yaxi"
              && warhi_pos.val = 1000
              && waw_pos.val = 1000 
              && wawaH_pos.val = 1000 
              )
          || (word="yawaH" && (awaH_pos.val = 1000) && (wawaH_pos.val = 1000))
          || (word="yaxyapi" &&  (waWApi_pos.val = 1000) && (aWApi_pos.val = 1000))
          (*|| (word="yawra" &&  (wawra_pos.val = 1000)) *)
          || (word="yAvaw" &&  (wAvaw_pos.val = 1000))
          (* || (word="yaxA" &&  (waxA_pos.val = 1000)) *)
          )
          then True else False
;

value warhi_no_yaxi word =  
       if (  ((word="warhi" || word="waw") && (yaxi_pos.val = 1000))
          || ((word="wawaH" || word="awaH") && (yawaH_pos.val = 1000))
          || ((word="waWApi"|| word="aWApi") && (yaxyapi_pos.val = 1000))
          (* || (word="wawra" &&  (yawra_pos.val = 1000)) *)
          || (word="wAvaw" &&  (yAvaw_pos.val = 1000))
          (* || (word="waxA" &&  (yaxA_pos.val = 1000)) *)
          )
           then True else False
;

value yaxi_with_warhi word =  
       if (  ((word="yaxi" || (word="cew")) && not ((warhi_pos.val = 1000) && (waw_pos.val = 1000)))
          || ((word="yaxi") && not ((warhi_pos.val = 1000) && (waw_pos.val = 1000) && wawaH_pos.val = 1000))
          || (word="yawaH" &&  not ((wawaH_pos.val = 1000) && (awaH_pos.val = 1000)))
          || (word="yaxyapi" &&  not ((waWApi_pos.val = 1000) && (aWApi_pos.val = 1000)))
          || (word="yAvaw" && not (wAvaw_pos.val = 1000))
          (* || (word="yawra" && not (wawra_pos.val = 1000))
          || (word="yaxA" && not (waxA_pos.val = 1000)) *)
          )
           then True else False
;

value warhi_with_yaxi word =  
       if ( ((word="warhi" || word="waw") && not (yaxi_pos.val = 1000))
          ||((word="wawaH" || word="awaH") &&  not (yawaH_pos.val = 1000))
          ||((word="waWApi" || word="aWApi") &&  not (yaxyapi_pos.val = 1000))
          || (word="wAvaw" &&  not (yAvaw_pos.val = 1000))
          (* || (word="wawra" &&  not (yawra_pos.val = 1000))
          || (word="waxA" &&  not (yaxA_pos.val = 1000)) *)
          )
           then True else False
;

value bh_kqw fn id1 id2 id3 mid1 mid2 mid3 kqw word rl =  
           if member_of kqw bhaavavaaci_kqw
           then fn id1 id2 id3 mid1 mid2 mid3 word rl 
           else []
;

value prawi_and_anu id1 id2 id3 mid1 mid2 mid3 word rl = 
     if    ((word="warhi"||word="waw"||word="awaH"||word="wawaH"||word="wAvaw"||word="waWApi"|| word="aWApi") && id2 < id1 && id1 < id3)
        || ((word="yaxi"||word="yawaH"||word="yAvaw"||word="yaxyapi") && id2 > id1 && (id3 > id2 || id3 < id1))
        || (word="cew" && id1 > id2 && (id3 > id1 || id3 < id2))
     then [ Relation (id2,mid2,"prawiyogI",id1,mid1,rl)
          ; Relation (id1,mid1,"anuyogI",id3,mid3,rl)
          ]
     else []
;

value prawi_or_anu id1 id2 id3 mid1 mid2 mid3 word rlid  = 
            match word with
            [ "yaxi" -> if id1 < id2 && (  (id3 < id1 && (warhi_pos.val < id3 || waw_pos.val < id3))
                                        || (id3 > id2 && (warhi_pos.val > id2 || waw_pos.val < id3)))
                        then [ Relation (id2,mid2,"prawiyogI",id1,mid1,rlid^"a")]
                        else []
            | "cew" -> if id2 < id1 
                       && (  (id3 < id1 
                              &&  ((warhi_pos.val < id3) || waw_pos.val < id3 ))
                          || (id3 > id2 
                              &&  ((warhi_pos.val > id2) || waw_pos.val < id3))
                          )
                        then [ Relation (id2,mid2,"prawiyogI",id1,mid1,rlid^"a")]
                        else []
            |"yawaH" -> if id1 < id2 && (  (id3 < id1 && wawaH_pos.val < id3) 
                                        || (id3 > id2 && wawaH_pos.val > id2))
                        then [ Relation (id2,mid2,"prawiyogI",id1,mid1,rlid^"a")]
                        else []
      (*      |"yaxA" ->  if id1 < id2 && (  (id3 < id1 && waxA_pos.val < id3) 
                                         || ( id3 > id2 && waxA_pos.val > id2))
                        then [ Relation (id2,mid2,"prawiyogI",id1,mid1,rlid^"a")]
                        else []
            |"yawra" -> if id1 < id2 && (  (id3 < id1 && wawra_pos.val < id3) 
                                         || ( id3 > id2 && wawra_pos.val > id2))
                        then [ Relation (id2,mid2,"prawiyogI",id1,mid1,rlid^"a")]
                        else [] *)
            |"yAvaw" -> if id1 < id2 && (  (id3 < id1 && wAvaw_pos.val < id3) 
                                        || (id3 > id2 && wAvaw_pos.val > id2))
                        then [ Relation (id2,mid2,"prawiyogI",id1,mid1,rlid^"a")]
                        else []
            |"yaxyapi" -> if id1 < id2 && ( (id3 < id1 && waWApi_pos.val < id3) 
                                         || (id3 > id2 && waWApi_pos.val > id2))
                          then [ Relation (id2,mid2,"prawiyogI",id1,mid1,rlid^"a")]
                         else []
            | "warhi" 
            | "waw" -> if id1 < id3 && (id2 < id1 || (id2 > id3 && id3 < yaxi_pos.val)) 
                          then [ Relation (id1,mid1,"anuyogI",id3,mid3,rlid^"b")]
                          else []
            | "awaH" -> if id1 < id3 && (id2 < id1 || (id2 > id3 && id3 < yawaH_pos.val)) 
                          then [ Relation (id1,mid1,"anuyogI",id3,mid3,rlid^"b")]
                          else []
            | "wawaH" -> if id1 < id3 && (id2 < id1 || (id2 > id3 && id3 < yawaH_pos.val)) 
                          then [ Relation (id1,mid1,"anuyogI",id3,mid3,rlid^"b")]
                          else [] 
            (* | "waxA" -> if id1 < id3 && (id2 < id1 || (id2 > id3 && id3 < yaxA_pos.val)) 
                          then [ Relation (id1,mid1,"anuyogI",id3,mid3,rlid^"b")]
                          else []
            | "wawra" -> if id1 < id3 && (id2 < id1 || (id2 > id3 && id3 < yawra_pos.val)) 
                          then [ Relation (id1,mid1,"anuyogI",id3,mid3,rlid^"b")]
                          else [] *)
            | "wAvaw" -> if    id1 < id3
                            && (id2 < id1 || (id2 > id3 && id3 < yAvaw_pos.val)) 
                         then [ Relation (id1,mid1,"anuyogI",id3,mid3,rlid^"b")]
                         else []
            | "aWApi" -> if    id1 < id3 
                            && (id2 < id1 || (id2 > id3 && id3 < yaxyapi_pos.val)) 
                         then [ Relation (id1,mid1,"anuyogI",id3,mid3,rlid^"b")]
                         else []
            | "waWApi" -> if   id1 < id3 
                            && (id2 < id1 || (id2 > id3 && id3 < yaxi_pos.val)) 
                          then [ Relation (id1,mid1,"anuyogI",id3,mid3,rlid^"b")]
                          else []
            | _ -> []
            ]
;

value a fn id1 id2 mid1 mid2 m3 word rl = match m3 with
                   [ Wif (id3,mid3,_,rt3,_,_,_,_,_,_,_,_,_,_,_,_) -> fn id1 id2 id3 mid1 mid2 mid3 word (rl ^ "a")
                   | Kqw (id3,mid3,_,rt3,_,_,kqw3,_,_,_,_,_,_,_,_,_,_) -> bh_kqw fn id1 id2 id3 mid1 mid2 mid3 kqw3 word (rl ^ "b")
                   | _ -> []
                   ]
;

value yaxi_warhi fn m2 m3 id1 mid1 word rl = match m2 with
                   [ Wif (id2,mid2,_,rt2,_,_,_,_,_,_,_,_,_,_,_,_) -> a fn id1 id2 mid1 mid2 m3 word rl
                   | Kqw (id2,mid2,_,rt2,_,_,kqw2,_,_,_,_,_,_,_,_,_,_) -> 
                             if member_of kqw2 bhaavavaaci_kqw || kqw2="kwa" || kqw2 = "kwavawu" 
                             then a fn id1 id2 mid1 mid2 m3 word rl
                             else []
                   | _ -> []
                   ]
;

value supAxi_vIpsa id1 id2 mid1 mid2 word1 word2 rt1 vac1 vac2 gen1 gen2 vib1 vib2 rlid =
   if    id1=previous id2 
      && word1=word2
      && noun_agreement_vibh vac1 vac2 gen1 gen2 vib1 vib2
   then [ Relation (id1,mid1,"vIpsA",id2,mid2,rlid)]
   else []
;

(* Section on kAraka relations *)

(* Notes on karta and karma vibhkati
Verb classes: A akarmaka
          S sakarmaka
        S.1 gawibuxXi_etc (gawi, buxXi, prawyavasAnArWa, Sabxa-karma)
            S.1.1 gawyarWaka
          D xvikarmaka
        D.1 xvikaramaka1
        D.2 xvikaramaka2

sUwra:
      anaBihiwe karmaNi xviwIyA
      anaBihiwe karwq-karaNayoH wqwIyA

wif karwari:       (aBihiwa karwA)
Case       Vb_Class karwA       karma       
Ia       A    1       -             
Ib       S    1       2       (karmaNi xviwIyA)          
Ic       D    1       2 2       (karmaNi xviwIyA)

wif karmaNi:       (aBihiwa karma)
Case       Vb_Class karwA       karma       
IIa       A    3       -    (BAve prayogaH)
IIb       S    3       1       (karwq-karaNayoH wqwIyA)             
IIc       D.1    3       1 2       (muKya and gONa)  (anaBihiwe gONa-karmaNi xviwIyA)
IId       D.2    3       2 1       (muKya and gONa)  (anaBihiwe muKya-karmaNi xviwIyA)

Nic+wif karwari: (aBihiwa karwA)
Case       Vb_Class prayojaka_karwA prayojya_karwA       karma       
IIIa       A    1           2          -       (gawibuxXi.. elevates prayojya_karwA to karma, hence xviwIyA)
IIIb       S.1    1           2          2       (gawibuxXi.. elevates prayojya_karwA to karma, hence xviwIyA)
IIIc       S-S.1    1           3          2       (prayojya karwA is anaBihiwa; hence wqwIyA)
IIId       D    1           3          2 2       (prayojya karwA is anaBihiwa; hence wqwIyA)

Nic+wif karmaNi: (aBihiwa karma; gawibuxXi.. karma;)
Case       Vb_Class prayojaka_karwA prayojya_karwA       karma       
IVa       A      3           1          -       (gawibuxXi.. elevates prayojya_karwA to karma, hence praWamA)
IVb       S.1.1      3           1          2       ()  gawyarWaka
IVc       S.1-S.1.1  3           1          2       ()  gawibuxXi - gawyarWaka
IVd       S.1-S.1.1  3           2          1       ()  gawibuxXi - gawyarWaka
IVe       S-S.1        3           3          1       (prayojya karwA is anaBihiwa; hence wqwIyA); sakarmaka - gawibuxXi
IVf       D.1      3           3          1 2       (prayojya karwA is anaBihiwa; hence wqwIyA)
IVg       D.2      3           3          2 1       (prayojya karwA is anaBihiwa; hence wqwIyA)

*) 
value rlwifkarwA_karma m1 m2 text_type = match m2 with
  [ Wif (id2,mid2,_,rt2,_,_,upasarga2,sanAxiH2,prayogaH2,_,puruRaH2,vacanam2,_,_,_,_) ->
     match m1 with
     [ WaxXiwa (id1,mid1,word1,rt1,pUrvapaxa1,uwwarapaxa1,_,_,lifgam1,viBakwiH1,vacanam1,_)
     | Kqw (id1,mid1,word1,_,_,_,_,_,_,_,rt1,pUrvapaxa1,uwwarapaxa1,lifgam1,viBakwiH1,vacanam1,_)
     | Sup (id1,mid1,word1,rt1,pUrvapaxa1,uwwarapaxa1,lifgam1,viBakwiH1,vacanam1,_) -> 
       if prose_order id1 id2 text_type
       then match viBakwiH1 with
       [ 1 ->  if aBihiwa rt1 vacanam1 vacanam2 puruRaH2
           then match prayogaH2 with
           [ "karwari" -> match sanAxiH2 with
                 [ "Nic" -> [ Relation (id1,mid1,"prayojakakarwA",id2,mid2,"1.1")]  
                      (* aBihiwe praWamA  - xevaxawwaH:prayojakakarwA pATayawi*)
                 | _     -> [ Relation (id1,mid1,"karwA",id2,mid2,"1.2")]  
                      (* aBihiwe praWamA -xevaxawwaH:karwA paTawi*)
                 ]
           |"karmaNi" -> match verb_type rt2 upasarga2 with
                 [ "xvikarmakas2" -> [ Relation (id1,mid1,"muKyakarma",id2,mid2,"1.3")]  
                         (*praXAne nIhqkqRvah  - ajA:muKyakarma grAmaM nIyawe *)
                 | "xvikarmakas1" -> [ Relation (id1,mid1,"gONakarma",id2,mid2,"1.4")]  
                         (*apraXAne xuhAxinAm.. - gOH xugXaM:gONakarma xuhyawe *)
                 | _ -> match sanAxiH2 with
                    ["Nic" ->  match verb_type rt2 upasarga2 with
                           [ "gawi" -> [ Relation (id1,mid1,"prayojyakarwA",id2,mid2,"1.5")]  
                           (*gawibuxXi.. -> karma; aBihiwa   yajFaxawwena xevaxawwaH:prayojyakarwA  grAmaM  gamyawe *)
                           | "buxXi"
                           | "Sabxakarma"
                           | "prawyavasAnArWa"  -> 
                                   [ Relation (id1,mid1,"prayojyakarwA",id2,mid2,"1.6")  
                                       (*yajFaxawwena  xevaxawwaH PalaM KAxyawe *)
                                   ; Relation (id1,mid1,"karma",id2,mid2,"1.7") 
                                   ]
                           | "sakarmaka"  -> [ Relation (id1,mid1,"karma",id2,mid2,"1.8")]  
                                 (* aBihiwe praWamA  -yajFaxawwena  xevaxawwaM  PalaM  KAxyawe *)
                           | _ -> []
                           ]
                   | _ -> if members_of rt2 upasarga2 sakarmaka_verbs
                       then [ Relation (id1,mid1,"karma",id2,mid2,"1.9")]  
                        (* aBihiwe praWamA  - xevaxawwena grAmaH gamyawe*)
                     else []
                    ]
                 ]
           | _ -> []
           ]
           else []
    | 2 -> match prayogaH2 with
           ["karwari" ->  match sanAxiH2 with
                  [ "Nic" -> match verb_type rt2 upasarga2 with
                     [ "xvikarmakas2" 
                     | "xvikarmakas1" -> [ Relation (id1,mid1,"karma",id2,mid2,"1.10")]  
                                 (* karmaNi xviwIyA - yajFaxawwaH xevaxawwena rAjAnaM vasuXAM yAcayawi  *)
                     | "akarmaka" -> if rt1="arWa" && compound word1 uwwarapaxa1
                                     then [ Relation (id1,mid1,"prayojanam",id2,mid2,"1.11")] 
                                     else if rt1="pUrvaka" && compound word1 uwwarapaxa1 && lifgam1="napuM"
                                     then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"1.12")] 
                                     else if (pUrvapaxa1="sa") && lifgam1="napuM"
                                     then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"1.13")] 
                                     (* else if (uwwarapaxa1=pUrvapaxa1 ) || (pUrvapaxa1="a")
		                     then [ Relation (id1,mid1,"karma",id2,mid2,"2.4")]  *)
                                     else [ Relation (id1,mid1,"prayojyakarwA",id2,mid2,"1.14")]  
                             (*gawibuxXi.. elevates prayojya_karwA to karma, hence xviwIyA *)
                     | "buxXi"
                     | "Sabxakarma"
                     | "gawi"
                     | "prawyavasAnArWa" -> 
                             if rt1="arWa" && compound word1 uwwarapaxa1
                             then [ Relation (id1,mid1,"prayojanam",id2,mid2,"1.15")] 
                             else if rt1="pUrvaka" && compound word1 uwwarapaxa1 && lifgam1="napuM"
                             then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"1.16")] 
                             else if (pUrvapaxa1="sa") && lifgam1="napuM"
                             then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"1.17")] 
                             else if (uwwarapaxa1=pUrvapaxa1 ) || (pUrvapaxa1="a")
		             then [ Relation (id1,mid1,"karma",id2,mid2,"1.18")] 
                             else [ Relation (id1,mid1,"prayojyakarwA",id2,mid2,"1.19") (* '' *) 
                                  ; Relation (id1,mid1,"karma",id2,mid2,"1.20") (* karmaNi xviwIyA *) 
                                  ]
                     | "sakarmaka" (* not gawibuxXi && not prawyavasAnArWa_verbs *)
                              ->  if rt1="arWa" && compound word1 uwwarapaxa1
                                  then [ Relation (id1,mid1,"prayojanam",id2,mid2,"1.21")] 
                                  else if rt1="pUrvaka" && compound word1 uwwarapaxa1 && lifgam1="napuM"
                                  then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"1.22")] 
                                  else if (pUrvapaxa1="sa") && lifgam1="napuM"
                                  then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"1.23")] 
                                  else if (uwwarapaxa1=pUrvapaxa1 ) || (pUrvapaxa1="a")
		                  then [ Relation (id1,mid1,"karma",id2,mid2,"1.24")] 
                                  else [Relation (id1,mid1,"karma",id2,mid2,"1.25" )] (* karmaNi xviwIyA *) 
                     | _ -> []
                     ]
                | _ -> if    not (member_of (word1 ^ " " ^ string_of_int viBakwiH1) kriyAviSeRaNas) 
                          && not (member_of word1 kAlAXvas)
                       then match verb_type rt2 upasarga2 with
                      [ "xvikarmakas1" 
                      | "xvikarmakas2" -> [ Relation (id1,mid1,"gONakarma",id2,mid2,"1.26" )
                                (* karmaNi xviwIyA  - rAjAnaM vasuXAM yAcawe*)
                               ; Relation (id1,mid1,"muKyakarma",id2,mid2,"1.27" ) 
                                (* karmaNi xviwIyA - gAM xogXi payaH *)
                                  ]
                      | "gawi"
                      | "buxXi" 
                      | "Sabxakarma" 
                      | "prawyavasAnArWa"
                      | "sakarmaka" -> if rt1="pUrvaka" && compound word1 uwwarapaxa1 && lifgam1="napuM"
                                       then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"1.28")] 
                                       else if (pUrvapaxa1="sa") && lifgam1="napuM"
                                       then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"1.29")] 
                                       else if rt1="arWa" && compound word1 uwwarapaxa1
                                       then [ Relation (id1,mid1,"prayojanam",id2,mid2,"1.30")]
				       else [ Relation (id1,mid1,"karma",id2,mid2,"1.31" )] (* karmaNi xviwIyA *) 
                      | "akarmaka" ->  if rt1="arWa" && compound word1 uwwarapaxa1
                                       then [ Relation (id1,mid1,"prayojanam",id2,mid2,"1.32")]
                                       else if rt1="pUrvaka" && compound word1 uwwarapaxa1 && lifgam1="napuM"
                                       then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"1.33")] 
                                       else if (pUrvapaxa1="sa") && lifgam1="napuM"
                                       then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"1.34")] 
                                       (* else if (uwwarapaxa1=pUrvapaxa1 ) || (pUrvapaxa1="a")
		                       then [ Relation (id1,mid1,"karma",id2,mid2,"2.4")] *)
                                       else []
                      | _ -> []
                      ]
                     else []
                  ]
           | "karmaNi" -> match verb_type rt2 upasarga2 with 
                  [ "xvikarmakas1" -> [ Relation (id1,mid1,"muKyakarma",id2,mid2,"1.35")] 
                          (* aprAXAne xuhAxi - gOH  xuhyawe xugXaM  *)
                  | "xvikarmakas2" -> [ Relation (id1,mid1,"gONakarma",id2,mid2,"1.36")] 
                          (* praXAne nI..  ajA nIyawe grAmaM *)
                  | _ -> match sanAxiH2 with
                     ["Nic" -> match verb_type rt2 upasarga2 with
                          [ "gawi" -> [ Relation (id1,mid1,"karma",id2,mid2,"1.37" )] (* karmaNi xviwIyA *)
                          | "buxXi"
                          | "Sabxakarma"
                          | "prawyavasAnArWa" -> 
                                  [ Relation (id1,mid1,"prayojyakarwA",id2,mid2,"1.38" ) 
                                  ; Relation (id1,mid1,"karma",id2,mid2,"1.39") (* anukwakarmaNi xviwIyA *) 
                                  ]
                          | _ -> []
                          ]
                     | _ -> []
                     ]
                  ]
           | _ -> []
           ]
    | 3 ->  match sanAxiH2 with 
        [ "Nic" ->  match verb_type rt2 upasarga2 with
                [ "xvikarmakas2"
                | "xvikarmakas1"
                | "sakarmaka" (* not gawibuxXi && not prawyavasAnArWa *)
                     ->  match prayogaH2 with
                      [ "karwari" -> [ Relation (id1,mid1,"prayojyakarwA",id2,mid2,"1.40" )]
                             (* karwq_karaNayoH wqwIyA - yajFaxawwaH xevaxawwena annaM pAcayawi *)
                      | "karmaNi" -> 
                             [ Relation (id1,mid1,"prayojakakarwA",id2,mid2,"1.41" ) 
                             ; Relation (id1,mid1,"prayojyakarwA",id2,mid2,"1.42" )  
                             (* karwqkaraNayoH wqwIyA - yajFaxawwena  xevaxawwena annaM pAcyawe *)
                             ]
                      | _ -> if prayogaH2 = "karmaNi" 
                         then [ Relation (id1,mid1,"prayojakakarwA",id2,mid2,"1.43" )] (* karwqkaraNayoH wqwIyA *) 
                         else []
                      ]
                | _ ->  [ Relation (id1,mid1,"karwA",id2,mid2,"1.44" )] (* karwq_karaNayoH_wqwIyA *) 
                ]
        | _ ->  if (prayogaH2 = "karmaNi" || prayogaH2 = "BAve")
                  && not (member_of word1 kAlAXvas)
            then [ Relation (id1,mid1,"karwA",id2,mid2,"1.45" )] (* karwqkaraNayoH wqwIyA *) 
            else [] (* karaNam is marked below *)
        ]
    | _ -> []
    ]
    else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;

value rlkqwkarwA_karma m1 m2 text_type = match m2 with
(* One more condition that the verb in wif does not exist in this sent needs to be added.
e.g. xevaxawwaH grAmaM gawaH: here xevaxawwa is the karwA of gawaH, since there is no verb in wif
But in grAmam gawaH xevaxawwaH puswakaM paTawi, here xevaxawwa is not marked as karwA of gawaH but gawaH is the viSeRaNa for xevaxawwaH *)
  [ Kqw (id2,mid2,_,rt2,upasarga2,sanAxiH2,kqw2,_,_,_,_,pUrvapaxa2,uwwarapaxa2,lifgam2,viBakwiH2,vacanam2,_) ->
     match m1 with
     [ WaxXiwa (id1,mid1,word1,rt1,pUrvapaxa1,uwwarapaxa1,_,_,lifgam1,viBakwiH1,vacanam1,_) 
     | Kqw (id1,mid1,word1,_,_,_,_,_,_,_,rt1,pUrvapaxa1,uwwarapaxa1,lifgam1,viBakwiH1,vacanam1,_)
     | Sup (id1,mid1,word1,rt1,pUrvapaxa1,uwwarapaxa1,lifgam1,viBakwiH1,vacanam1,_) -> 
       if  prose_order id1 id2 text_type
       then if not (sanAxiH2="Nic")
       then match kqw2 with
         [ "kwa" -> match viBakwiH1 with
                [ 1 -> if    noun_agreement vacanam1 vacanam2 lifgam1 lifgam2
                      && viBakwiH2=1
                      (*&&  (finite_verb_in_sentence.val=1000 ||
                           finite_verb_in_sentence.val=id2  ||
                           finite_verb_in_sentence.val=id1) 
                      This condition creates a problem when a word has both sup and wif analysis and wif analysis is not the desired output. Ex: wena mama ayam mohaH vigawaH , here mohaH is not marked*)
                   then if (members_of rt2 upasarga2 shliR_Axi_verbs
                       || members_of rt2 upasarga2 gawyarWa_verbs
                       || members_of rt2 upasarga2 aaxikarma_verbs
                       || members_of rt2 upasarga2 akarmaka_verbs)
                   then [ Relation (id1,mid1,"karwA",id2,mid2,"2.1" )  
                    (*3-4-71 AxikarmaNi kwaH karwari ca . 3-4-72 gawyarWAkarmakaSliRaSIfsWAZZsavasajanaruhajIryawiByaSca.
                      AxikarmaNi--rAmaH kataM prakqwaH,gawyarWa- rAmaH gqhaM gawaH... *)
                    (* ; Relation (id1,mid1,"karma",id2,mid2,"2.2") (* kwayoreva.. *) DO Not mark karma; this is just samAnAXikaraNam *)
                    ]
                   else if    members_of rt2 upasarga2 sakarmaka_verbs   
                           && (pUrvapaxa2=uwwarapaxa2 || pUrvapaxa2="a")
                   then [ Relation (id1,mid1,"karma",id2,mid2,"2.2")]  
                      (*3-4-71 wayoreva kqwykwaKalarWAH rAmeNa granWaH paTiwaH *)
                   else if    members_of rt2 upasarga2 xvikarmakas1   
                           || members_of rt2 upasarga2 xvikarmakas2   
                   then [ Relation (id1,mid1,"karma",id2,mid2,"2.3")]  
                   else []
                   (* Do not mark karma, this is samAnAXikarNa
                    match verb_type rt2 with
                     ["xvikarmakas2"
                     |"xvikarmakas1" 
                     |"gawyarWaka"
                     |"gawibuxXi"
                     |"prawyavasAnArWa"
                     |"sakarmaka"->
                      [ Relation (id1,mid1,"viSeRaNam",id2,mid2,"2.4")] (*rlkqwaBihiwa3*)
                     | _ -> [] 
                     ]  *)
                   else []
             | 2 ->  if not (member_of word1 kAlAXvas)
   			&& (  members_of rt2 upasarga2 shliR_Axi_verbs
                           || members_of rt2 upasarga2 gawyarWa_verbs
                           || members_of rt2 upasarga2 aaxikarma_verbs
                           )
                     then if rt1="arWa" && compound word1 uwwarapaxa1
                     then [ Relation (id1,mid1,"prayojanam",id2,mid2,"2.4")]
                 (*    else if (uwwarapaxa1=pUrvapaxa1 ) || (pUrvapaxa1="a") 
		     then [ Relation (id1,mid1,"karma",id2,mid2,"2.4")] 
Why this condition? 
Counter example: sarva-BUwa-hiwe rawAH *)
                     else if rt1="pUrvaka" && compound word1 uwwarapaxa1 && lifgam1="napuM"
                     then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"2.5")] 
                     else if (pUrvapaxa1="sa") && lifgam1="napuM"
                     then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"2.6")] 
                     else [ Relation (id1,mid1,"karma",id2,mid2,"2.7")] 
                     else [] (*  Why 2.8 is needed? wawkAlam pravqwwAH -> wawkAlam is marked as a karma for pra_vqw, which is asakarmaka [ Relation (id1,mid1,"karma",id2,mid2,"2.8")] *)
                    (* anaBihiwe karmaNi xviwIyA gurum upaSliRtaH , grAmaM gawaH, kataM prakqwaH*)
                     (* else [ Relation (id1,mid1,"viSeRaNam",id2,mid2,"2.5")]  Any example for this rule? *)
               | 3 ->  (* if viBakwiH2=1; why this condition? puwreNa vyUDAm camUm paSya *)
                    if    not (member_of word1 kAlAXvas)
                       && not (members_of rt2 upasarga2 shliR_Axi_verbs
                             || members_of rt2 upasarga2 gawyarWa_verbs
                             || members_of rt2 upasarga2 aaxikarma_verbs
                             || members_of rt2 upasarga2 akarmaka_verbs)
                       && (not (member_of rt1 guNa) || pronominal123 rt1)
                    then
                      [ Relation (id1,mid1,"karwA",id2,mid2,"2.9")] (* karwq_karaNayoH_wqwIyA rAmeNa granWaH paTiwaH*) 
                    else []
               | _ -> []
               ]
        | "ac" 
        | "kwavawu" -> match viBakwiH1 with
                   [ 1 -> if noun_agreement vacanam1 vacanam2 lifgam1 lifgam2
                      then [ Relation (id1,mid1,"karwA",id2,mid2,"2.10")] (* aBihiwe karwari praWamA , rAmaH gawavAn *) 
                      else []
                   | 2 -> if (  members_of rt2 upasarga2 sakarmaka_verbs
                             || members_of rt2 upasarga2 xvikarmakas2
                             || members_of rt2 upasarga2 xvikarmakas1)
                          && not (member_of word1 kAlAXvas)
                          then if rt1="arWa" && compound word1 uwwarapaxa1
                          then [ Relation (id1,mid1,"prayojanam",id2,mid2,"2.11")]
                          else if rt1="pUrvaka" && compound word1 uwwarapaxa1 && lifgam1="napuM"
                          then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"2.12")] 
                          else if (pUrvapaxa1="sa") && lifgam1="napuM"
                          then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"2.13")] 
			  else (*if pUrvapaxa1=uwwarapaxa1 || pUrvapaxa1="a"
			  then *)[ Relation (id1,mid1,"karma",id2,mid2,"2.14")] (*rAmaH gqhaM gawavAn*) 
			  (*else []*)
                          else []
                   | _ -> []
                   ]
        | "wavya"  
        | "wavyaw"  
        | "anIyar"  
        | "yaw"  
        | "kyap"  
        | "Nyaw"
        | "Kal"
        | "yuc"   -> match viBakwiH1 with
                 [ 1 -> if members_of rt2 upasarga2 sakarmaka_verbs && pUrvapaxa2=uwwarapaxa2|| pUrvapaxa2="a"
                   then [ Relation (id1,mid1,"karma",id2,mid2,"2.15")]  
                    (* rlkqwaBihiwa10  wayoreva kqwyakwaKalarWAH  rAmeNaH granWaH paTiwavyaH/paTanIyaH *)
                 else []
                 | 3 -> [ Relation (id1,mid1,"karwA",id2,mid2,"2.16")]  
                    (* karwq_karaNayoH_wqwIyA rAmeNaH granWaH paTiwavyaH/paTanIyaH*)
                 | _ -> []
                 ]
        | "SAnac_lat" 
        | "SAnac_lqt" 
        | "Sawq_lat" 
        | "Sawq_lqt" ->  if viBakwiH1=2 && (members_of rt2 upasarga2 sakarmaka_verbs || members_of rt2 upasarga2 xvikarmakas1 || members_of rt2 upasarga2 xvikarmakas2) && not (uwwarapaxa1="pUrvaka")
                         then [ Relation (id1,mid1,"karma",id2,mid2,"2.17")] 
                         else if rt1="arWa" && compound word1 uwwarapaxa1
                         then [ Relation (id1,mid1,"prayojanam",id2,mid2,"2.18")]
                         else if rt1="pUrvaka" && compound word1 uwwarapaxa1 && lifgam1="napuM"
                         then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"2.19")] 
                         else if (pUrvapaxa1="sa") && lifgam1="napuM"
                         then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"2.20")] 
			 else []
        | _ ->  if viBakwiH1=6 && (members_of rt2 upasarga2 sakarmaka_verbs) && (pUrvapaxa2=uwwarapaxa1 || pUrvapaxa1="a") && not (uwwarapaxa1="pUrvaka")
                then [ Relation (id1,mid1,"karma",id2,mid2,"2.21")] 
                else []
        ]
      else match kqw2 with
        [ "kwa" -> match viBakwiH1 with
                [ 1 -> if noun_agreement vacanam1 vacanam2 lifgam1 lifgam2
                   then match verb_type rt2 upasarga2 with
                   [ "akarmaka" -> [ Relation (id1,mid1,"prayojakakarwA",id2,mid2,"2.22")] 
                   | "xvikarmakas1" -> [ Relation (id1,mid1,"gONakarma",id2,mid2,"2.23")] 
                   | "xvikarmakas2" -> [ Relation (id1,mid1,"muKyakarma",id2,mid2,"2.24")] 
                   | "gawi" -> [ Relation (id1,mid1,"prayojakakarwA",id2,mid2,"2.25")  
                          (* yajFaxawwaH xevaxawwaM grAmaM gamiwaH  gawibuxXi.. elevates prayojya_karwA to karma, hence xviwIyA *)
                           ; Relation (id1,mid1,"prayojyakarwA",id2,mid2,"2.26") (*yajFaxawwena xevaxawwaH pATaM kAriwaH *) 
                           ]
                | _ ->  if  members_of rt2 upasarga2 shliR_Axi_verbs
                    then [ Relation (id1,mid1,"prayojakakarwA",id2,mid2,"2.27")  
                         (* yajFaxawwaH xevaxawwaM grAmaM gamiwaH  gawibuxXi.. elevates prayojya_karwA to karma, hence xviwIyA *)
                         ; Relation (id1,mid1,"prayojyakarwA",id2,mid2,"2.28") (*yajFaxawwena xevaxawwaH pATaM kAriwaH *) 
                         ]
                    else if members_of rt2 upasarga2 aaxikarma_verbs
                    then [ Relation (id1,mid1,"prayojakakarwA",id2,mid2,"2.29") (* AxikarmaNi,gawyarWAkarmaka... *) 
                         ; Relation (id1,mid1,"prayojyakarwA",id2,mid2,"2.30") 
                         ; Relation (id1,mid1,"karma",id2,mid2,"2.31") 
                         ]
                    else []
                   ]
                   else []
             | 2 ->  if not (member_of word1 kAlAXvas)
                     then match verb_type rt2 upasarga2 with
                   ["akarmaka" -> [ Relation (id1,mid1,"prayojyakarwA",id2,mid2,"2.32")] 
                   | "xvikarmakas1" ->  [ Relation (id1,mid1,"muKyakarma",id2,mid2,"2.33")] 
                   | "xvikarmakas2" ->  [ Relation (id1,mid1,"gONakarma",id2,mid2,"2.34")] 
                   | _ -> if rt1="arWa" && compound word1 uwwarapaxa1
                          then [ Relation (id1,mid1,"prayojanam",id2,mid2,"2.35")] 
                          else if rt1="pUrvaka" && compound word1 uwwarapaxa1 && lifgam1="napuM"
                          then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"2.36")] 
                          else if (pUrvapaxa1="sa") && lifgam1="napuM"
                          then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"2.37")] 
                          else if (uwwarapaxa1=pUrvapaxa1 ) || (pUrvapaxa1="a")
		          then [ Relation (id1,mid1,"karma",id2,mid2,"2.38")] 
                          else [ Relation (id1,mid1,"prayojyakarwA",id2,mid2,"2.39") 
                               ; Relation (id1,mid1,"karma",id2,mid2,"2.40") 
                               ]
                   ]
                   else []
             | 3 ->  if not (member_of word1 kAlAXvas)
		     then match verb_type rt2 upasarga2 with
                  ["gawi" -> [ Relation (id1,mid1,"prayojakakarwA",id2,mid2,"2.41")] 
                  | "xvikarmakas1"
                  | "xvikarmakas2" -> [ Relation (id1,mid1,"prayojakakarwA",id2,mid2,"2.42") 
                             ; Relation (id1,mid1,"prayojyakarwA",id2,mid2,"2.43") 
                             ]
                  |_ -> if members_of rt2 upasarga2 shliR_Axi_verbs 
                    then [ Relation (id1,mid1,"prayojakakarwA",id2,mid2,"2.44")] 
                    else if members_of rt2 upasarga2 aaxikarma_verbs
                    then [ Relation (id1,mid1,"prayojakakarwA",id2,mid2,"2.45") 
                         ; Relation (id1,mid1,"prayojyakarwA",id2,mid2,"2.46") 
                         ]
                    else []
                 ]
                   else []
              | _ -> []
              ]
        | "kwavawu" -> match viBakwiH1 with
                   [ 1 -> if noun_agreement vacanam1 vacanam2 lifgam1 lifgam2
                      then [ Relation (id1,mid1,"prayojakakarwA",id2,mid2,"2.47")]   
                      else []
                   | 2 -> if not (member_of word1 kAlAXvas)
                             && members_of rt2 upasarga2 sakarmaka_verbs
                      then [ Relation (id1,mid1,"prayojyakarwA",id2,mid2,"2.48")] (* To write and check *) 
                    else []
                   | _ -> []
                   ]
          | "wavya"  
          | "wavyaw"  
          | "anIyar"  
          | "yaw"  
          | "kyap"  
          | "Nyaw"
          | "Kal"
          | "yuc"   -> if members_of rt2 upasarga2 sakarmaka_verbs && (pUrvapaxa2=uwwarapaxa2 || pUrvapaxa2="a")
              then [ Relation (id1,mid1,"karma",id2,mid2,"2.49")] 
            else []
          | "SAnac_lat" 
          | "SAnac_lqt" 
          | "Sawq_lat" 
          | "Sawq_lqt" ->  if viBakwiH1=2 && (members_of rt2 upasarga2 sakarmaka_verbs) && not (uwwarapaxa1="pUrvaka")
                         then [ Relation (id1,mid1,"karma",id2,mid2,"2.50")] 
                         else if rt1="arWa" && compound word1 uwwarapaxa1
                         then [ Relation (id1,mid1,"prayojanam",id2,mid2,"2.51")]
                         else if rt1="pUrvaka" && compound word1 uwwarapaxa1 && lifgam1="napuM"
                         then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"2.52")] 
                         else if (pUrvapaxa1="sa") && lifgam1="napuM"
                         then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"2.53")] 
                         else []
          | _ ->  []
          ]
     else []
     | _-> []
     ]
  | _ -> []
  ]
;
(* Verb - Noun relations:

   Examples: vqkRAw parNam pawawi
   ;grAmAw gawam rAmam SyAmaH paSyawi 
   ;grAmawaH SyAmaH AgacCawi
   Paninian sutra: apAxAne paFcamI

   Examples: piwA rAmAya puswakam xaxAwi
        ;piwA rAmAya xAwum puswakam krINAwi
        ;piwA rAmAya xawwam Palam KAxawi 
   Paninian sutra: sampraxAne cawurWI 

   Example: rAmaH xAwreNa pAxapam lunAwi
        rAmaH SyAmena xAwreNa lunam pAxapam paSyawi 
   Paninian sutra: (karwq)karaNayoH wqwIyA

   Examples: rAmaH aXyayanena grAme vasawi
         jIviwasya hewoH api Xarmam na wyajew.
   Paninian sutra: 

  Examples: vqkRe sWiwam rAmam SyAmaH kaWAm kaWayawi
        ;kapiH vqkRe vasawi
        ;grAme vasiwum rAmaH icCawi
  Paninian sutra: AXAro aXikaraNam

  Examples:rAmaH yuxXAya wvarayA/vegena gacCawi.
       rAmaH brAhmaNAya paTanAya puswakam xaxAwi.
  Paninian sutra:  (prayojana) 
 
  rAmaH SyAmasya gqham gacCawi
  Paninian sutra: ReRe RaRTI
*)

value anaBihiwe m1 m2 id1 mid1 rt1 word1 uwwarapaxa1 lifgam1 viBakwiH1 id2 mid2 rt2 upasarga2 text_type =
   match viBakwiH1 with
       [ 3 -> if (no_boundary_crossing id1 id2)
	      then if (member_of word1 kAlAXvas)
              then [ Relation (id1,mid1,"apavarga_sambanXa",id2,mid2,"3.1") (* xevaxawwena mAsena pATaH aXIwaH apavarge wqwIyA A 2.3.6 *)  (* yogyawA *)
                   ]
              else if (member_of (uwwarapaxa1^" "^string_of_int viBakwiH1) kriyAviSeRaNas) (* yogyawA *) (*&& lifgam1="napuM"*)
              then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"3.2") (* vegena XAvawi *)  (* yogyawA *)
                   ]
              else if members_of rt2 upasarga2 karaNa_verbs
              then if not (member_of rt1 guNa) || pronominal123 rt1
              then [ Relation (id1,mid1,"karaNam",id2,mid2,"3.3") ]  (*karwq karaNayoswqwIyA - yAnena gacCawi*) 
              else [ Relation (id1,mid1,"hewuH",id2,mid2,"3.4") ]
              else if (rt2="sam_jFA2")
                     (* samjFonyawarasyAm karmaNi A. 2.3.22 -mAwrA saFjAnIwe *) 
                    || (rt2="hU1" && text_type="Vedic")
                     (* wqwIyA ca hoSCanxasi A 2.3.3 - yavAgvA juhowi *)
              then if not (member_of rt1 guNa) || pronominal123 rt1
              then [ Relation (id1,mid1,"karma",id2,mid2,"3.5") ]
              else [ Relation (id1,mid1,"hewuH",id2,mid2,"3.6") ]
              else if not (member_of rt1 guNa) (* Is this condition necessary ? *)
              then [ Relation (id1,mid1,"hewuH",id2,mid2,"3.7") ] (* annena vasawi *) 
              else []
              else []
           (* anaBihiwa karwA -> rlanaBihiwakarwA *)
       | 4 ->  if (no_boundary_crossing id1 id2)
           then if members_of rt2 upasarga2 sampraxAna_verbs
           then [ Relation (id1,mid1,"sampraxAnam",id2,mid2,"3.8") ] (*cawurWI sampraxAne 2-3-13  viprAya xaxAwi *) 
           else if    members_of rt2 upasarga2 gawyarWa_verbs 
               || rt2="man1"
            then [ Relation (id1,mid1,"karmasamAnAXikaraNam",id2,mid2,"3.9")  
             (* gawyarWakarmaNi xviwIyAcawurWyO ceRtAyAmanaXvani 2-3-12 rAmaH grAmAya gacCawi,
                manyakarmaNyanAxare viBARAZprANiRu 2-3-17 ahaM wvAM wqNAya manye / aham wvA wqNAya manye *)
             ; Relation (id1,mid1,"prayojanam",id2,mid2,"3.10") (* puwrAya puswakaM krINAwi *) 
             ]
            else [ Relation (id1,mid1,"prayojanam",id2,mid2,"3.11")] 
            else []
       | 5 -> if (no_boundary_crossing id1 id2)
            then if members_of rt2 upasarga2 apAxAna_verbs
            then if not(member_of rt1 guNa) || pronominal123 rt1
            then [ Relation (id1,mid1,"apAxAnam",id2,mid2,"3.12")]  (* apAxAne paFcamI  - rAmaH grAmAw AgacCawi *) 
            else [ Relation (id1,mid1,"hewuH",id2,mid2,"3.13") ]
            else if   rt1="swoka" 
                   || rt1="alpa" 
                   || rt1="kqcCra"
                   || rt1="kawipaya"
            then [ Relation (id1,mid1,"karaNam",id2,mid2,"3.14")] 
             (* karaNe ca swokAlpakqcCrakawipayasyAsawwvavacanasya 2-3-33 - swokAw mukwaH *)
            else if (member_of rt1 guNa) (* yogyawA *)
            then [ Relation (id1,mid1,"hewuH",id2,mid2,"3.15")] (* viBARA guNe swriyAm 2-3-25 - jAdyAw baxXaH*)  
            else if (member_of word1 kAlAXvas)
            then [ Relation (id1,mid1,"aXikaraNam",id2,mid2,"3.16") ] (* sapwamIpaFcamyO kArakamaXye A 2.3.7 *)
            else [ Relation (id1,mid1,"hewuH",id2,mid2,"3.17") ] (* हेतौ पञ्चमी वा स्यादिस्यर्थः।A bAlamanorama tIkA *)
          (* Handle prAsAxAw prekRyawe and AsanAw prekRyawe *)
            else if word1="wasmAw" || word1="yasmAw"
            then [ Relation (id1,mid1,"hewuH",id2,mid2,"3.18")]  
	    else []
       | 6 -> if (no_boundary_crossing id1 id2)
               && (  rt2="vi_ava_hq1" || rt2="paNa1" || rt2="xiv1")
          then [ Relation (id1,mid1,"karma",id2,mid2,"3.19") ]  
           (* vyavahqpaNoH samarWayoH 2-3-57 -- Sawasya vyavaharawi,
              xivaswaxarWasya 2-3-58 xiv1 if it is in vyavahAra arWa-- Sawasya xIvyawi*)
            else []
       | 7  -> if not  (upasarga2="aXi" && (rt2="SIf1" || rt2="sWA1"))
               then [ Relation (id1, mid1, (aXikaraNa_type word1 rt1), id2, mid2,"3.20") ]
               else [] 
               (*then match m1 with
               [  Kqw (id1,mid1,word1,_,_,_,kqw_prawyayaH1,_,_,_,rt1,_,_,_,viBakwiH1,_,_) ->
                   if not (kqw_prawyayaH1="Sawq_lat" 
                        || kqw_prawyayaH1="SAnac" 
                        || kqw_prawyayaH1="kwa" 
                        || kqw_prawyayaH1="kwavawu") 
                      (* covered in BAvalakRaNa sapwamI 
                         praBAwe -- Sawq_lat; is aXikaraNa  Hence above condition is commented 14 April 2017 *)
                  then  [ Relation (id1, mid1, (aXikaraNa_type word1 rt1), id2, mid2,"3.16")] 
                  else [] 
               | _ -> [ Relation (id1, mid1, (aXikaraNa_type word1 rt1), id2, mid2,"3.17") ]
               ]
               else [] *)
       | 8 ->  match m2 with
           [ Wif (id2,mid2,_,rt2,_,_,upasarga2,sanAxiH2,_,lakAraH2,puruRaH2,_,_,_,_,_) -> if compound word1 uwwarapaxa1  || rt1="brahma" || rt1 = "miwra" || not (lifgam1 = "napuM")
             (* if ((lakAraH2="lot") && (puruRaH2="ma"))
              then [ Relation (id1,mid1,"samboXyaH",id2,mid2,"3.14")]
              else [] *)
              then [ Relation (id1,mid1,"samboXyaH",id2,mid2,"3.21")]
              else [ ]
           | Kqw (id2,mid2,_,_,_,_,kqw_prawyayaH2,_,_,_,_,_,_,_,viBakwiH2,_,_) -> 
               if (kqw_prawyayaH2="kwa" || kqw_prawyayaH2="kwavawu" || kqw_prawyayaH2="ac" || kqw_prawyayaH2="yaw") && (viBakwiH2=1) && id2 = total_wrds.val  
    (*           
Counter ex for napum: anawa-rUpa wvayA viSvam wawam
if (not (lifgam1="napuM") && kqw_prawyayaH2="kwa" || kqw_prawyayaH2="kwavawu" || kqw_prawyayaH2="ac" || kqw_prawyayaH2="yaw") && (viBakwiH2=1) && id2 = total_wrds.val  *)
               then [ Relation (id1,mid1,"samboXyaH",id2,mid2,"3.22")]
              else []
           |  _ -> []
           ]
       | 1  
       | 2  -> (* covered in rlwifkarwA_karma and rlkqwkarwA_karma *)
           if (member_of word1 kAlAXvas)
           then [ Relation (id1,mid1,"awyanwasaMyoga_sambanXa",id2,mid2,"3.23")] (* xevaxawwaH mAsam pATam aXIwe kAlAXvanorawyanwasaMyoge A 2.3.5 *)  (* yogyawA *)
           else if member_of (uwwarapaxa1^" "^string_of_int viBakwiH1) kriyAviSeRaNas (* yogyawA *) && lifgam1="napuM"
           then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"3.24")] 
           else [] (* rlwifanaBihiwakarma rlkqwanaBihiwakarma *)
       | _ -> [] (* raise an exception *)
       ]
;

value rlanaBihiwe m1 m2 text_type = match m2 with
  [ Wif (id2,mid2,_,rt2,_,_,upasarga2,sanAxiH2,_,_,_,_,_,_,_,_)
  | Avykqw (id2,mid2,_,rt2,_,_,upasarga2,sanAxiH2,_,_,_,_) -> 
     match m1 with
     [ Sup (id1,mid1,word1,rt1,_,uwwarapaxa1,lifgam1,viBakwiH1,_,_) ->
       if id1 < id2 
       then anaBihiwe m1 m2 id1 mid1 rt1 word1 uwwarapaxa1 lifgam1 viBakwiH1 id2 mid2 rt2 upasarga2 text_type
       else []
     | Kqw (id1,mid1,word1,_,_,_,kqw1,_,_,_,rt1,_,uwwarapaxa1,lifgam1,viBakwiH1,_,_) ->
       if id1 < id2 
       then if (* kqw1="wqc" && *) viBakwiH1=3
       then [ Relation (id1,mid1,"hewuH",id2,mid2,"3.25")] 
       else anaBihiwe m1 m2 id1 mid1 rt1 word1 uwwarapaxa1 lifgam1 viBakwiH1 id2 mid2 rt2 upasarga2 text_type
       else []
     | WaxXiwa (id1,mid1,word1,rt1,_,uwwarapaxa1,_,waxXiwa_prawyayaH1,lifgam1,viBakwiH1,_,_) -> 
       if waxXiwa_prawyayaH1="wva" && viBakwiH1=5
       then [ Relation (id1,mid1,"hewuH",id2,mid2,"3.26")] 
       else anaBihiwe m1 m2 id1 mid1 rt1 word1 uwwarapaxa1 lifgam1 viBakwiH1 id2 mid2 rt2 upasarga2 text_type
     | _ -> []
     ]
  | Kqw (id2,mid2,_,rt2,upasarga2,sanAxiH2,_,_,_,_,_,_,_,_,viBakwiH2,_,_) ->
       match m1 with
       [ Sup (id1,mid1,word1,rt1,_,uwwarapaxa1,lifgam1,viBakwiH1,_,_)
       | Kqw (id1,mid1,word1,_,_,_,_,_,_,_,rt1,_,uwwarapaxa1,lifgam1,viBakwiH1,_,_)
       | WaxXiwa (id1,mid1,word1,rt1,_,uwwarapaxa1,_,_,lifgam1,viBakwiH1,_,_) -> 
            if id1 < id2 && not (viBakwiH2 = 8)
            then anaBihiwe m1 m2 id1 mid1 rt1 word1 uwwarapaxa1 lifgam1 viBakwiH1 id2 mid2 rt2 upasarga2 text_type
            else []
       | _ -> []
       ]
  | _ -> []
  ]
  ;


value rlAvykqw_karma m1 m2 text_type = match m2 with
  [ Avykqw (id2,mid2,_,rt2,_,_,upasarga2,sanAxiH2,_,_,_,_) ->
     match m1 with
     [ WaxXiwa (id1,mid1,word1,rt1,pUrvapaxa1,uwwarapaxa1,_,_,lifgam1,viBakwiH1,vacanam1,_) 
     | Kqw (id1,mid1,word1,_,_,_,_,_,_,_,rt1,pUrvapaxa1,uwwarapaxa1,lifgam1,viBakwiH1,vacanam1,_)
     | Sup (id1,mid1,word1,rt1,pUrvapaxa1,uwwarapaxa1,lifgam1,viBakwiH1,vacanam1,_) -> 
       if  prose_order id1 id2 text_type && (no_boundary_crossing id1 id2)
       then match viBakwiH1 with
        [ 2 -> if not (member_of word1 kAlAXvas)
              then match verb_type rt2 upasarga2 with
              [ "xvikarmakas1" 
              | "xvikarmakas2" -> [ Relation (id1,mid1,"gONakarma",id2,mid2,"4.1" )  
                                (* karmaNi xviwIyA  - rAjAnaM vasuXAM yAcawe*)
                               ; Relation (id1,mid1,"muKyakarma",id2,mid2,"4.2" )  
                                (* karmaNi xviwIyA - gAM xogXi payaH *)
                                  ]
              | "gawi"
              | "buxXi" 
              | "Sabxakarma" 
              | "prawyavasAnArWa"
              | "sakarmaka" -> if not (sanAxiH2="Nic")
                               then if rt1="arWa" && compound word1 uwwarapaxa1
                                    then [ Relation (id1,mid1,"prayojanam",id2,mid2,"4.3")] 
                                    else if rt1="pUrvaka" && compound word1 uwwarapaxa1 && lifgam1="napuM"
                                    then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"4.4")] 
                                    else if (pUrvapaxa1="sa") && lifgam1="napuM"
                                    then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"4.5")] 
                                    else if (uwwarapaxa1=pUrvapaxa1 ) || (pUrvapaxa1="a")
		                    then [ Relation (id1,mid1,"karma",id2,mid2,"4.6")]
                                    else [ Relation (id1,mid1,"karma",id2,mid2,"4.7" )] (* karmaNi xviwIyA *) 
                               else [ Relation (id1,mid1,"prayojyakarwA",id2,mid2,"4.8") 
                                    ; Relation (id1,mid1,"karma",id2,mid2,"4.9") 
                                    ]
              | "akarmaka" -> if (sanAxiH2="Nic")
                              then [ Relation (id1,mid1,"karma",id2,mid2,"4.10")] 
                              else if rt1="arWa" && compound word1 uwwarapaxa1
                              then [ Relation (id1,mid1,"prayojanam",id2,mid2,"4.11")] 
                              else if rt1="pUrvaka" && compound word1 uwwarapaxa1 && lifgam1="napuM"
                              then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"4.12")] 
                              else if (pUrvapaxa1="sa") && lifgam1="napuM"
                              then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"4.13")] 
                              else []
              | _ -> []
              ]
              else []
        | _ -> []
        ]
        else []
    | _ -> []
    ]
  | _ -> []
  ]
;

(* Examples: grAmawaH ganwum icCanwam rAmam SyAmaH kaWAm kaWayawi *)
value rlapAxAna_wasil m1 m2 text_type = match m2 with
  [ Wif (id2,mid2,_,rt2,_,_,upasarga2,_,_,_,_,_,_,_,_,_)
  | Kqw (id2,mid2,_,rt2,upasarga2,_,_,_,_,_,_,_,_,_,_,_,_) 
  | Avykqw (id2,mid2,_,rt2,_,_,upasarga2,_,_,_,_,_) ->
     match m1 with
     [ AvywaxXiwa (id1,mid1,_,rt1,_,_,taddhita1,_)->
       if prose_order id1 id2 text_type  && taddhita1="wasil" && (no_boundary_crossing id1 id2)
       then if members_of rt2 upasarga2 apAxAna_verbs && (not(member_of rt1 guNa) || pronominal123 rt1)
       then [ Relation (id1,mid1,"apAxAnam",id2,mid2,"5.1")] 
     (*  This leads to over generalisation, since only few waH ending words are kriyAviSeRaNas. We list them in the kriyAviSeRaNa list
 else if not (member_of rt1 xravyavAcI) 
       then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"5.2")]  *)
       else  [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"5.2")] 
       else []
     |_ -> []
     ]
  | _ -> []
  ]
  ;
(* aSvaH vegena XAvawi.*)
(* ;rAmaH brAhmaNavaw aXIwe *)
value rlAvy_kriyAviSeRaNam_or_aXikaraNam m1 m2 text_type = match m2 with
  [ Wif (id2,mid2,_,rt2,_,_,_,_,_,_,_,_,_,_,_,_)
  | Kqw (id2,mid2,_,rt2,_,_,_,_,_,_,_,_,_,_,_,_,_)
  | Avykqw (id2,mid2,_,rt2,_,_,_,_,_,_,_,_) -> 
     match m1 with
     [ Avykqw (id1,mid1,word1,rt1,_,uwwarapaxa1,_,_,_,_,_,_)
     | Avy (id1,mid1,word1,rt1,_,uwwarapaxa1,_) -> 
       if prose_order id1 id2 text_type 
       then if word1="yaxA" 
            then if id2 < waxA_pos.val 
                 then kv_or_spl_aXi id1 mid1 id2 mid2 uwwarapaxa1 
                 else []
            else kv_or_spl_aXi id1 mid1 id2 mid2 uwwarapaxa1
       else []
     | AvywaxXiwa (id1,mid1,word1,rt1,_,uwwarapaxa1,taddhita1,_) -> 
       if prose_order id1 id2 text_type && taddhita1="vaw" 
       then [ Relation (id1,mid1,"kriyAviSeRaNam",id2,mid2,"6.1")]
       else kv_or_spl_aXi id1 mid1 id2 mid2 uwwarapaxa1 
     (* | Sup (id1,mid1,word1,_,_,uwwarapaxa1,_,_,_,_)->
       if  prose_order id1 id2 text_type 
       then kv_or_spl_aXi id1 mid1 id2 mid2 uwwarapaxa1
       else [] 
    This is covered under anaBihiwe 3.20 *)
     |_ -> []
     ]
  | _ -> []
  ]
  ;

value rlviRayAXikaraNam m1 m2 text_type = match m2 with
   [ Sup (id2,mid2,_,rt2,_,_,_,_,_,_)
   | Kqw (id2,mid2,_,_,_,_,_,_,_,_,rt2,_,_,_,_,_,_)
   | WaxXiwa (id2,mid2,_,rt2,_,_,_,_,_,_,_,_) -> 
      match m1 with
      [ Sup (id1,mid1,_,_,_,_,_,viBakwiH1,_,_)
      | Kqw (id1,mid1,_,_,_,_,_,_,_,_,_,_,_,_,viBakwiH1,_,_)
      | WaxXiwa (id1,mid1,_,_,_,_,_,_,_,viBakwiH1,_,_) ->
       if prose_order id1 id2 text_type && (no_boundary_crossing id1 id2)
       then match viBakwiH1 with
       [ 7 -> if member_of rt2 viRayAXikaraNa_nouns
          then [ Relation (id1,mid1,"viRayAXikaraNam",id2,mid2,"7.1")] 
          else []
       | _ -> []
       ]
       else []
      | _ -> []
      ]
   | _ -> []
   ]
;

(* ;saH prasannaH BUwvA mAwaram avaxaw. 
 ;saH api paramAwmA iva pUrNaH Baviwum icCawi
;   saH prasannaH aBavaw.
;saH(S2) SvewaH(S1) aswi(W).
;vexAH pramANam sanwi.
;vAsaH a-niyawam Bavawi
;neharO asya prawikriyA kA AsIw. *)

value rlwAxarWya m1 m2 m3 text_type = match m3 with
   [ Wif (id3,mid3,_,rt3,_,_,upasarga3,_,_,_,puruRaH3,vacanam3,_,_,_,_) ->
      match m2 with
       [ Sup (id2,mid2,_,rt2,_,_,_,_,_,_)
       | Kqw (id2,mid2,_,_,_,_,_,_,_,_,_,rt2,_,_,_,_,_)
       | Avy (id2,mid2,_,rt2,_,_,_)
       | Avykqw (id2,mid2,_,rt2,_,_,_,_,_,_,_,_)
       | AvywaxXiwa (id2,mid2,_,rt2,_,_,_,_)
       | WaxXiwa (id2,mid2,_,rt2,_,_,_,_,_,_,_,_) -> 
      match m1 with
      [ Sup (id1,mid1,_,rt1,_,_,_,viBakwiH1,_,_)
      | Kqw (id1,mid1,_,_,_,_,_,_,_,_,rt1,_,_,_,viBakwiH1,_,_)
      | WaxXiwa (id1,mid1,_,rt1,_,_,_,_,_,viBakwiH1,_,_) ->
         if (id1=previous id2) (*|| id1=next id2 *)
         then match viBakwiH1 with
          [ 4  -> if   members_of rt3 upasarga3 karwqsamAnAXikaraNa_verbs 
                    && rt2 = get_assoc rt1 wAxarWya_list
                  then [ Relation (id1,mid1,"wAxarWya",id2,mid2,"8.1") ] 
                  else []
          | _ -> []
          ]
          else [] 
      | _ -> []
      ]
    | _ -> []
    ]
      | _ -> []
      ]
;

(* Verb-verb relations *)
(* rAmaH xugXam pIwvA vanam gacCawi *)
(* assign_assign_prayojana_avykqw *)
value rlpUrvakAla m1 m2 text_type = match m2 with
  [ Wif (id2,mid2,_,rt2,_,_,_,_,_,_,_,_,_,_,_,_)
  | Kqw (id2,mid2,_,rt2,_,_,_,_,_,_,_,_,_,_,_,_,_)
  | Avykqw (id2,mid2,_,rt2,_,_,_,_,_,_,_,_) ->
     match m1 with
     [ Avykqw (id1,mid1,_,_,_,_,_,_,kqw1,_,_,_) ->
       if prose_order id1 id2 text_type 
       then if (kqw1="kwvA" || kqw1="lyap")
        then [ Relation (id1,mid1,"pUrvakAlaH",id2,mid2,"9.1")] 
             (* samAna karwqkayoH pUrvakAle  rAmaH xugXam pIwvA vanam gacCawi*)  
        else []
        else []
     | _ -> []
     ]
   | _ -> []
   ]
;

(* rAmaH puswakam paTiwum gqham gacCawi 
 rAmaH puswakam paTiwum gacCanwam bAlakam paSyawi. *)
(* rAmaH puswakam paTiwum Saknowi *)
value rlwumun m1 m2 text_type = match m2 with
  [ Wif (id2,mid2,_,rt2,_,_,upasarga2,_,_,_,_,_,_,_,_,_)
  | Avykqw (id2,mid2,_,rt2,_,_,upasarga2,_,_,_,_,_) ->
     match m1 with
     [ Avykqw (id1,mid1,_,_,_,_,_,_,kqw1,_,_,_) ->
      if prose_order id1 id2 text_type && kqw1="wumun" && (no_boundary_crossing id1 id2)
      then if (rt2="iR2" || rt2="icCuka") 
           then [ Relation (id1,mid1,"karma",id2,mid2,"10.1")] 
           else if (members_of rt2 upasarga2 shakAxi)
            then [ Relation (id1,mid1,"sahAyakakriyA",id2,mid2,"10.2")]
            else [ Relation (id1,mid1,"prayojanam",id2,mid2,"10.3")]
      else []
     | _ -> []
     ]
  | Kqw (id2,mid2,_,rt2,upasarga2,_,_,_,_,_,_,_,_,_,viBakwiH2,_,_) ->
     match m1 with
     [ Avykqw (id1,mid1,_,_,_,_,_,_,kqw1,_,_,_) ->
      if prose_order id1 id2 text_type && kqw1="wumun" && not (viBakwiH2 = 8) 
         && (no_boundary_crossing id1 id2)
      then if (rt2="iR2" || rt2="icCuka") 
           then [ Relation (id1,mid1,"karma",id2,mid2,"10.4")] 
           else if (members_of rt2 upasarga2 shakAxi)
            then [ Relation (id1,mid1,"sahAyakakriyA",id2,mid2,"10.5")]
            else [ Relation (id1,mid1,"prayojanam",id2,mid2,"10.6")]
      else []
     | _ -> []
     ]
  | _ -> []
  ]
;
value rlkwa_as m1 m2 text_type = match m2 with
  [ Wif (id2,mid2,_,rt2,_,_,_,_,_,_,_,_,_,_,_,_) ->
     match m1 with
     [ Kqw (id1,mid1,_,_,_,_,kqw1,_,_,_,_,_,_,_,_,_,_) ->
       if prose_order id1 id2 text_type && rt2="as1" && (kqw1="kwa"|| kqw1="kwavawu") && (no_boundary_crossing id1 id2)
       then [ Relation (id1,mid1,"sahAyakakriyA",id2,mid2,"10.7")]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
;
(* assign_samAnakAlikawvam *)
(* rAmaH grAmam gacCan wqNam spqSawi. *)
value rlsamAnakAla m1 m2 text_type = match m1 with
  [ Kqw (id1,mid1,_,_,_,_,kqw1,_,_,_,_,_,_,_,viBakwiH1,_,_) -> match m2 with
       [ Wif (id2,mid2,_,_,_,_,_,_,_,_,_,_,_,_,_,_) ->
          if     prose_order id1 id2 text_type 
            && (no_boundary_crossing id1 id2)
            && (kqw1="Sawq_lat" || kqw1="SAnac_lat") 
            && viBakwiH1=1
          then [ Relation (id1,mid1,"samAnakAlaH",id2,mid2,"11.1")]
          else []
       | Kqw (id2,mid2,_,_,_,_,_,_,_,_,_,_,_,_,viBakwiH2,_,_) ->
          if     prose_order id1 id2 text_type 
            && (no_boundary_crossing id1 id2)
            && (kqw1="Sawq_lat" || kqw1="SAnac_lat") 
            && viBakwiH1=1 && not (viBakwiH2 = 8)
          then [ Relation (id1,mid1,"samAnakAlaH",id2,mid2,"11.2")]
          else []
       |_ -> []
       ]
  | _ -> []
  ]
;
(* Noun Noun relation *)
(* assign_noun_viSeRaNa *)
(* grAmam gacCanwam rAmam SyAmaH paSyawi. *)
(* yogyawA *)
value rlviSeRaNam m1 m2 text_type = match m2 with
  [ Sup (id2,mid2,word2,rt2,_,uwwarapaxa2,lifgam2,viBakwiH2,vacanam2,_)
  | Kqw (id2,mid2,word2,_,_,_,_,_,_,_,rt2,_,uwwarapaxa2,lifgam2,viBakwiH2,vacanam2,_)
  | WaxXiwa (id2,mid2,word2,rt2,_,uwwarapaxa2,_,_,lifgam2,viBakwiH2,vacanam2,_) -> 
(*  THere is a problem with sentences such as 
aham Bavanwam anviRyan upAgamaH
I think Head can not be kqw or waxxXiwa *)
   match m1 with
      [ Sup (id1,mid1,word1,rt1,pUrvapaxa1,uwwarapaxa1,lifgam1,viBakwiH1,vacanam1,_) ->
       if prose_order id1 id2 text_type
       && (no_boundary_crossing id1 id2)
       && (noun_agreement_vibh vacanam1 vacanam2 lifgam1 lifgam2 viBakwiH1 viBakwiH2) 
       (*&& not (member_of (word2^" "^string_of_int viBakwiH2) kriyAviSeRaNas) (* why is this cond? *)*)
(* pronoun3 -> pronominal123: mayA avyakwa-mUrwinA from SBG *)
       then if ( pronominal123 rt1 || member_of rt1 saMKyeya || member_of rt1 pUraNa || member_of rt1 kqxanwas || member_of rt1 taddhitaantas || member_of rt1 guNavacana ||
(* To account for both words to be compounds *)
(* (member_of rt1 uwwara_guNavAcI && not (compound_hd1=word1)) *)
(compound word1 uwwarapaxa1 && not (rt1="arWa") && not (rt1="pUrvaka")))
       (* && not (rt2="yax") && not (rt2="wax") *) 
(* Whether to allow yax/wax or not: 
What are the pros and cons of allowing Vs not allowing?
We can have vyAkulaH saH, and also ye janAH ...*)
       && (not(rt1=rt2) || (compound word1 uwwarapaxa1) || (compound word2 uwwarapaxa2)) 
       && (not (member_of rt1 sambanXavAcI) || compound word1 uwwarapaxa1)
       && not (rt1="arWa" && compound word1 uwwarapaxa1)
       && not (rt1="pUrvaka" && compound word1 uwwarapaxa1)
       (* && not (pUrvapaxa1="sa") if the word agrees in g,n,v then mark it as a possible viseRaNam *)
       then [ Relation (id1,mid1,"viSeRaNam",id2,mid2,"12.1")]
       else if member_of rt1 sambanXavAcI (* && not (member_of rt2 sambanXavAcI) Why this condition? counter ex: wava XImawA SiRyeNa xrupaxa-puwreNa *)
       then [ Relation (id1,mid1,"aBexa",id2,mid2,"12.2")]
       else []
       else []
     | AvywaxXiwa (id1,mid1,word1,rt1,pUrvapaxa1,uwwarapaxa1,_,_) ->
       if prose_order id1 id2 text_type
       && (no_boundary_crossing id1 id2)
       && (compound word1 uwwarapaxa1)
       then [ Relation (id1,mid1,"viSeRaNam",id2,mid2,"12.3")]
       else []
     | WaxXiwa (id1,mid1,_,rt1,_,_,_,_,lifgam1,viBakwiH1,vacanam1,_) ->
       if prose_order id1 id2 text_type
            && (no_boundary_crossing id1 id2)
        && noun_agreement_vibh vacanam1 vacanam2 lifgam1 lifgam2 viBakwiH1 viBakwiH2
        && not (member_of (word2^" "^string_of_int viBakwiH2) kriyAviSeRaNas) (* Why is this cond? *)
        && not(rt1=rt2) && (no_boundary_crossing id1 id2)
       then [ Relation (id1,mid1,"viSeRaNam",id2,mid2,"12.4")]
       else []
     | Kqw (id1,mid1,_,_,_,_,kqw_prawyayaH1,_,_,_,rt1,_,_,lifgam1,viBakwiH1,vacanam1,_) ->
       if prose_order id1 id2 text_type
            && (no_boundary_crossing id1 id2)
       && ((viBakwiH1=viBakwiH2 && vacanam1=vacanam2 && niyawalifga kqw_prawyayaH1)
           || (noun_agreement_vibh vacanam1 vacanam2 lifgam1 lifgam2 viBakwiH1 viBakwiH2 && not (kqw_prawyayaH1="lyut")))
       && not (member_of (word2^" "^string_of_int viBakwiH2) kriyAviSeRaNas) (* Why is this cond? *)
       && not(rt1=rt2) && (no_boundary_crossing id1 id2)
       then [ Relation (id1,mid1,"viSeRaNam",id2,mid2,"12.5")]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;

(*

Why do we need parimANa viSeRaNa seperately? 
value rlparimANa_viSeRaNam m1 m2 text_type = match m1 with
  [ Sup (id1,mid1,word1,rt1,_,uwwarapaxa1,lifgam1,viBakwiH1,vacanam1,_)
  | Kqw (id1,mid1,word1,_,_,_,_,_,_,_,rt1,_,uwwarapaxa1,lifgam1,viBakwiH1,vacanam1,_)
  | WaxXiwa (id1,mid1,word1,rt1,_,uwwarapaxa1,_,_,lifgam1,viBakwiH1,vacanam1,_) -> 
   match m2 with
      [ Sup (id2,mid2,word2,rt2,_,uwwarapaxa2,lifgam2,viBakwiH2,vacanam2,_) ->
       if id2=next id1
       && (noun_agreement_vibh vacanam1 vacanam2 lifgam1 lifgam2 viBakwiH1 viBakwiH2) 
       && ( rt2="sarva" || member_of rt2 saMKyeya )
       then [ Relation (id2,mid2,"parimANa_viSeRaNam",id1,mid1,"12.6")]
       else []
      | _ -> []
      ]
  | _ -> []
  ]
  ;
*)
(* yogyawA *)
value rlavy_viSeRaNam m1 m2 text_type = match m2 with
  [ Sup (id2,mid2,_,rt2,_,_,lifgam2,viBakwiH2,vacanam2,_)
  | Kqw (id2,mid2,_,_,_,_,_,_,_,_,rt2,_,_,lifgam2,viBakwiH2,vacanam2,_)
  | WaxXiwa (id2,mid2,_,rt2,_,_,_,_,lifgam2,viBakwiH2,vacanam2,_) -> 
     match m1 with
     [ Avy (id1,mid1,word1,_,_,_,_) ->
       if id1=previous id2 && member_of word1 avy_viSeRaNam_list
       then [ Relation (id1,mid1,"viSeRaNam",id2,mid2,"13.1")]
       else if id1=previous id2 && member_of word1 intensifiers_list && not (pronominal123 rt2)
       then [ Relation (id1,mid1,"wIvrawAxarSI",id2,mid2,"13.2")]
       else []
     | Sup (id1,mid1,_,rt1,_,_,lifgam1,viBakwiH1,vacanam1,_) ->
        if id1=previous id2 && member_of rt1 intensifiers_list && not (pronominal123 rt2)
       && (noun_agreement_vibh vacanam1 vacanam2 lifgam1 lifgam2 viBakwiH1 viBakwiH2) 
       then [ Relation (id1,mid1,"wIvrawAxarSI",id2,mid2,"13.3")]
       else []
(* kevala is not an avy *)
     | _ -> []
     ]
  | _ -> []
  ]
  ;

value rlsamboXanasUcakam m1 m2 text_type = match m2 with
  [ Sup (id2,mid2,_,_,_,_,_,viBakwiH2,_,_)
  | Kqw (id2,mid2,_,_,_,_,_,_,_,_,_,_,_,_,viBakwiH2,_,_)
  | WaxXiwa (id2,mid2,_,_,_,_,_,_,_,viBakwiH2,_,_) -> 
   match m1 with
     [ Avy (id1,mid1,word1,_,_,_,_) ->
    if  id1=previous id2 
      && member_of word1 samboXana_sUcaka
      && viBakwiH2=8
       then [ Relation (id1,mid1,"samboXanasUcakam",id2,mid2,"14.1")]
       else []
     | _ -> []
     ]
  | Wif (id2,mid2,_,rt2,_,_,_,_,_,_,_,_,_,_,_,_) ->
    match m1 with
     [ Avy (id1,mid1,word1,_,_,_,_) ->
        if  member_of word1 samboXana_sUcaka
       then [ Relation (id1,mid1,"sambanXaH",id2,mid2,"14.2")]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;

value rlnirXAraNam m1 m2 text_type = match m2 with
  [ Sup (id2,mid2,_,rt2,_,_,_,viBakwiH2,vacanam2,_)
  | Kqw (id2,mid2,_,_,_,_,_,_,_,_,rt2,_,_,_,viBakwiH2,vacanam2,_) ->
   match m1 with
      [ Sup (id1,mid1,_,rt1,_,_,_,viBakwiH1,vacanam1,_)
      | Kqw (id1,mid1,_,_,_,_,_,_,_,_,rt1,_,_,_,viBakwiH1,vacanam1,_)
      | WaxXiwa (id1,mid1,_,rt1,_,_,_,_,_,viBakwiH1,vacanam1,_) ->
        if    (id1=previous id2) 
           && (viBakwiH1=6 || viBakwiH1=7)  
           && (vacanam1="xvi" || vacanam1="bahu")
           && vacanam2="eka" (* && not(viBakwiH2=8) -- xehaBUwAm vara *)
           && (rt2 = (get_assoc rt1 nirXAraNa_list) || rt2 = "kiFciw" || rt2="vara" || rt2="SreRTa")
       (* && (member_of rt2 guNavAcI || member_of rt2 sambanXavAcI) *)  (* yogyawA *)
       (* It is necessary to check  ((is_jAwi rt1) || (is_guNa rt1) || (is_kriyA rt1)); 
          jAwi-guNa-kriyABiH samuxAyAw ekasya pqWak-karaNam nirXAraNam  Under A 2.2.10 in kASikA *)
       then [ Relation (id1,mid1,"nirXAraNam",id2,mid2,"15.1")] (* 2.3.41;*)
       else []
      | _ -> []
      ]
  | WaxXiwa (id2,mid2,_,rt2,_,_,_,waxXiwa_prawyayaH2,_,viBakwiH2,vacanam2,_) -> 
   match m1 with
      [ Sup (id1,mid1,_,rt1,_,_,_,viBakwiH1,vacanam1,_)
      | Kqw (id1,mid1,_,_,_,_,_,_,_,_,rt1,_,_,_,viBakwiH1,vacanam1,_)
      | WaxXiwa (id1,mid1,_,rt1,_,_,_,_,_,viBakwiH1,vacanam1,_) ->
        if    (id1=previous id2) 
           && (viBakwiH1=6 || viBakwiH1=7)  
           && (vacanam1="xvi" || vacanam1="bahu")
           && vacanam2="eka" && not(viBakwiH2=8)
           && (rt2 = (get_assoc rt1 nirXAraNa_list) || waxXiwa_prawyayaH2="warap")
       (* && (member_of rt2 guNavAcI || member_of rt2 sambanXavAcI) *)  (* yogyawA *)
       (* It is necessary to check  ((is_jAwi rt1) || (is_guNa rt1) || (is_kriyA rt1)); 
          jAwi-guNa-kriyABiH samuxAyAw ekasya pqWak-karaNam nirXAraNam  Under A 2.2.10 in kASikA *)
       then [ Relation (id1,mid1,"nirXAraNam",id2,mid2,"15.2")] (* 2.3.41;*)
       else []
      | _ -> []
      ]
  | _ -> []
  ]
  ;

(* A sort of phrase formation: upapaxa and vIpsA *)

value rlvIpsA m1 m2 text_type = match m2 with
  [ Sup (id2,mid2,word2,rt2,_,_,lifgam2,viBakwiH2,vacanam2,_) -> match m1 with
     [ Sup (id1,mid1,word1,rt1,_,_,lifgam1,viBakwiH1,vacanam1,_) -> 
      supAxi_vIpsa id1 id2 mid1 mid2 word1 word2 rt1 vacanam1 vacanam2 lifgam1 lifgam2 viBakwiH1 viBakwiH2 "16.1"
     | _ -> []
     ]
  | Kqw (id2,mid2,word2,_,_,_,_,_,_,_,rt2,_,_,lifgam2,viBakwiH2,vacanam2,_) -> match m1 with
     [ Kqw (id1,mid1,word1,_,_,_,_,_,_,_,rt1,_,_,lifgam1,viBakwiH1,vacanam1,_) ->
      supAxi_vIpsa id1 id2 mid1 mid2 word1 word2 rt1 vacanam1 vacanam2 lifgam1 lifgam2 viBakwiH1 viBakwiH2 "16.2"
     | _ -> []
     ]
  | WaxXiwa (id2,mid2,word2,rt2,_,_,_,_,lifgam2,viBakwiH2,vacanam2,_) -> match m1 with
     [ WaxXiwa (id1,mid1,word1,rt1,_,_,_,_,lifgam1,viBakwiH1,vacanam1,_) ->
      supAxi_vIpsa id1 id2 mid1 mid2 word1 word2 rt1 vacanam1 vacanam2 lifgam1 lifgam2 viBakwiH1 viBakwiH2 "16.3"
     | _ -> []
     ]
  | Avy (id2,mid2,word2,_,_,_,_) -> match m1 with
     [ Avy (id1,mid1,word1,_,_,_,_) ->
       if   id1=previous id2 
     && word1=word2
       then [ Relation (id1,mid1,"vIpsA",id2,mid2,"16.4")]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;
value rlupapaxa m1 m2 text_type = match m2 with
   [ Sup (id2,mid2,_,rt2,pUrvapaxa2,uwwarapaxa2,_,_,_,_)
   | Kqw (id2,mid2,_,_,_,_,_,_,_,_,rt2,pUrvapaxa2,uwwarapaxa2,_,_,_,_)
   | Avy (id2,mid2,_,rt2,pUrvapaxa2,uwwarapaxa2,_)
   | Avykqw (id2,mid2,_,rt2,pUrvapaxa2,uwwarapaxa2,_,_,_,_,_,_)
   | AvywaxXiwa (id2,mid2,_,rt2,pUrvapaxa2,uwwarapaxa2,_,_)
   | WaxXiwa (id2,mid2,_,rt2,pUrvapaxa2,uwwarapaxa2,_,_,_,_,_,_) -> 
      match m1 with
      [ Sup (id1,mid1,_,rt1,pUrvapaxa1,uwwarapaxa1,_,viBakwiH1,_,_)
      | Kqw (id1,mid1,_,_,_,_,_,_,_,_,rt1,pUrvapaxa1,uwwarapaxa1,_,viBakwiH1,_,_)
      | WaxXiwa (id1,mid1,_,rt1,pUrvapaxa1,uwwarapaxa1,_,_,_,viBakwiH1,_,_) ->
     if (id1=previous id2 || id1=next id2) && (pUrvapaxa2=uwwarapaxa2 || pUrvapaxa2="a")
     then match viBakwiH1 with
     [ 2  -> if (member_of rt2 upapaxa2_list) 
         then [Relation (id1,mid1,"upapaxaviBakwiH",id2,mid2,"17.1")]
         else []
     | 3  -> if (member_of rt2 upapaxa3_list) 
         then [Relation (id1,mid1,"upapaxaviBakwiH",id2,mid2,"17.2")]
         else if (rt2=(get_assoc rt1 afgavikaara_list)) (* yogyawA *)
              then [ Relation (id1,mid1,"sambanXaH",id2,mid2,"17.3") ]
              else (* if (id1=previous id2) (* yogyawA *)
               then [ Relation (id1,mid1,"iwWamBUwa",id2,mid2,"14.2") ] (* overgenerates *)
               else *) []
     | 4  -> if (member_of rt2 upapaxa4_list) 
         then [Relation (id1,mid1,"upapaxaviBakwiH",id2,mid2,"17.4")]
         else []
     | 5  -> if (member_of rt2 upapaxa5_list) 
         then [Relation (id1,mid1,"upapaxaviBakwiH",id2,mid2,"17.5")]
         else []
     | 6  -> if (member_of rt2 upapaxa6_list) 
         then [Relation (id1,mid1,"upapaxaviBakwiH",id2,mid2,"17.6")]
         else []
     | 7  -> if (member_of rt2 upapaxa7_list) 
         then [Relation (id1,mid1,"upapaxaviBakwiH",id2,mid2,"17.7")]
         else []
     | _ -> []
     ]
     else []
     | AvywaxXiwa (id1,mid1,_,_,_,_,taddhita1,_)->
        if (id1=previous id2 || id1=next id2) && (pUrvapaxa2=uwwarapaxa2 || pUrvapaxa2="a")
           && taddhita1="wasil" && (member_of rt2 upapaxa5_list)  (*prawiniXiprawixAne ca yasmAw A 2.3.11  aBimanyuH arjunawaH prawi aswi *)
         then [Relation (id1,mid1,"upapaxaviBakwiH",id2,mid2,"17.8")]
         else []
     | _ -> []
      ]
   | _ -> []
   ]
  ;

(* yogyawA *)
(* WHY do you need this function?
Are these not aXikaraNas, otherwise?

value rlupapaxa_aXikaraNa m1 m2 text_type = match m2 with
  [ Wif (id2,mid2,_,_,_,_,_,_,_,_,_,_,_,_,_,_)
  | Kqw (id2,mid2,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)
  | Avykqw (id2,mid2,_,_,_,_,_,_,_,_,_,_) ->
     match m1 with
     [ Sup (id1,mid1,word1,_,_,_,_,_,_,_)
     | Kqw (id1,mid1,word1,_,_,_,_,_,_,_,_,_,_,_,_,_,_)
     | WaxXiwa (id1,mid1,word1,_,_,_,_,_,_,_,_,_)
     | Avy (id1,mid1,word1,_,_,_,_) ->
       if id1 < id2 && member_of word1 upapaxa_aXikaraNa
       && (no_boundary_crossing id1 id2)
       then [ Relation (id1,mid1,"xeSAXikaraNam",id2,mid2,"18.1")] 
       (* Chk if all the words in upapaxa_aXikaraNa_list are xeSAXikaraNas, else we have to prepare two upapaxa axikaraNa lists: for xeSa and kAla aXikaraNas separately *)
       else []
     | _ -> [] 
     ]
  | _ -> [] 
  ]
;
*)

(* some words such as Binna can be used as upapaxas as well as viSeRaNas.
For example, in Binnam vaswu, Binna is a viSeRaNa, and in wasmAw Binnam, Binna is an upapaxa
Following function is to mark them as viSeRaNas, when they are used in that sense *)
value rlupapaxa_viSeRaNa m1 m2 text_type = match m2 with
  [ Sup (id2,mid2,_,_,_,_,_,_,_,_)
  | Kqw (id2,mid2,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)
  | WaxXiwa (id2,mid2,_,_,_,_,_,_,_,_,_,_) -> 
   match m1 with
      [ Sup (id1,mid1,word1,_,_,_,_,_,_,_)
      | Kqw (id1,mid1,word1,_,_,_,_,_,_,_,_,_,_,_,_,_,_)
      | WaxXiwa (id1,mid1,word1,_,_,_,_,_,_,_,_,_)
      | Avy (id1,mid1,word1,_,_,_,_)
      | Avykqw (id1,mid1,word1,_,_,_,_,_,_,_,_,_)
      | AvywaxXiwa (id1,mid1,word1,_,_,_,_,_) ->
    if    id1=previous id2
       && member_of word1 upapaxa_viSeRaNas
    then [ Relation (id1,mid1,"viSeRaNam",id2,mid2,"19.1")]
    else []
     | _ -> []
     ]
  | _ -> []
  ]
  ;

value rlRaRTIsambanXaH m1 m2 text_type = match m1 with
      [ Sup (id1,mid1,_,rt1,_,_,_,viBakwiH1,_,_)
      | Kqw (id1,mid1,_,rt1,_,_,_,_,_,_,_,_,_,_,viBakwiH1,_,_)
      | WaxXiwa (id1,mid1,_,rt1,_,_,_,_,_,viBakwiH1,_,_) ->
          match viBakwiH1 with
          [ 6 -> match m2 with 
                 [ Kqw (id2,mid2,_,rt2,_,_,kqw2,_,_,_,_,pUrvapaxa2,uwwarapaxa2,_,viBakwiH2,_,_) -> if   prose_order id1 id2 text_type
                   then if no_boundary_crossing id1 id2
                       && (member_of kqw2 bhaavavaaci_kqw  || kqw2 = "kwin" || kqw2 = "kwa" ||  kqw2 = "SAnac_lat" || kqw2 = "SAnac_lqt" || kqw2 = "Sawq_lat" || kqw2 = "Sawq_lqt" || kqw2 = "ac" || kqw2 = "kwavawu" || kqw2="Nvul")
(* pawriNAm viruwena *)
                       && not (viBakwiH2 = 8)
                   then [ Relation (id1,mid1,"RaRTIsambanXaH",id2,mid2,"20.1")]
                   else if   not (pUrvapaxa2=uwwarapaxa2) 
                   then if   member_of pUrvapaxa2 sambanXavAcI 
                            || pUrvapaxa2="hiwa" 
                            || pUrvapaxa2="vacana"  (* We should add all rUDa kqxanwas here *) (*rAmasya hiwakAmyayA, rAmasya vacanAnusAreNa *)
                             (* asamarWa compound *)
                   then [ Relation (id1,mid1,"RaRTIsambanXaH",id2,mid2,"20.2a")]
 (* We need to mark this relation with the puurvapaxa and not the uwwarapaxa *)
                   else [ Relation (id1,mid1,"RaRTIsambanXaH",id2,mid2,"20.2")]
                   else if member_of rt2 viRayi_list
                   then [ Relation (id1,mid1,"RaRTIsambanXaH",id2,mid2,"20.3")]
                   else []
                   else []
                 | Sup (id2,mid2,word2,rt2,pUrvapaxa2,uwwarapaxa2,_,viBakwiH2,_,_)
                 | WaxXiwa (id2,mid2,word2,rt2,pUrvapaxa2,uwwarapaxa2,_,_,_,viBakwiH2,_,_) -> 
                   if     prose_order id1 id2 text_type
                   then if member_of rt2 viRayi_list
                   then [ Relation (id1,mid1,"RaRTIsambanXaH",id2,mid2,"20.4")]
                   else  if no_boundary_crossing id1 id2
                           && not (viBakwiH2 = 8) 
                           && not (member_of rt2 non_RaRTI_list)
                   then  [ Relation (id1,mid1,"RaRTIsambanXaH",id2,mid2,"20.5")]
                   else if   not (pUrvapaxa2=uwwarapaxa2) 
                   then  [ Relation (id1,mid1,"RaRTIsambanXaH",id2,mid2,"20.6")]
                   else []
                   else []
                 (*| Avykqw (id2,mid2,word2,_,_,_,_,_,_,_,_,_)
                 | AvywaxXiwa (id2,mid2,word2,_,_,_,_,_) ->
                   if    prose_order id1 id2 text_type
                      && (no_boundary_crossing id1 id2)
                   then [ Relation (id1,mid1,"RaRTIsambanXaH",id2,mid2,"20.6")]
                   else []
                  There can not be RaRTI sambanXa with kwvA, mawup etc.*)
                 | _ -> []
 (* if not ( pronoun3 rt1 || member_of rt1 saMKyeya || member_of rt1 pUraNa || member_of rt1 guNavAcI || member_of rt1 uwwara_guNavAcI) then 
   mama wqwIyam wasya cawurWam,  mama kqRNam wasya pIwam, ...
member_of rt1 sambanXavAcI *)
                ]
       | _ -> []
       ]
   | _ -> []
   ]
;

(* kAraka_RaRTI *)

(* rAmeNa prajAyAH SAsanam kriyawe *)
(* rAmasya vanagamanam xaSaraWAya na rocawe *)
value rl_kAraka_RaRTI1 m1 m2 text_type = match m2 with
  [ Kqw (id2,mid2,_,kqw_rt2,_,_,kqw2,_,_,_,rt2,_,_,_,_,_,_) ->
     match m1 with
     [ Sup (id1,mid1,_,_,_,_,_,viBakwiH1,_,_)
     | Kqw (id1,mid1,_,_,_,_,_,_,_,_,_,_,_,_,viBakwiH1,_,_)
     | WaxXiwa (id1,mid1,_,_,_,_,_,_,_,viBakwiH1,_,_) -> 
       if (* id2=next id1 && *)
      viBakwiH1=6 
       && (no_boundary_crossing id1 id2)
      && not (
             (kqw2="Sawq_lat" && not (rt2="xviR1")) 
          || (kqw2="ukaF" && not (kqw_rt2="kAmuka")) 
          || kqw2="SAnac_lat" || kqw2="Kal" || kqw2="yuc" || kqw2="u" || kqw2="wqN" || kqw2="SAnan" 
          || kqw2="cAnaS" || kqw2="wqc" || kqw2="kAnac" || kqw2="kvasu" || kqw2="ki" 
          || kqw2="kin" || kqw2="kwvA" || kqw2="Namul" || kqw2="kvasun" || kqw2="wosun" || kqw2="lyap"
          || kqw2="wumun" || kqw2="se" || kqw2="ase" || kqw2="ken"
          || (kqw2="kwa" && not(rt2="man1" || rt2="buX1" || rt2="buX2" || rt2="buX3" || rt2="pUj1"))
         )
       then  [ Relation (id1,mid1,"karwA",id2,mid2,"21.1") (* karwq_karmaNoH_kqwi *) 
             ; Relation (id1,mid1,"karma",id2,mid2,"21.2") (* karwq_karmaNoH_kqwi *) 
             ]
       else []
     |_ -> []
     ]
   |_ -> []
 ]
;

value rl_kAraka_RaRTI2 m1 m2 text_type = match m2 with
  [ Kqw (id2,mid2,rt2,upasarga2,_,_,kqw2,_,_,_,_,_,_,_,_,_,_) ->
     match m1 with
     [ Sup (id1,mid1,_,_,_,_,_,viBakwiH1,_,_)
     | Kqw (id1,mid1,_,_,_,_,_,_,_,_,_,_,_,_,viBakwiH1,_,_)
     | WaxXiwa (id1,mid1,_,_,_,_,_,_,_,viBakwiH1,_,_) -> 
       if    id2=next id1 
      && viBakwiH1=6 
       && (no_boundary_crossing id1 id2)
      && kqw2="kwa" 
      && (members_of rt2 upasarga2 akarmaka_verbs || members_of rt2 upasarga2 gawyarWa_verbs || members_of rt2 upasarga2 prawyavasAnArWa_verbs)
       then  [ Relation (id1,mid1,"karwA",id2,mid2,"22.1")] (* karwq_karmaNoH_kqwi *) 
       else []
     |_ -> []
     ]
   |_ -> []
 ]
;

value rl_kAraka_RaRTI3 m1 m2 text_type = match m2 with
  [ Avykqw (id2,mid2,_,_,_,_,_,_,kqw2,_,_,_) ->
     match m1 with
     [ Sup (id1,mid1,_,_,_,_,_,viBakwiH1,_,_)
     | Kqw (id1,mid1,_,_,_,_,_,_,_,_,_,_,_,_,viBakwiH1,_,_)
     | WaxXiwa (id1,mid1,_,_,_,_,_,_,_,viBakwiH1,_,_) -> 
       if    prose_order id1 id2 text_type 
      && viBakwiH1=6 
       && (no_boundary_crossing id1 id2)
      && kqw2="wumun"
       then  [ Relation (id1,mid1,"karwA",id2,mid2,"23.1") 
             ; Relation (id1,mid1,"karma",id2,mid2,"23.2") 
             ] (* karwq_karmaNoH_kqwi *)
       else []
     |_ -> []
     ]
   |_ -> []
 ]
;
value rlhewuprayoge m1 m2 text_type = match m2 with
     [ Sup(id2,mid2,word2,rt2,_,_,_,viBakwiH2,_,_) ->
     if rt2="hewu"
     then match m1 with
          [ Sup(id1,mid1,word1,rt1,_,_,_,viBakwiH1,_,_) ->
        if viBakwiH1=6
       && (no_boundary_crossing id1 id2)
        then [ Relation (id1,mid1,"upapaxaviBakwiH",id2,mid2,"24.1")]
        else if    pronoun3 rt1 (* sarvanAmnaswqwIyA ca 2.3.37; nimiwwakAraNahewuRu sarvAsAM prAyaxarSanaM  kasya hewoH, kene hewunA, kam hewum, kasmina hewO *)
            && viBakwiH1=viBakwiH2
             then [ Relation (id1,mid1,"viSeRaNam",id2,mid2,"24.2")]
             else []
          | _ -> []
          ]
     else []
     | _ -> []
     ]
; 

value rlkarwqsamAnAXikaraNam m1 m2 m3 text_type = match m2 with
    [ Sup (id2,mid2,_,rt2,_,_,lifgam2,viBakwiH2,vacanam2,_)
    | Kqw (id2,mid2,_,rt2,_,_,_,_,_,_,_,_,_,lifgam2,viBakwiH2,vacanam2,_)
    | WaxXiwa (id2,mid2,_,rt2,_,_,_,_,lifgam2,viBakwiH2,vacanam2,_) ->
      match m1 with
      [ Sup (id1,mid1,_,rt1,_,_,lifgam1,viBakwiH1,vacanam1,_)
      | Kqw (id1,mid1,_,_,_,_,_,_,_,_,rt1,_,_,lifgam1,viBakwiH1,vacanam1,_)
      | WaxXiwa (id1,mid1,_,rt1,_,_,_,_,lifgam1,viBakwiH1,vacanam1,_) ->
        match m3 with
        [ Wif (id3,mid3,_,rt3,_,_,upasarga3,_,_,_,puruRaH3,vacanam3,_,_,_,_) ->
          if    aBihiwa rt1 vacanam2 vacanam3 puruRaH3
             && members_of rt3 upasarga3 karwqsamAnAXikaraNa_verbs
             && viBakwiH1=viBakwiH2
           (*&& ((noun_agreement_vibh rt1 vacanam1 vacanam2 lifgam1 lifgam2 viBakwiH1 viBakwiH2) || pronominal12 rt1)  to account for jyowiH agniH Bavawi *)
(* || pronominal12 rt1 *)
           && ((vacanam1=vacanam2) || (rt1="mAsa" && (rt2="xakRiNAyana" || rt2="uwwarAyaNa")))
           && not (member_of rt1 saMKyeya) (* yogyawA *)
           && not (rt1="kim" || rt1="kiFciw" || rt1="kiFcana"|| rt1="yAvaw" || rt1="wAvaw" ) (* yogyawA  To stop: kA hAniH Bavawi hAniH is not karwqsamAnAXikaraNa of kA*)
           && word_order id1 id2
           && word_order id2 id3
         && viBakwiH1=1 && (no_boundary_crossing id2 id3)
        then [ Relation (id2,mid2,"karwqsamAnAXikaraNam",id3,mid3,"25.1") ] 
(* rel is marked with the verb and not with the karwA. This is to ensure that the parse is correct. 
Consider a sent with X Y v1 v2, where X and Y are karwA and karwAsamAnAXikaraNa w.r.t v1 and not wrt v2. And suppose in the final parse X is karwA of v2, then marking a relation of karwAsamAnAXikaraNa between X and Y will be wrong *)
        else []
      | Kqw (id3,mid3,_,rt3,upasarga3,_,_,_,_,_,_,_,_,_,_,_,_)
      | Avykqw (id3,mid3,_,rt3,_,_,upasarga3,_,_,_,_,_) ->
          if members_of rt3 upasarga3 karwqsamAnAXikaraNa_verbs
           && viBakwiH1=viBakwiH2
           && ((vacanam1=vacanam2) || (rt1="mAsa" && (rt2="xakRiNAyana" || rt2="uwwarAyaNa")))
           && not (member_of rt1 saMKyeya) (* yogyawA *)
           && word_order id1 id2
           && word_order id2 id3
         && viBakwiH1=1 && (no_boundary_crossing id2 id3)
        then [ Relation (id2,mid2,"karwqsamAnAXikaraNam",id3,mid3,"25.2") ] 
        else []
      | _ -> []
      ]
    | _ -> []
    ]
  | Avy (id2,mid2,_,rt2,_,_,_) ->
      if (rt2="miWyA" || rt2="anyaWA")  then match m1 with
      [ Sup (id1,mid1,_,rt1,_,_,lifgam1,viBakwiH1,vacanam1,_)
      | Kqw (id1,mid1,_,_,_,_,_,_,_,_,rt1,_,_,lifgam1,viBakwiH1,vacanam1,_)
      | WaxXiwa (id1,mid1,_,rt1,_,_,_,_,lifgam1,viBakwiH1,vacanam1,_) ->
        match m3 with
        [ Wif (id3,mid3,_,rt3,_,_,upasarga3,_,_,_,puruRaH3,vacanam3,_,_,_,_) ->
             if members_of rt3 upasarga3 karwqsamAnAXikaraNa_verbs
           (*&& ((noun_agreement_vibh rt1 vacanam1 vacanam2 lifgam1 lifgam2 viBakwiH1 viBakwiH2) || pronominal12 rt1)  to account for jyowiH agniH Bavawi *)
(* || pronominal12 rt1 *)
           && not (member_of rt1 saMKyeya) (* yogyawA *)
           && word_order id1 id2
           && word_order id2 id3
         && viBakwiH1=1 && (no_boundary_crossing id2 id3)
        then [ Relation (id2,mid2,"karwqsamAnAXikaraNam",id3,mid3,"25.3") ] 
(* rel is marked with the verb and not with the karwA. This is to ensure that the parse is correct. 
Consider a sent with X Y v1 v2, where X and Y are karwA and karwAsamAnAXikaraNa w.r.t v1 and not wrt v2. And suppose in the final parse X is karwA of v2, then marking a relation of karwAsamAnAXikaraNa between X and Y will be wrong *)
        else []
      | Kqw (id3,mid3,_,rt3,upasarga3,_,_,_,_,_,_,_,_,_,_,_,_)
      | Avykqw (id3,mid3,_,rt3,_,_,upasarga3,_,_,_,_,_) ->
          if members_of rt3 upasarga3 karwqsamAnAXikaraNa_verbs
           && word_order id1 id2
           && word_order id2 id3
         && viBakwiH1=1 && (no_boundary_crossing id2 id3)
        then [ Relation (id2,mid2,"karwqsamAnAXikaraNam",id3,mid3,"25.4") ] 
        else []
      | _ -> []
      ]
    | _ -> []
    ]
    else []
  | _ -> []
  ]
;
value rlkarmasamAnAXikaraNam m1 m2 m3 text_type = match m2 with
    [ Sup (id2,mid2,_,rt2,_,_,gen2,viB2,vac2,_)
    | Kqw (id2,mid2,_,_,_,_,_,_,_,_,rt2,_,_,gen2,viB2,vac2,_)
    | WaxXiwa (id2,mid2,_,rt2,_,_,_,_,gen2,viB2,vac2,_) ->
      match m1 with
      [ Sup (id1,mid1,_,rt1,_,_,gen1,viB1,vac1,_)
      | Kqw (id1,mid1,_,_,_,_,_,_,_,_,rt1,_,_,gen1,viB1,vac1,_)
      | WaxXiwa (id1,mid1,_,rt1,_,_,_,_,gen1,viB1,vac1,_) ->
           if (no_boundary_crossing id1 id2) && word_order id1 id2
           then match m3 with 
            [ Kqw (id3,mid3,_,rt3,upasarga3,_,_,_,_,_,_,_,_,_,_,_,_)
            | Avykqw (id3,mid3,_,rt3,_,_,upasarga3,_,_,_,_,_) ->
            if   noun_agreement_vibh vac1 vac2 gen1 gen1 viB1 viB2 
              && members_of rt3 upasarga3 karmasamAnAXikaraNa_verbs && id2 < id3
   	    then if (  members_of rt3 upasarga3 shliR_Axi_verbs
                    || members_of rt3 upasarga3 gawyarWa_verbs
                    || members_of rt3 upasarga3 aaxikarma_verbs
                    || rt3 = "kq3"
                   ) && viB1=2
(* waxA AyojakAH neharUM sanwuRtaM kqwavanwaH *)
            then [ Relation (id2,mid2,"karmasamAnAXikaraNam",id3,mid3,"26.1") ]
            else if  members_of rt3 upasarga3 sakarmaka_verbs && viB1=1
            then [ Relation (id2,mid2,"karmasamAnAXikaraNam",id3,mid3,"26.1") ]
            else []
            else []
            | Wif (id3,mid3,_,rt3,_,_,upasarga3,_,prayogaH3,_,_,_,_,_,_,_) ->
            if   noun_agreement_vibh vac1 vac2 gen1 gen1 viB1 viB2 
            then if members_of rt3 upasarga3 karmasamAnAXikaraNa_verbs
            then if    prayogaH3="karwari" && viB1=2
                 then [ Relation (id2,mid2,"karmasamAnAXikaraNam",id3,mid3,"26.2") ]
                 else if prayogaH3="karmaNi" && viB1=1
                 then [ Relation (id2,mid2,"karmasamAnAXikaraNam",id3,mid3,"26.3") ]
                 else []
            else []
            else []
            | _ -> []
            ]
            else []
        | _ -> []
        ]
      | Avy (id2,mid2,_,rt2,_,_,_) ->
        match m1 with
        [ Sup (id1,mid1,_,rt1,_,_,gen1,viB1,vac1,_)
        | Kqw (id1,mid1,_,_,_,_,_,_,_,_,rt1,_,_,gen1,viB1,vac1,_)
        | WaxXiwa (id1,mid1,_,rt1,_,_,_,_,gen1,viB1,vac1,_) ->
             if (no_boundary_crossing id1 id2) && word_order id1 id2
             then match m3 with 
              [ Kqw (id3,mid3,_,rt3,upasarga3,_,_,_,_,_,_,_,_,_,_,_,_)
              | Avykqw (id3,mid3,_,rt3,_,_,upasarga3,_,_,_,_,_) ->
                if rt3="kq3" && rt2="BasmasAw"  && id2 < id3
                then [ Relation (id2,mid2,"karmasamAnAXikaraNam",id3,mid3,"26.4") ]
                else []
              | Wif (id3,mid3,_,rt3,_,_,upasarga3,_,prayogaH3,_,_,_,_,_,_,_) ->
                if rt3="kq3" && rt2="BasmasAw"  && id2 < id3
                then [ Relation (id2,mid2,"karmasamAnAXikaraNam",id3,mid3,"26.5") ]
                else []
              | _ -> []
              ]
              else []
        | _ -> []
        ]
   | _ -> []
   ]
;

(* Special rules for specific words *)

(* rAmaH eva vanam gacCawi. 
   rAmaH api gacCawi.
   rAmaH na gacCawi.
   We need to prepare a list of avyayas from avayayakosha  *)
value rlsambanXa1 m1 m2 text_type = match m2 with
  [ Avy (id2,mid2,_,rt2,_,_,_) ->
     match m1 with
     [ Wif (id1,mid1,_,rt1,_,_,_,_,_,_,_,_,_,_,_,_)
     | Kqw (id1,mid1,_,_,_,_,_,_,_,_,rt1,_,_,_,_,_,_)
     | Avykqw (id1,mid1,_,rt1,_,_,_,_,_,_,_,_)
     | Sup (id1,mid1,_,rt1,_,_,_,_,_,_)
     | AvywaxXiwa (id1,mid1,_,rt1,_,_,_,_)
     | Avy (id1,mid1,_,rt1,_,_,_)
     | WaxXiwa (id1,mid1,_,rt1,_,_,_,_,_,_,_,_) -> 
       if     id1=previous id2 
           && (rt2="eva"|| rt2="api"|| rt2="wu"||rt2="uwa"||rt2="nu"|| rt2="ha"||rt2="iva" || rt2="cEva" || rt2="hi")
       then [ Relation (id2,mid2,"sambanXaH",id1,mid1,"27.1")]
       else []
     ]
    | _ -> []
  ]
;

(* ayi Bo Rama mAma uxXara *)
(* yaxi ... warhi ... *)
value rlsambanXa2 m1 m2 text_type = match m2 with
  [ Avy (id2,mid2,word2,_,_,_,_) ->
   match m1 with
     [ Avy (id1,mid1,word1,_,_,_,_) ->
    if (id1=previous id2)
       && (member_of word1 samboXana_sUcaka)
       && (member_of word2 samboXana_sUcaka)
       && (not (word1=word2))
       then [ Relation (id1,mid1,"sambanXaH",id2,mid2,"28.1")]
       else []
 
     | _ -> []
     ]
  | _ -> []
  ]
  ;
(* eva ca, ca eva, ... *)
value rlsambanXa3 m1 m2 text_type = match m2 with
  [ Avy (id2,mid2,word2,_,_,_,_) ->
   match m1 with
     [ Avy (id1,mid1,word1,_,_,_,_) ->
    if (id1=previous id2) && (not (word1=word2))
       then match word1 with
       [ "eva" -> match word2 with
                 [ "ca" -> [Relation (id1,mid1,"sambanXaH",id2,mid2,"28.2")]
                 | _ -> []
                 ]
       | "ca" -> match word2 with
                 [ "eva" -> [Relation (id1,mid1,"sambanXaH",id2,mid2,"28.3")]
                 | _ -> []
                 ]
       | _ -> []
       ]
       else []
 
     | _ -> []
     ]
  | _ -> []
  ]
  ;
(* ;wvaM mA gacCa. *)
value rlavy_wifkqw_special m1 m2 text_type = match m2 with
  [ Wif (id2,mid2,_,_,_,_,_,_,_,_,_,_,_,_,_,_)
  | Kqw (id2,mid2,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)
  | Avykqw (id2,mid2,_,_,_,_,_,_,_,_,_,_) ->
     match m1 with
     [ Avy (id1,mid1,word1,_,_,_,_) -> 
           if (no_boundary_crossing id1 id2)
           then match word1 with
       [ "sma" -> if (id1 = next id2)
          then [ Relation (id1,mid1,"sambanXaH",id2,mid2,"29.1")]
          else []
       | "no" 
       | "na" ->  if prose_order id1 id2 text_type
         then [ Relation (id1,mid1,"prawiReXaH",id2,mid2,"29.2")]
           else []
       | "kacciw" 
       | "kim" ->  if prose_order id1 id2 text_type
         then [ Relation (id1,mid1,"sambanXaH",id2,mid2,"29.3")]
           else []
       | "saha"
       | "sAkam"
       | "sArXam"
       | "samam"
       | "vinA" -> if prose_order id1 id2 text_type
           then [ Relation (id1,mid1,"sahakAraka",id2,mid2,"29.4")]
           else []
       | _ ->      if member_of word1 upapaxa_sambanXa
           then [ Relation (id1,mid1,"sambanXaH",id2,mid2,"29.5")]
           else []
       ]
       else []
    | _ -> []
    ]
  | _ -> []
  ]
  ;
value rlavy_wif_mA m1 m2 text_type = match m2 with
  [ Wif (id2,mid2,_,_,_,_,_,_,_,lakAraH2,_,_,_,_,_,_) ->
     match m1 with
     [ Avy (id1,mid1,word1,_,_,_,_) ->
       if    id2=next id1 
      && word1="mA"
      && (lakAraH2="lot" || lakAraH2="viXilif" || lakAraH2="lqt" || lakAraH2="luf")
       then [ Relation (id1,mid1,"sambanXaH",id2,mid2,"30.1")]
       else []
     | _ -> []
     ]
  | _ -> []
  ]
;
(* canxraH nAma BUpawiH prawivasawi sma *)
value rl_nAma m1 m2 text_type = match m2 with
  [ Wif (id2,mid2,_,_,_,_,_,_,_,_,_,_,_,_,_,_)
  | Kqw (id2,mid2,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)
  | Avykqw (id2,mid2,_,_,_,_,_,_,_,_,_,_)
  | Sup (id2,mid2,_,_,_,_,_,_,_,_)
  | WaxXiwa (id2,mid2,_,_,_,_,_,_,_,_,_,_)
  | AvywaxXiwa (id2,mid2,_,_,_,_,_,_)
  | Avy (id2,mid2,_,_,_,_,_) ->
     match m1 with
     [ Avy (id1,mid1,word1,_,_,_,_) ->
       if  word1="nAma"
       then if id1=previous id2
        then [ Relation (id1,mid1,"sambanXaH",id2,mid2,"31.1")]
        else if id2=previous id1
        then [ Relation (id2,mid2,"sambanXaH",id1,mid1,"31.2")]
        else []
    else []
     | _ -> []
     ]
  ]
;

(* evam ukwvA saH agacCaw *)

value rlevamkarma m1 m2 text_type = match m1 with
      [ Avy (id1,mid1,word1,_,_,_,_) -> 
           if word1="iwi" || word1="evam"
           then match m2 with
            [ Wif (id2,mid2,_,rt2,_,_,upasarga2,_,_,_,_,_,_,_,_,_)
            | Kqw (id2,mid2,_,rt2,upasarga2,_,_,_,_,_,_,_,_,_,_,_,_)
            | Avykqw (id2,mid2,_,rt2,_,_,upasarga2,_,_,_,_,_) ->
               if (no_boundary_crossing id1 id2)
               then if   prose_order id1 id2 text_type
                 && (   members_of rt2 upasarga2 sakarmaka_verbs
                     || members_of rt2 upasarga2 xvikarmakas1
                     || members_of rt2 upasarga2 xvikarmakas2)
                 &&  word1="iwi" 
               then [ Relation (id1,mid1,"karma",id2,mid2,"31a.1") ]
               else if    prose_order id1 id2 text_type
                       && rt2="vac1" &&  word1="evam" 
                    then  [ Relation (id1,mid1,"gONakarma",id2,mid2,"31a.2") ]
                    else []
               else []
            | _ -> []
            ]
           else []
      | _ -> []
      ]
;
(* iwi after any noun or verb is related to the previous word by sambanXa relation
;Note the direction also. Now iwi is the head, and not the verb. *)

value rliwi m1 m2 text_type = match m1 with
  [ Avy (id1,mid1,word1,_,_,_,_) ->
     if word1="iwi"
     then match m2 with
     [ Wif (id2,mid2,_,_,_,_,_,_,_,_,_,_,_,_,_,_)
     | Avykqw (id2,mid2,_,_,_,_,_,_,_,_,_,_)
     | Sup(id2,mid2,_,_,_,_,_,_,_,_)
     | Avy (id2,mid2,_,_,_,_,_)
     | Kqw (id2,mid2,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_) ->
       if    id1=next id2  
       then if  id1=total_wrds.val
       then [ Relation (id1,mid1,"sambanXaH",id2,mid2,"32.1")]
       else [ Relation (id2,mid2,"sambanXaH",id1,mid1,"32.2")]
       else []
     | _ -> []
     ]
     else []
  | _ -> []
  ]
;

(* Sentential connectives *)

(* rAme vanam gawe sawi sIwA api gacCawi *)
value rlBAvalakRaNa_sapwamI1 m1 m2 text_type = match m1 with
  [ Kqw (id1,mid1,_,_,_,_,kqw1,_,_,_,_,_,_,_,viBakwiH1,_,_) -> 
      if  (kqw1="Sawq_lat" || kqw1="SAnac_lat" || kqw1="kwa" || kqw1="kwavawu")
       && (viBakwiH1=7 || viBakwiH1 = 6)
         (* 2.3.36; yasya_ca_BAvena_BAvalakRaNam; 
            2.3.37 RaRTI cAnAxare  - ruxawaH prAvrAjIw  *)
     then match m2 with
     [ Wif (id2,mid2,_,rt2,_,_,_,_,_,_,_,_,_,_,_,_) ->
        if   prose_order id1 id2 text_type 
           && (no_boundary_crossing id1 id2)
        then [ Relation (id1,mid1,"BAvalakRaNasapwamI",id2,mid2,"33.1")] 
        else []
     | Kqw (id2,mid2,_,rt2,_,_,_,_,_,_,_,_,_,_,viBakwiH2,_,_) ->
        if   viBakwiH2=1  
           && prose_order id1 id2 text_type
           && (no_boundary_crossing id1 id2)
           then [ Relation (id1,mid1,"BAvalakRaNasapwamI",id2,mid2,"33.1")] 
        else []
     | _ -> []
     ]
     else []
  | _ -> []
  ]
;
value rlBAvalakRaNa_sapwamI2 m1 m2 text_type = match m2 with
    [ Kqw (id2,mid2,_,_,_,_,kqw2,_,_,_,_,_,_,_,viBakwiH2,_,_) ->
       match m1 with
       [ Sup (id1,mid1,_,_,_,_,_,viBakwiH1,_,_) ->
     if  prose_order id1 id2 text_type 
           && (no_boundary_crossing id1 id2)
        && viBakwiH1=viBakwiH2 
        && (viBakwiH1=7 || viBakwiH1=6)
        && (kqw2="Sawq_lat" || kqw2="SAnac_lat" || kqw2="kwa" || kqw2="kwavawu")
     then [ Relation (id1,mid1,"karwA",id2,mid2,"34.1") 
          ; Relation (id1,mid1,"karma",id2,mid2,"34.2") 
          ]
     else []
       | _ -> []
       ]
    | _ -> []
    ]
;
(*
SrUyawAm iwi Amanwrya rAmaH avocaw.
praBAwe aham rAjasaBAm gawvA kA vArwA iwi paSyAmi. 
rAmaH avaxaw yaw aham gacCAmi
aham gacCAmi iwi rAmaH avaxaw
Replacing iwi with yaw will result in the mirror image; ->  'X iwi Y'  is same as 'Y yaw X'
*)
value rlvAkyakarma m1 m2 m3 text_type = match m2 with
      [ Avy (id2,mid2,word2,_,_,_,_) ->
           if (word2="iwi" || word2="evam") 
           then match m3 with
           [ Wif (id3,mid3,_,rt3,_,_,upasarga3,_,_,_,_,_,_,_,_,_)
           | Kqw (id3,mid3,_,rt3,upasarga3,_,_,_,_,_,_,_,_,_,_,_,_)
           | Avykqw (id3,mid3,_,rt3,_,_,upasarga3,_,_,_,_,_) ->
              if (id2 < id3) && members_of rt3 upasarga3 vAkyakarma_verbs
              then  match m1 with
                 [ Wif (id1,mid1,_,_,_,_,_,_,_,_,_,_,_,_,_,_) ->
                    (* if prose_order id1 id2 text_type *)
                     if id1 = previous id2
                     then [ Relation (id1,mid1,"vAkyakarma",id2,mid2,"35.1")
                     ; Relation (id2,mid2,"vAkyakarmaxyowaka",id3,mid3,"35.2")
                     ]
                    else []
                 | Kqw (id1,mid1,_,_,_,_,_,_,_,_,_,_,_,_,viBakwiH1,_,_) ->
            (*| Avykqw (id1,mid1,_,rt1,_,_,_,_,_,_)  
                How can in '.. kwvA .. iwi ...' , kwvA be a vAkyakarma? 
               if prose_order id1 id2 text_type*)
                    if id1 = previous id2 && viBakwiH1=1
                    then [ Relation (id1,mid1,"vAkyakarma",id2,mid2,"35.3")
                     ; Relation (id2,mid2,"vAkyakarmaxyowaka",id3,mid3,"35.4")
                     ]
                    else []
                 | _ -> []
                 ]
              else []
           | Sup (id3,mid3,word3,rt3,_,_,_,_,_,_) -> 
                 if rt3="mawi" || rt3 = "mawa" then match m1 with
                 [ Wif (id1,mid1,_,_,_,_,_,_,_,_,_,_,_,_,_,_)
                 | Kqw (id1,mid1,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_) ->
                    if id1 = previous id2 then
                    [ Relation (id1,mid1,"vAkyakarma",id2,mid2,"35.5")
                    ; Relation (id2,mid2,"vAkyakarmaxyowaka",id3,mid3,"35.6")
                    ]
                    else []
                 | _ -> []
                 ]
                 else []
           | _ -> []
           ]
           else []
    | _ -> []
    ]
;
value rlvAkyakarma1 m1 m2 m3 text_type = match m3 with
       [ Wif (id3,mid3,_,rt3,_,_,_,_,_,_,_,_,_,_,_,_)
       | Kqw (id3,mid3,_,rt3,_,_,_,_,_,_,_,_,_,_,_,_,_)
       | Avykqw (id3,mid3,_,rt3,_,_,_,_,_,_,_,_) ->
      match m2 with
      [ Avy (id2,mid2,word2,_,_,_,_) ->
           if    prose_order id2 id3 text_type
           && (no_boundary_crossing id2 id3)
          && word2="yaw"
           then match m1 with
            [ Wif (id1,mid1,_,rt1,_,_,upasarga1,_,_,_,_,_,_,_,_,_)
            | Kqw (id1,mid1,_,rt1,upasarga1,_,_,_,_,_,_,_,_,_,_,_,_)
            | Avykqw (id1,mid1,_,rt1,_,_,upasarga1,_,_,_,_,_) ->
               if    prose_order id1 id2 text_type
           && (no_boundary_crossing id1 id2)
              && members_of rt1 upasarga1 vAkyakarma_verbs
               then [ Relation (id2,mid2,"vAkyakarmaxyowaka",id1,mid1,"36.1")
                ; Relation (id3,mid3,"vAkyakarma",id2,mid2,"36.2")
                ]
               else []
            | _ -> []
            ]
           else []
      | _ -> []
      ]
    | _ -> []
    ]
;

value rlyaxi_warhi_cew m1 m2 m3 text_type = match m1 with
  [ Avy (id1,mid1,word1,_,_,_,_) -> 
          if yaxi_no_warhi word1                      (* __yaxi__ V1 V2  / V2 __yaxi__ V1 *)
          then yaxi_warhi prawi_and_anu m2 m3 id1 mid1 word1 "37.1"
          else if yaxi_with_warhi word1                   (* __yaxi__ V1 warhi V2 / warhi V2 __yaxi__ V1 *)
          then yaxi_warhi prawi_or_anu m2 m3 id1 mid1 word1 "37.2"
          else if warhi_no_yaxi word1                   (* V1 __warhi__ V2 *)
          then yaxi_warhi prawi_and_anu m2 m3 id1 mid1 word1 "37.3"
          else if warhi_with_yaxi word1                   (* yaxi V1 __warhi__ V2 / warhi V2 __yaxi__ V1 *)
          then yaxi_warhi prawi_or_anu m2 m3 id1 mid1 word1 "37.4"
          else []
  | _ -> []
  ]
;
(*
sentences with connectives joiniing a wif with kqw fail, if we have rlsent_kqw_connectives and rlsent_wif_cocnnectives seperately.
For example:  श्यामः विरोधं कर्तुं अचेष्टत किन्तु तस्य वचः कः अपि न श्रुतवान्
failed to parse.
*)
(*
value rlsent_kqw_connectives m1 m2 m3 text_type = match m3 with
       [Kqw (id3,mid3,_,rt3,_,_,_,_,_,_,_,_,_,_) -> (* only kwa kwavawu *)
         match m1 with
         [ Kqw (id1,mid1,_,rt1,_,_,_,_,_,_,_,_,_,_) -> (* add condition for only kwa kwavawu *)
             match m2 with
             [ Avy (id2,mid2,word2,_,_,_) ->
              if    id1 < id2 && id2 < id3
              then match word2 with
              [ "yaw" -> if not (member_of rt1 vAkyakarma_verbs)
                     then [ Relation (id1,mid1,"prawiyogI",id2,mid2,"39.1")
                      ; Relation (id2,mid2,"anuyogI",id3,mid3,"39.2")
                      ]
                     else []
              |"aWa" 
              |"kinwu" 
              |"paranwu" -> [ Relation (id1,mid1,"prawiyogI",id2,mid2,"39.1")
                            ; Relation (id2,mid2,"anuyogI",id3,mid3,"39.2")
                            ]
               | _ -> []
              ]
              else []
             | _ -> []
             ]
          | _ -> []
          ]
    | _ -> []
    ]
;

*)
value rlsent_beginning_connectives m1 m2 text_type = match m1 with
     [ Avy (id1,mid1,word1,_,_,_,_) -> match m2 with
         [ Wif (id2,mid2,_,rt2,_,_,upasarga2,_,_,_,_,_,_,_,_,_)  ->
	      if id1 = 1 &&  word1 = "api"
              && (no_boundary_crossing id1 id2)
              then [ Relation (id1,mid1,"sambanXaH",id2,mid2,"38.1")]
              else if    id1 < id2
              && ((no_boundary_crossing id1 id2) || id1=1)
              then match word1 with
              [ "yaw" -> if not (members_of rt2 upasarga2 vAkyakarma_verbs)
                         then [ Relation (id1,mid1,"sambanXaH",id2,mid2,"38.2")
                              ]
                         else []
              |"awaH"
              |"wawaH"
              |"aWa"
              |"aWavA"
              |"uwa"
              |"yaWA"
              |"waWA"
              |"waWEva"
              |"wawwvawaH"
              |"waxananwaram"
              |"wu"
              |"kinwu"
              |"paranwu" -> [ Relation (id1,mid1,"sambanXaH",id2,mid2,"38.3")
                            ]
              | _ -> []
              ]
              else []
          | _ -> []
          ]
     | _ -> []
     ]
; 

value rlsent_connectives m1 m2 m3 text_type = match m2 with
     [ Avy (id2,mid2,word2,_,_,_,_) -> match m3 with
       [ Wif (id3,mid3,_,rt3,_,_,_,_,_,_,_,_,_,_,_,_) -> match m1 with
         [ Wif (id1,mid1,_,rt1,_,_,upasarga1,_,_,_,_,_,_,_,_,_)  ->
              if    id1 < id2 && id2 < id3
              then match word2 with
              [ "yaw" -> if not (members_of rt1 upasarga1 vAkyakarma_verbs)
                         then [ Relation (id1,mid1,"prawiyogI",id2,mid2,"40.1")
                              ; Relation (id2,mid2,"anuyogI",id3,mid3,"40.2")
                              ]
                         else []
              |"aWa"
              |"kinwu"
              |"paranwu" -> [ Relation (id1,mid1,"prawiyogI",id2,mid2,"40.3")
                            ; Relation (id2,mid2,"anuyogI",id3,mid3,"40.4")
                            ]
              | _ -> []
              ]
              else []
          | _ -> []
          ]
       | Kqw (id3,mid3,word3,rt3,_,_,kqw3,_,_,_,_,_,uwwarapaxa3,_,_,_,_) -> match m1 with
         [ Kqw (id1,mid1,word1,rt1,upasarga1,_,kqw1,_,_,_,_,_,uwwarapaxa1,_,_,_,_) ->
              if    id1 < id2 && id2 < id3 && (kqw1 = "kwa" || kqw1 = "kwavawu") && (kqw3 ="kwa" || kqw3 = "kwavawu") && uwwarapaxa3=word3 && uwwarapaxa1=word1
              then match word2 with
              [ "yaw" -> if not (members_of rt1 upasarga1 vAkyakarma_verbs)
                         then [ Relation (id1,mid1,"prawiyogI",id2,mid2,"40.5")
                              ; Relation (id2,mid2,"anuyogI",id3,mid3,"40.6")
                              ]
                         else []
              |"aWa"
              |"kinwu"
              |"paranwu" -> [ Relation (id1,mid1,"prawiyogI",id2,mid2,"40.7")
                            ; Relation (id2,mid2,"anuyogI",id3,mid3,"40.8")
                            ]
              | _ -> []
              ]
              else []
         | _ -> []
         ]
       | _ -> []
       ]
     | _ -> []
     ]
;

value rlupamAna_upameya_sup m1 m2 m3 text_type = match m2 with
     [ Avy (id2,mid2,word2,_,_,_,_) -> 
        if word2 = "iva" then match m3 with
        [ Sup (id3,mid3,_,_,_,_,_,viBakwiH3,_,_)
        | WaxXiwa (id3,mid3,_,_,_,_,_,_,_,viBakwiH3,_,_) -> 
             match m1 with
             [ Sup (id1,mid1,_,_,_,_,_,viBakwiH1,_,_)
             | WaxXiwa (id1,mid1,_,_,_,_,_,_,_,viBakwiH1,_,_) -> 
                   if id1 = previous id2 && id2 < id3 && (viBakwiH1=1 || viBakwiH1=viBakwiH3)
                   then  [ Relation (id1,mid1,"prawiyogI",id2,mid2,"41.1")
                         ; Relation (id2,mid2,"anuyogI",id3,mid3,"41.2")
                         ]
                   else []
             | _ -> []
             ]
        | Wif (id3,mid3,_,rt3,_,_,_,_,_,_,_,_,_,_,_,_) -> 
             match m1 with
             [ Wif (id1,mid1,_,rt1,_,_,_,_,_,_,_,_,_,_,_,_) ->
                   if id1 = previous id2 && id2 < id3
                   then  [ Relation (id1,mid1,"prawiyogI",id2,mid2,"41.3")
                         ; Relation (id2,mid2,"anuyogI",id3,mid3,"41.4")
                         ]
                   else []
             | _ -> []
             ]
        | Kqw (id3,mid3,_,rt3,_,_,_,_,_,_,_,_,_,_,_,_,_) -> 
             match m1 with
             [ Kqw (id1,mid1,_,rt1,_,_,_,_,_,_,_,_,_,_,_,_,_) -> 
                   if id1 = previous id2 && id2 < id3
                   then  [ Relation (id1,mid1,"prawiyogI",id2,mid2,"41.5")
                         ; Relation (id2,mid2,"anuyogI",id3,mid3,"41.6")
                         ]
                   else []
             | _ -> []
             ]
        | _ -> []
        ]
        else []
     | _ -> []
     ]
;
value rlniwya_sambanXa_avy m1 m2 text_type = match m2 with
     [Avy (id2,mid2,_,rt2,_,_,_) -> match m1 with
      [Avy (id1,mid1,_,rt1,_,_,_) ->
        if  (rt1="yaxA" && rt2="waxA")
           || (rt1="yaWA" && rt2="waWA")
           || (rt1="yawra" && rt2="wawra")
           || (rt1="yAvaw" && rt2="wAvaw")
           || (rt1="yasmAw" && rt2="wsmAw")
           || ((rt1="yaxi"||rt1="cew") && (rt2="warhi" || rt2="waw"))
           || (rt1="yaxi" && rt2="wawaH")
           || (rt1="yawaH" && (rt2="awaH" || rt2="wawaH"))
           || (rt1="yaxyapi" && (rt2="waWApi" || rt2="aWApi"))
        then [ Relation (id1,mid1,"niwya_sambanXaH",id2,mid2,"42.1")]
        else []
      | _ -> []
      ]
     | AvywaxXiwa (id2,mid2,word2,rt2,_,_,_,_) -> match m1 with
       [ AvywaxXiwa (id1,mid1,word1,rt1,_,_,_,_) -> 
            if word1="yaxvaw" && word2="waxvaw"
            then [ Relation (id1,mid1,"niwya_sambanXaH",id2,mid2,"42.2")]
            else []
       | _ -> []
       ]
     | _ -> []
     ]
; 
value rlniwya_sambanXa_sup m1 m2 text_type = match m2 with
     [ Sup(id2,mid2,_,rt2,_,_,lifgam2,_,vacanam2,_)  -> 
      match m1 with
      [ Sup(id1,mid1,_,rt1,_,_,lifgam1,_,vacanam1,_) ->
        if (lifgam1=lifgam2) && (vacanam1=vacanam2) && not (id1=id2)
        then if  ((  rt1="yax" || (* rt1="kim"  || *)rt1 = "ewax")
            && (rt2="wax"))
        (* How can there be a niwya sambanXa between kim and wax? *)
         then [ Relation (id1,mid1,"niwya_sambanXaH",id2,mid2,"43.1")]
         else if  rt1="yAvaw" && rt2="wAvaw"
         then [ Relation (id1,mid1,"niwya_sambanXaH",id2,mid2,"43.2")]
         else []
         else if  rt1="yax" && rt2="ewax"
         then [ Relation (id1,mid1,"niwya_sambanXaH",id2,mid2,"43.3")]
        else []
      | _ -> []
      ]
     | _ -> []
     ]
; 

value rl_initial_avy m1 m2 text_type = match m2 with
    [ Wif (id2,mid2,_,_,_,_,_,_,_,_,_,_,_,_,_,_) -> match m1 with
      [ Avy (id1,mid1,word1,_,_,_,_) -> match word1 with
            ["aWa"
            |"kinwu"
            |"paranwu" -> if id1 = 1 
                          then [ Relation (id1,mid1,"sambanXaH",id2,mid2,"45.1") ]
                          else []
            | _ -> []
            ]
      | _ -> []
      ]
    | _ -> []
    ]
;

value rl_ca m1 m2 text_type = match m2 with
    [ Wif (id2,mid2,_,_,_,_,_,_,_,_,_,_,_,_,_,_)
    | Avykqw (id2,mid2,_,_,_,_,_,_,_,_,_,_) 
    | Avy (id2,mid2,_,_,_,_,_) 
    | Sup(id2,mid2,_,_,_,_,_,_,_,_) 
    | Kqw (id2,mid2,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)
    | WaxXiwa (id2,mid2,_,_,_,_,_,_,_,_,_,_) -> match m1 with
      [ Avy (id1,mid1,word1,_,_,_,_) -> match word1 with
            ["ca" -> if id2 = previous id1
                     then [ Relation (id1,mid1,"sambanXaH",id2,mid2,"47.1") ]
                     else []
            | _ -> []
            ]
      | _ -> []
      ]
    | _ -> []
    ]
;

value rl_exclamatory1 m1 m2 text_type = match m1 with
   [ Avy (id1,mid1,_,word1,_,_,_) ->  match m2 with
         [ Wif (id2,mid2,_,_,_,_,_,_,_,_,_,_,_,_,_,_)
         | Kqw (id2,mid2,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_) -> 
              if id1 < id2
              && (no_boundary_crossing id1 id2)
              &&   word1="aho" 
              then [ Relation (id1,mid1,"sambanXaH",id2,mid2,"48.1") 
                   ]
              else []
         |_ -> []
         ]
      |_ -> []
      ]
;

value rl_exclamatory2 m1 m2 m3 text_type = match m1 with
   [ Avy (id1,mid1,_,word1,_,_,_) ->  match m2 with
      [ Avy (id2,mid2,_,word2,_,_,_) -> match m3 with
         [ Wif (id3,mid3,_,_,_,_,_,_,_,_,_,_,_,_,_,_)
         | Kqw (id3,mid3,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_) -> 
              if id1 = previous id2 && id2 < id3
              && (no_boundary_crossing id2 id3)
              &&   ((word1="hA" && word2="hanwa") || 
                  (word1="aho" && word2="bawa"))
              then [ Relation (id1,mid1,"sambanXaH",id2,mid2,"48a.1") 
                   ; Relation (id2,mid2,"sambanXaH",id3,mid3,"48a.2") 
                   ]
              else []
         |_ -> []
         ]
      |_ -> []
      ]
   |_ -> []
   ]
;

value rlca_samucciwa m1 m2 m3 text_type = match m3 with
     [ Avy (id3,mid3,_,word3,_,_,_) -> match m2 with
        [ Wif (id2,mid2,_,_,_,_,_,_,prayogaH2,lakAra2,puruRaH2,vacanam2,_,_,_,_) ->
           (* if id3 = next id2 then ; not necessary. e.g. rAmaH SAlAm gacCawip pATam ca paTawi*) 
             match m1 with
              [ Wif (id1,mid1,_,_,_,_,_,_,prayogaH1,lakAra1,puruRaH1,vacanam1,_,_,_,_) ->
                 if id1 < id2 && prayogaH1=prayogaH2 && lakAra1=lakAra2 (*&& puruRaH1=puruRaH2 && vacanam1=vacanam2  muKam pariSuRyawi gAwrANi ca sIxanwi *)
              && (no_boundary_crossing id1 id2)
                 (*&& (word3="ca" || word3="cEva" || (word3="waWA" && id3 < id2 && id3 > 1))&*)
                 && (( (word3="ca" || word3="cEva")  && (id3 = next id2))
                     || (word3="waWA" && id3 < id2 && id3 > 1 && yaWA_pos.val = 1000))
                 then
                 [ Relation (id2,mid2,"samucciwa",id1,mid1,"46.1")
                 ; Relation (id3,mid3,"samuccayaxyowaka",id2,mid2,"46.2")
                 ]
                 else []
              | _ -> []
              ]
            (* else [] *)
        | Avykqw (id2,mid2,_,_,_,_,_,_,kqw_prawyaya2,_,_,_) -> match m1 with
             [ Avykqw (id1,mid1,_,_,_,_,_,_,kqw_prawyaya1,_,_,_) ->
                 if id1 < id2 && kqw_prawyaya1=kqw_prawyaya2
                 && (( (word3="ca" || word3="cEva")  && (id3 = next id2))
                     || (word3="waWA" && id3 < id2 && id3 > 1 && yaWA_pos.val = 1000))
                 then
                 [ Relation (id2,mid2,"samucciwa",id1,mid1,"46.3")
                 ; Relation (id3,mid3,"samuccayaxyowaka",id2,mid2,"46.4")
                 ]
                 else []
             | _ -> []
             ]
        | Sup(id2,mid2,_,_,_,_,_,viBakwiH2,vacanam2,_) 
        | WaxXiwa (id2,mid2,_,_,_,_,_,_,_,viBakwiH2,vacanam2,_) -> 
              match m1 with
              [ Sup(id1,mid1,word1,rt1,_,_,_,viBakwiH1,vacanam1,_) 
              | WaxXiwa (id1,mid1,word1,rt1,_,_,_,_,_,viBakwiH1,vacanam1,_)
              | Kqw (id1,mid1,word1,rt1,_,_,_,_,_,_,_,_,_,_,viBakwiH1,vacanam1,_) ->
                 if id1 < id2  && viBakwiH1=viBakwiH2 && vacanam1=vacanam2
                 && (  ((word3="ca" || word3="cEva") && (id3 = next id2)) 
                     || (word3="waWA" && id3 < id2 && id3 > 1 && yaWA_pos.val = 1000))
                    (* && not (( pronoun3 rt1 || member_of rt1 saMKyeya || member_of rt1 pUraNa || (member_of rt1 guNavAcI && uwwarapaxa1=word1) || (member_of rt1 uwwara_guNavAcI && not (uwwarapaxa1=word1))|| member_of rt1 sambanXavAcI) )  Removed uwwarapaxa guNavAcI *)
                    && not ( pronoun3 rt1 || member_of rt1 saMKyeya || member_of rt1 pUraNa || member_of rt1 sambanXavAcI)
                 (* then if id3 = next id2 *) (* yogyawA *)
                 then
                 [ Relation (id2,mid2,"samucciwa",id1,mid1,"46.5")
                 ; Relation (id3,mid3,"samuccayaxyowaka",id2,mid2,"46.6")
                 ]
                 (*else if id3 > id2 
                 then [Relation (id2,mid2,"samucciwa",id1,mid1,"46.7")]
                 else [] *)
                 else []
              | _ -> []
              ]
        | Kqw (id2,mid2,_,_,_,_,kqw2,_,_,_,_,_,_,_,viBakwiH2,vacanam2,_) ->
              match m1 with
              [ Kqw (id1,mid1,_,_,_,_,kqw1,_,_,_,_,_,_,_,viBakwiH1,vacanam1,_) ->
                 if    id1 < id2
                    && viBakwiH1=viBakwiH2 && vacanam1=vacanam2
                    && kqw2=kqw1
                 && (  ((word3="ca" || word3="cEva") && (id3 = next id2)) 
                     || (word3="waWA" && id3 < id2 && id3 > 1 && yaWA_pos.val = 1000))
                 (* then if id3 = next id2 *)
                 then
                 [ Relation (id2,mid2,"samucciwa",id1,mid1,"46.8")
                 ; Relation (id3,mid3,"samuccayaxyowaka",id2,mid2,"46.9")
                 ]
                 (* else if id3 > id2 
                 then [Relation (id2,mid2,"samucciwa",id1,mid1,"46.10")]
                 else [] *)
                 else []
              |  _ -> []
              ]
        | _ -> [] 
        ]
     | _ -> []
     ]
;

value init_relation_encoding_array () =
List.iter assign relations_encodings
where assign (ident,index) = 
relation_array.(index) := ident
;

value init_sentence_feature_variables morphs  = 
 List.iter 
 (fun m -> match m with 
     [ Wif (id,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_) -> do { (); finite_verb_in_sentence.val := id; if(total_wrds.val < id) then total_wrds.val := id else ()}
     | WaxXiwa (id,_,_,_,_,_,_,_,_,_,_,_)
     | Kqw (id,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_,_)
     | Avykqw (id,_,_,_,_,_,_,_,_,_,_,_)
     | AvywaxXiwa (id,_,_,_,_,_,_,_)-> if (total_wrds.val < id) then total_wrds.val := id else ()
     | Sup (id,_,_,rt,_,_,_,_,_,_) -> do {
                 if (total_wrds.val < id) then total_wrds.val := id else ()
                 ;if rt="yax" then yax_pos.val := id else ()
                 ;if rt="yAvaw" then yAvaw_pos.val := id else ()
                 ;if rt="wAvaw" then wAvaw_pos.val := id else ()
                 }
     | Avy (id,_,word,_,_,_,_) -> do {
                 if (total_wrds.val < id) then total_wrds.val := id else ()
                ;match word with
          [ "iwi" -> do { (); iwi_pos.val := id;}
          (*| "evam" -> do { (); evam_pos.val := id;}*)
          | "yaxA" -> do { (); yaxA_pos.val := id;}
          | "yaWA" -> do { (); yaWA_pos.val := id;}
          | "waxA" -> do { (); waxA_pos.val := id;}
          | "yawra" -> do { (); yawra_pos.val := id;}
          | "wawra" -> do { (); wawra_pos.val := id;}
          | "yAvaw" -> do { (); yAvaw_pos.val := id;}
          | "wAvaw" -> do { (); wAvaw_pos.val := id;}
          | "yaxi" -> do { (); yaxi_pos.val := id;}
          | "yawaH" -> do { (); yawaH_pos.val := id;}
          | "warhi" -> do { (); warhi_pos.val := id;}
          | "waw" -> do { (); waw_pos.val := id;}
          | "awaH" -> do { (); awaH_pos.val := id;}
          | "wawaH" -> do { (); wawaH_pos.val := id;}
          | "cew" -> do { (); cew_pos.val := id;}
          | "yaxyapi" -> do { (); yaxyapi_pos.val := id;}
          | "waWApi" -> do { (); waWApi_pos.val := id;}
          | "waWA" -> do { (); waWA_pos.val := id;}
          | "aWApi" -> do { (); aWApi_pos.val := id;}
          | "aWa" -> do { (); aWa_pos.val := id;}
          | "yaw" -> do { (); yaw_pos.val := id;}
          | "yasmAw" -> do { (); yasmAw_pos.val := id;}
          | "wasmAw" -> do { (); wasmAw_pos.val := id;}
          | "hi" -> do { (); hi_pos.val := id;}
          | "kinwu" -> do { (); kinwu_pos.val := id;}
          | "paranwu" -> do { (); paranwu_pos.val := id;}
          | _ -> ()
          ] 
          }
     ] 
 ) morphs
;

value all_rules2 = 
[
rlwifkarwA_karma; rlkqwkarwA_karma;
rlanaBihiwe; rlapAxAna_wasil; rlAvy_kriyAviSeRaNam_or_aXikaraNam; rlBAvalakRaNa_sapwamI1; rlBAvalakRaNa_sapwamI2; rlpUrvakAla; rlwumun; rlkwa_as; rlsamAnakAla; rlviSeRaNam; rlavy_viSeRaNam; rlvIpsA; rlsamboXanasUcakam; rlnirXAraNam; rlupapaxa_viSeRaNa; rlupapaxa; rlsambanXa1; rlsambanXa2; rlsambanXa3; rlavy_wif_mA; rlavy_wifkqw_special;
(* rl_kAraka_RaRTI1; rl_kAraka_RaRTI2; rl_kAraka_RaRTI3; *) 
rl_nAma; rlAvykqw_karma; rlevamkarma; rliwi; rlRaRTIsambanXaH; rlviRayAXikaraNam; rlhewuprayoge; 
(*rlupapaxa_aXikaraNa; *)
rlniwya_sambanXa_avy; rlniwya_sambanXa_sup; rl_initial_avy; rl_ca; rlsent_beginning_connectives; (*rlparimANa_viSeRaNam;*) rl_exclamatory1
  ]
;
value all_rules3 = [rlkarwqsamAnAXikaraNam; rlkarmasamAnAXikaraNam; rlwAxarWya; rlvAkyakarma; rlvAkyakarma1; rlyaxi_warhi_cew; rlsent_connectives; rlupamAna_upameya_sup; rlca_samucciwa; rl_exclamatory2]
;

value kAraka_engine3 morphs text_type =
  loop1 [] morphs 
  where rec loop1 acc1 = fun
       [ [] -> acc1
       | [ m1 :: r1 ] -> 
             let relations_m1 = loop2 [] morphs
             where rec loop2 acc2 = fun
            [ [] -> acc2
            | [ m2 :: r2 ] -> 
                     let relations_m1_m2 = loop3 [] morphs
                     where rec loop3 acc3 = fun
                     [ [] -> if distinct_2 m1 m2  then
                               List.fold_left collate acc2 all_rules2 where
                               collate rls rule = match rule m1 m2 text_type with
                               [ [] -> List2.union rls acc3
                               | r -> List.append r rls
                               ]
                             else acc3
                     | [m3 :: r3 ] -> 
                            if distinct_3 m1 m2 m3 then
                               let relations_m1_m2_m3 = 
                                 List.fold_left collate acc3 all_rules3 where
                                 collate rls rule = match rule m1 m2 m3 text_type with
                                 [ [] -> rls
                                 | r -> List2.union r rls
                                 ] in loop3 (List2.union relations_m1_m2_m3 acc3) r3
                            else loop3 acc3 r3
                    ] in loop2 (List2.union relations_m1_m2 acc2) r2
            ] in loop1 (List2.union relations_m1 acc1) r1
       ] 
;

value process morphs text_type = 
  let offline_file = "graph.txt"  in
  let cho = open_out offline_file in do
  { (* List.iter print_morph_id morphs *) (* we print the input for verification *)
   let rel_lst = List.sort_uniq compare (kAraka_engine3 morphs text_type) in
    let sorted_lst = List.rev (List.sort_uniq compare rel_lst) in  do
    { List.iter (print_relation cho) sorted_lst
    ; flush cho
    ; close_out cho
    ; let tpl_lst = mk_tuple_lst [] sorted_lst in 
        Constraint.solver tpl_lst 
    }
    (*List.iter Constraint.print_relation tpl_lst*)
  }
;

(* value text_type arg1 = if arg1="prose" || arg1="poetry" then arg1 else failwith "Incorrect Argument\n"
; 
*)

value main () = if (Array.length Sys.argv < 2 ) then do
           { print_string "\n\n"
           ; print_string "Usage: ./build_graph prose|poetry\n\n"
           ; failwith "Parsing aborted\n"
           } 
        else do
           { init_relation_encoding_array()
           ; let _ = relations_encodings
           ; let _ = afgavikaara_list
           ; let _ = nirXAraNa_list
           ; let text_type = Sys.argv.(1)
             and morphs = analyse (Stream.of_channel stdin) in
             do
             { init_sentence_feature_variables morphs
             ; process morphs text_type
             }
           }
;
main()
;
