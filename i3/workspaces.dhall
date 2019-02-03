let map = https://prelude.dhall-lang.org/List/map

let t = ./types.dhall

let Direction = t.Direction

let Workspace = t.Workspace

let mkWSRecord = λ(ws : Text) → { k = ws, w = ws }

let simpleWorkspaces =
		[ { k = "0", w = "10" } ]
	  # map
		Text
		Workspace
		mkWSRecord
		[ "1", "2", "3", "4", "5", "6", "7", "8", "9" ]

let mkWorkSpace =
		λ(bi : Text → Text → Text)
	  → λ(prefix : Text)
	  → λ(ls : List Workspace)
	  → List/fold
		Workspace
		ls
		(List Text)
		(   λ(a : Workspace)
		  → λ(b : List Text)
		  → b # [ bi a.k "${prefix} \"${a.w}\"" ]
		)
		([] : List Text)

in  { mkWorkSpace = mkWorkSpace, simpleWorkspaces = simpleWorkspaces }