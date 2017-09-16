(defun ama-process-one-line01 (line)
  (let (alst blst name txt)
    (message "line = %S" line)
    (setq alst (split-string line ";"))
    (setq blst (split-string (car alst)))
    (setq name (car (last blst)))
    (if (string-match "int" line)
        (setq txt (format " %s i32 %s i32 " name name))
      (if (string-match "short" line)
          (setq txt (format " %s i16 %s i32 " name name))
        ))
    (insert "\n")
    (insert txt)
    ))

(defun ama-process-one-line (line)
  (let (alst blst name txt)
    (message "line = %S" line)
    (setq alst (split-string line ";"))
    (setq blst (split-string (car alst)))
    (setq name (car (last blst)))
    (if (string-match "int" line)
        (setq txt (format "  x.add (AttrMappingItem (%S, D_INT32, %S, D_INT32));" name name))
      (if (string-match "short" line)
          (setq txt (format "  x.add (AttrMappingItem (%S, D_INT16, %S, D_INT32));" name name))
        ))
    (insert "\n")
    (insert txt)
    ))

;;(ama-process-one-line "int gelev;	/* receiver group elevation from sea level")

(defun ama-segy-attr-mapping (pos1 pos2)
  (interactive "r")
  (setq off 0)
  (let (lines line alst alst2 txt)
    (setq lines (ama-region-lines pos1 pos2))
    (dolist (line lines)
      (ama-process-one-line line))))

