  λ(isLaptop : Bool)
→ let binds = ./binds.dhall

  let exec = ./startup.dhall

  let other = ./other.dhall

  let bar = ./bar.dhall (if isLaptop then "#02395AAA" else "#183938AA")

  let id = λ(t : Type) → λ(a : t) → a

  let lines =
		  λ(l : List Text)
		→ List/fold Text l Text (λ(a : Text) → λ(b : Text) → b ++ "\n" ++ a) ""

  in  ''
	   ${lines exec.exec}
	   ${lines exec.execAlways}
	   ${lines binds.moves}
	   ${lines binds.workspaces}
	   ${lines binds.binds}
	   mode "resize" {
	  ${lines binds.resize}
	   }

	   font ${other.font}
	   ${other.floatMod}
	   ${other.window}
	   ${lines other.windowGuides}

	   ${bar}
	   ''
