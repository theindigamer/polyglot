let prelude = https://raw.githubusercontent.com/vmchale/atspkg/master/ats-pkg/dhall/atspkg-prelude.dhall
in

let not = https://ipfs.io/ipfs/QmdtKd5Q7tebdo6rXfZed4kN6DXmErRQHJ4PsNCtca9GbB/Prelude/Bool/not
in

let cross = False
in

let parallel = True
in

let srcFile = 
  if parallel 
    then "polyglot" 
    else "compat"
in

let deps =
  if parallel 
    then [ "concurrency", "specats" ] 
    else [ "specats" ]
in

let native =
  if not cross
    then [ "-mtune=native" ]
    else ([] : List Text)
in

prelude.default ⫽ 
  { bin =
    [
      prelude.bin ⫽ 
      { src = "src/${srcFile}.dats"
      , target = "target/poly"
      , gcBin = True
      , libs = [ "pthread" ]
      }
    ]
  , test =
    [ prelude.bin ⫽ 
      { src = "test/test.dats"
      , target = "target/test"
      , gcBin = True
      }
    ]
  , man = [ "man/poly.md" ] : Optional Text
  , completions = [ "compleat/poly.usage" ] : Optional Text
  , compiler = [0,3,10]
  , dependencies = prelude.mapPlainDeps deps
  , cflags = [ "-flto", "-O2" ] # native
  , debPkg =
    [
      { package = "polyglot"
      , version = [0,4,29]
      , maintainer = "Vanessa McHale <vamchale@gmail.com>"
      , description = "Determine project contents"
      , target = "target/polyglot.deb"
      , manpage = "man/poly.1"
      , binaries = [ "target/poly" ]
      }
    ] : Optional prelude.Debian
  }