(global-set-key (kbd "C-c C-x") 'ama-segy-attr-mapping)

int tracl;
    int tracr;
    int fldr;
    int tracf;
    int ep;
    int cdp;
    int cdpt;
    short trid;	/* trace identification code:
    short nvs;	/* number of vertically summed traces (see vscode
    short nhs;	/* number of horizontally summed traces (see vscode
    short duse;	/* data use:
    int offset;	/* distance from source point to receiver
    int gelev;	/* receiver group elevation from sea level
    int selev;	/* source elevation from sea level
    int sdepth;	/* source depth (positive) */
    int gdel;	/* datum elevation at receiver group */
    int sdel;	/* datum elevation at source */
    int swdep;	/* water depth at source */
    int gwdep;	/* water depth at receiver group */
    short scalel;	/* scale factor for previous 7 entries
    short scalco;	/* scale factor for next 4 entries
    int  sx;	/* X source coordinate */
    int  sy;	/* Y source coordinate */
    int  gx;	/* X group coordinate */
    int  gy;	/* Y group coordinate */
    short counit;	/* coordinate units code:
    short wevel;	/* weathering velocity */
    short swevel;	/* subweathering velocity */
    short sut;	/* uphole time at source */
    short gut;	/* uphole time at receiver group */
    short sstat;	/* source static correction */
    short gstat;	/* group static correction */
    short tstat;	/* total static applied */
    short laga;	/* lag time A, time in ms between end of 240-
    short lagb;	/* lag time B, time in ms between the time break
    short delrt;	/* delay recording time, time in ms between
    short muts;	/* mute time--start */
    short mute;	/* mute time--end */
    unsigned short ns;	/* number of samples in this trace */
    unsigned short dt;	/* sample interval; in micro-seconds */
    short gain;	/* gain type of field instruments code:
    short igc;	/* instrument gain constant */
    short igi;	/* instrument early or initial gain */
    short corr;	/* correlated:
    short sfs;	/* sweep frequency at start */
    short sfe;	/* sweep frequency at end */
    short slen;	/* sweep length in ms */
    short styp;	/* sweep type code:
    short stas;	/* sweep trace length at start in ms */
    short stae;	/* sweep trace length at end in ms */
    short tatyp;	/* taper type: 1=linear, 2=cos^2, 3=other */
    short afilf;	/* alias filter frequency if used */
    short afils;	/* alias filter slope */
    short nofilf;	/* notch filter frequency if used */
    short nofils;	/* notch filter slope */
    short lcf;	/* low cut frequency if used */
    short hcf;	/* high cut frequncy if used */
    short lcs;	/* low cut slope */
    short hcs;	/* high cut slope */
    short year;	/* year data recorded */
    short day;	/* day of year */
    short hour;	/* hour of day (24 hour clock) */
    short minute;	/* minute of hour */
    short sec;	/* second of minute */
    short timbas;	/* time basis code:
    short trwf;	/* trace weighting factor, defined as 1/2^N
    short grnors;	/* geophone group number of roll switch
    short grnofr;	/* geophone group number of trace one within
    short grnlof;	/* geophone group number of last trace within
    short gaps;	/* gap size (total number of groups dropped) */
    short otrav;	/* overtravel taper code:
    int xcdp;
    int ycdp;
    int iline;
    int xline;
    int shotNumber;
    short shotScale;
    short munit;
    int  unused[9];


  x.add (AttrMappingItem ("tracl", D_INT32, "tracl", D_INT32));
  x.add (AttrMappingItem ("tracr", D_INT32, "tracr", D_INT32));
  x.add (AttrMappingItem ("fldr", D_INT32, "fldr", D_INT32));
  x.add (AttrMappingItem ("tracf", D_INT32, "tracf", D_INT32));
  x.add (AttrMappingItem ("ep", D_INT32, "ep", D_INT32));
  x.add (AttrMappingItem ("cdp", D_INT32, "cdp", D_INT32));
  x.add (AttrMappingItem ("cdpt", D_INT32, "cdpt", D_INT32));
  x.add (AttrMappingItem ("trid", D_INT16, "trid", D_INT32));
  x.add (AttrMappingItem ("nvs", D_INT16, "nvs", D_INT32));
  x.add (AttrMappingItem ("nhs", D_INT16, "nhs", D_INT32));
  x.add (AttrMappingItem ("duse", D_INT16, "duse", D_INT32));
  x.add (AttrMappingItem ("offset", D_INT32, "offset", D_INT32));
  x.add (AttrMappingItem ("gelev", D_INT32, "gelev", D_INT32));
  x.add (AttrMappingItem ("selev", D_INT32, "selev", D_INT32));
  x.add (AttrMappingItem ("sdepth", D_INT32, "sdepth", D_INT32));
  x.add (AttrMappingItem ("gdel", D_INT32, "gdel", D_INT32));
  x.add (AttrMappingItem ("sdel", D_INT32, "sdel", D_INT32));
  x.add (AttrMappingItem ("swdep", D_INT32, "swdep", D_INT32));
  x.add (AttrMappingItem ("gwdep", D_INT32, "gwdep", D_INT32));
  x.add (AttrMappingItem ("scalel", D_INT16, "scalel", D_INT32));
  x.add (AttrMappingItem ("scalco", D_INT16, "scalco", D_INT32));
  x.add (AttrMappingItem ("sx", D_INT32, "sx", D_INT32));
  x.add (AttrMappingItem ("sy", D_INT32, "sy", D_INT32));
  x.add (AttrMappingItem ("gx", D_INT32, "gx", D_INT32));
  x.add (AttrMappingItem ("gy", D_INT32, "gy", D_INT32));
  x.add (AttrMappingItem ("counit", D_INT16, "counit", D_INT32));
  x.add (AttrMappingItem ("wevel", D_INT16, "wevel", D_INT32));
  x.add (AttrMappingItem ("swevel", D_INT16, "swevel", D_INT32));
  x.add (AttrMappingItem ("sut", D_INT16, "sut", D_INT32));
  x.add (AttrMappingItem ("gut", D_INT16, "gut", D_INT32));
  x.add (AttrMappingItem ("sstat", D_INT16, "sstat", D_INT32));
  x.add (AttrMappingItem ("gstat", D_INT16, "gstat", D_INT32));
  x.add (AttrMappingItem ("tstat", D_INT16, "tstat", D_INT32));
  x.add (AttrMappingItem ("laga", D_INT16, "laga", D_INT32));
  x.add (AttrMappingItem ("lagb", D_INT16, "lagb", D_INT32));
  x.add (AttrMappingItem ("delrt", D_INT16, "delrt", D_INT32));
  x.add (AttrMappingItem ("muts", D_INT16, "muts", D_INT32));
  x.add (AttrMappingItem ("mute", D_INT16, "mute", D_INT32));
  x.add (AttrMappingItem ("ns", D_INT16, "ns", D_INT32));
  x.add (AttrMappingItem ("dt", D_INT32, "dt", D_INT32));
  x.add (AttrMappingItem ("gain", D_INT16, "gain", D_INT32));
  x.add (AttrMappingItem ("igc", D_INT16, "igc", D_INT32));
  x.add (AttrMappingItem ("igi", D_INT16, "igi", D_INT32));
  x.add (AttrMappingItem ("corr", D_INT16, "corr", D_INT32));
  x.add (AttrMappingItem ("sfs", D_INT16, "sfs", D_INT32));
  x.add (AttrMappingItem ("sfe", D_INT16, "sfe", D_INT32));
  x.add (AttrMappingItem ("slen", D_INT16, "slen", D_INT32));
  x.add (AttrMappingItem ("styp", D_INT16, "styp", D_INT32));
  x.add (AttrMappingItem ("stas", D_INT16, "stas", D_INT32));
  x.add (AttrMappingItem ("stae", D_INT16, "stae", D_INT32));
  x.add (AttrMappingItem ("tatyp", D_INT16, "tatyp", D_INT32));
  x.add (AttrMappingItem ("afilf", D_INT16, "afilf", D_INT32));
  x.add (AttrMappingItem ("afils", D_INT16, "afils", D_INT32));
  x.add (AttrMappingItem ("nofilf", D_INT16, "nofilf", D_INT32));
  x.add (AttrMappingItem ("nofils", D_INT16, "nofils", D_INT32));
  x.add (AttrMappingItem ("lcf", D_INT16, "lcf", D_INT32));
  x.add (AttrMappingItem ("hcf", D_INT16, "hcf", D_INT32));
  x.add (AttrMappingItem ("lcs", D_INT16, "lcs", D_INT32));
  x.add (AttrMappingItem ("hcs", D_INT16, "hcs", D_INT32));
  x.add (AttrMappingItem ("year", D_INT16, "year", D_INT32));
  x.add (AttrMappingItem ("day", D_INT16, "day", D_INT32));
  x.add (AttrMappingItem ("hour", D_INT16, "hour", D_INT32));
  x.add (AttrMappingItem ("minute", D_INT16, "minute", D_INT32));
  x.add (AttrMappingItem ("sec", D_INT16, "sec", D_INT32));
  x.add (AttrMappingItem ("timbas", D_INT16, "timbas", D_INT32));
  x.add (AttrMappingItem ("trwf", D_INT16, "trwf", D_INT32));
  x.add (AttrMappingItem ("grnors", D_INT16, "grnors", D_INT32));
  x.add (AttrMappingItem ("grnofr", D_INT16, "grnofr", D_INT32));
  x.add (AttrMappingItem ("grnlof", D_INT16, "grnlof", D_INT32));
  x.add (AttrMappingItem ("gaps", D_INT16, "gaps", D_INT32));
  x.add (AttrMappingItem ("otrav", D_INT16, "otrav", D_INT32));
  x.add (AttrMappingItem ("xcdp", D_INT32, "xcdp", D_INT32));
  x.add (AttrMappingItem ("ycdp", D_INT32, "ycdp", D_INT32));
  x.add (AttrMappingItem ("iline", D_INT32, "iline", D_INT32));
  x.add (AttrMappingItem ("xline", D_INT32, "xline", D_INT32));
  x.add (AttrMappingItem ("shotNumber", D_INT32, "shotNumber", D_INT32));
  x.add (AttrMappingItem ("shotScale", D_INT16, "shotScale", D_INT32));
  x.add (AttrMappingItem ("munit", D_INT16, "munit", D_INT32));
  x.add (AttrMappingItem ("unused[9]", D_INT32, "unused[9]", D_INT32));
