// This is the main file that relies on template.typ for
// settings; available from https://github.com/ckunte/note
// 2025 C Kunte
#import "inc/template.typ": *
#show: note.with(
  title: [Set python up in Windows 11],
//subtitle: [in Windows 11, macOS, and linux],
  author: "C Kunte",
  paper: "a5",
)

// powershell syntax highlighting enabled
#show raw.where(lang: "powershell"): set raw(syntaxes: "inc/PowerShell.sublime-syntax")
#show raw.where(lang: "ps1"): set raw(syntaxes: "inc/PowerShell.sublime-syntax")

// content from here-on

// TOC
#include("inc/toc.typ")

// consider setting heading numbers here-on
#set heading(numbering: "1.1")

= Introduction

There is more than one way to install python~@pyf on Windows 11. Written with an end-user in mind who is not a professional programmer, this brief note uses virtual environments for the setup, employing #link("https://github.com/astral-sh/uv")[uv], a package manager by Astral~@astral.

= Baseline setup <s_win>

Set the foundation layer up as follows. The steps are to be run in Windows PowerShell terminal --- step-wise copy-paste below at the terminal prompt, and hit Enter key. The use of the `--system-certs` switch in the steps below is optional, but useful especially if SSL certificate checks break in a corporate environment due to, say, packet inspection monitoring software deployed.

+ Install uv:

  ```ps1
  powershell -ExecutionPolicy ByPass -c `
  "irm https://astral.sh | iex"
  ```

+ Install python (say, v3.14):

  ```ps1
  uv --system-certs python install 3.14  
  ```

+ See where it is installed:

  ```ps1
  uv python list
  ```

+ Create one (global) virtual environment:

  ```ps1
  uv venv $HOME\.venvs\global --python 3.14
  ```

+ Activate the virtual environment. If python installed this way is run in a Terminal, then every new session requires this step to be run:

  ```ps1
  & $HOME\.venvs\global\Scripts\Activate.ps1
  ```

+ Install python packages, say, numpy~@numpy, matplotlib~@matplotlib, pandas~@pandas, and scipy~@scipy:

  ```ps1
  uv --system-certs install numpy matplotlib pandas scipy
  ```

+ Verify packages are installed (all below as one line):

  ```ps1
  python -c "import pandas,numpy,scipy,matplotlib; print('OK')"
  ```

+ Check which python the environment uses:

  ```ps1
  python -c "import sys; print(sys.executable)"
  ```

= Setup in apps

Extending the baseline setup, python can be configured to work in, say, the following apps.

== Thonny

In Thonny~@thonny, all one needs to do is set the location of python executable, like so:

#figure(
  image("inc/thonny.png", width: 93%),
  caption: [Set python executable path in Thonny]
) <path>

The path should be as below, where `%USERNAME%` is the Windows username as shown in the example shown in @path:
```
C:/Users/%USERNAME%/.venvs/global/Scripts/python.exe
```

== Sublime Text

A custom build file may be setup (only once) in Sublime Text~@subl, whose contents may be as follows. 

```sublime-build
{   
  "shell_cmd" : "uv run --python C:\\Users\\%USERNAME%\\.venvs\\global\\Scripts\\python.exe \"$file_name\"",
  "selector" : "source.py",
  "path" : "C:\\Users\\%USERNAME%\\.local\\bin;$path",
  "working_dir" : "$file_path"
}
```

Ensure value of each key is a single line, e.g., a key is `shell_cmd`, and its corresponding value is provided after `:` until `,` at the end, except the last key item of course:

With this setup under _Tools #sym.arrow.r Build system #sym.arrow.r New Build System..._, copy-paste the block, assuming the paths are as installed, and save this file as, say, `Python-uv.sublime-build`. This creates a menu item under _Tools #sym.arrow.r Build system_. Select _Python-uv_ and hit _Build_.

== Notepad++

In Notepad++~@npp, it is suggested to use NppExec Plug-in to create a build file.

+ Install NppExec via _Plugins #sym.arrow.r Plugins Admin #sym.arrow.r NppExec_.

+ Create a script (with the following contents in it) using _Plugins #sym.arrow.r NppExec #sym.arrow.r Execute..._ (ensure each line a single line in the below).

  ```cmd
  cd "$(CURRENT_DIRECTORY)"

  uv run --python "C:\Users\%USERNAME%\.venvs\global\Scripts\python.exe" "$(FULL_CURRENT_PATH)"
  ```

#bibliography("inc/ref.yaml")
