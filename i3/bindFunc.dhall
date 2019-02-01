{-
Direction:
	Represents a direction you can move in. d is the key and a is the action.
	For example, { d = h, a = right}

bindAny:
	A generic keybinding function. Keys is a non-empty list where h is the head
	and t is the tail. Only use if none of the other binds work.

bind family:
	bind, without any prefix, binds a given key to mod+key.
	The e prefix means that the command is external and needs to be wrapped in
	an exec block.
	The s prefix means that to use mod+Shift instead of just mod.
	bindNoMod does what the name implies.

mkDirectionGeneric
	A function for creating a family of keybinding. Useful for things like
	binding all of the resize keys in one function call.

mkDirection
	A specialization of the generic version for when you want some text
	followed by the directions action. Useful for move keys.

mkWorkspaces
	Creates keybindings for all of your workspaces with some prefix
	before the workspace name. The first parameter is a bind function.
-}
let Direction = { d : Text, a : Text }

in    λ(mod : Text)
	→ λ(directions : List Direction)
	→ let bindAny =
			  λ(keys : { h : Text, t : List Text })
			→ λ(command : Text)
			→ ''
			  bindsym ${List/fold
						Text
						keys.t
						Text
						(λ(a : Text) → λ(b : Text) → b ++ "+" ++ a)
						keys.h} ${command}
			  ''

	  let bind = λ(key : Text) → bindAny { h = mod, t = [ key ] }

	  let mkExec = ./exec.dhall

	  let eBind =
			  λ(key : Text)
			→ λ(command : Text)
			→ bindAny { h = mod, t = [ key ] } (mkExec command)

	  let bindNoMod =
			  λ(key : Text)
			→ λ(command : Text)
			→ bindAny { h = key, t = [] : List Text } (mkExec command)

	  let sBind = λ(key : Text) → bindAny { h = mod, t = [ key, "Shift" ] }

	  let eSBind =
			  λ(key : Text)
			→ λ(command : Text)
			→ bindAny { h = mod, t = [ key, "Shift" ] } (mkExec command)

	  let mkWorkSpace =
			  λ(bi : Text → Text → Text)
			→ λ(prefix : Text)
			→   [ bi "0" "${prefix} 10" ]
			  # List/fold
				Text
				[ "1", "2", "3", "4", "5", "6", "7", "8", "9" ]
				(List Text)
				(λ(a : Text) → λ(b : List Text) → b # [ bi a "${prefix} ${a}" ])
				([] : List Text)

	  let mkDirectionGeneric =
			  λ(bi : Text → Text → Text)
			→ λ(command : Direction → Text)
			→ List/fold
			  Direction
			  directions
			  (List Text)
			  (λ(a : Direction) → λ(b : List Text) → b # [ bi a.d (command a) ])
			  ([] : List Text)

	  let mkDirection =
			  λ(bi : Text → Text → Text)
			→ λ(command : Text)
			→ mkDirectionGeneric bi (λ(a : Direction) → "${command} ${a.a}")

	  in  { bindAny =
			  bindAny
		  , bind =
			  bind
		  , bindNoMod =
			  bindNoMod
		  , sBind =
			  sBind
		  , eBind =
			  eBind
		  , eSBind =
			  eSBind
		  , mkDirectionGeneric =
			  mkDirectionGeneric
		  , mkDirection =
			  mkDirection
		  , mkWorkSpace =
			  mkWorkSpace
		  }