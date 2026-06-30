// This is the main file that relies on template.typ for
// settings; available from https://github.com/ckunte/note
// 2025 C Kunte
#import "inc/template.typ": *
#show: note.with(
  title: [Set python up],
  subtitle: [in Windows 11, macOS, and Linux],
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

There is more than one way to install python~@pyf. Written with an end-user in mind who is not a professional programmer, this brief note uses virtual environments for the setup, employing #link("https://github.com/astral-sh/uv")[uv], a package manager by Astral~@astral, covering Windows 11, macOS, and Linux.

= Baseline setup <s_win>

Set the foundation layer up as follows, using #link("https://github.com/astral-sh/uv")[uv] throughout. Each platform's steps are to be run at its native terminal --- step-wise copy-paste below at the terminal prompt, and hit Enter key. The use of the `--system-certs` switch in the steps below is optional, but useful especially if SSL certificate checks break in a corporate environment due to, say, packet inspection monitoring software deployed; this applies equally on Windows, macOS, and Linux, since all three can sit behind the same corporate proxy.

== Windows

+ Install uv (run in Windows PowerShell):

  ```ps1
  powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
  ```

  #v(-0.5em)
  _Keep this as a single line. PowerShell's backtick line-continuation is sensitive to invisible trailing whitespace, and a stray space after the backtick silently breaks the command --- a single line avoids that failure mode entirely._

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
  uv pip install --system-certs numpy matplotlib pandas scipy
  ```

  #v(-0.5em)
  _Note: `uv install` is not a valid uv command --- the package-installation subcommand is `uv pip install`. With the virtual environment activated (previous step), this installs directly into it._

+ Verify packages are installed (all below as one line):

  ```ps1
  python -c "import pandas,numpy,scipy,matplotlib; print('OK')"
  ```

+ Check which python the environment uses:

  ```ps1
  python -c "import sys; print(sys.executable)"
  ```

== macOS and Linux

The steps mirror the Windows ones above, with shell syntax adjusted for `sh`/`zsh`/`bash`. These run in Terminal (macOS) or any shell terminal (Linux).

+ Install uv:

  ```sh
  curl -LsSf https://astral.sh/uv/install.sh | sh
  ```

  #v(-0.5em)
  _If `curl` is unavailable (some minimal Linux images), substitute: `wget -qO- https://astral.sh/uv/install.sh | sh`. After installing, open a new terminal window (or `source` the shell profile the installer updated) so `uv` is on `$PATH`._

+ Install python (say, v3.14):

  ```sh
  uv --system-certs python install 3.14
  ```

+ See where it is installed:

  ```sh
  uv python list
  ```

+ Create one (global) virtual environment:

  ```sh
  uv venv $HOME/.venvs/global --python 3.14
  ```

+ Activate the virtual environment. Every new shell session requires this step to be run:

  ```sh
  source $HOME/.venvs/global/bin/activate
  ```

  #v(-0.5em)
  _On Linux, if the default shell is `fish` rather than `bash`/`zsh`, use `source $HOME/.venvs/global/bin/activate.fish` instead._

+ Install python packages, say, numpy~@numpy, matplotlib~@matplotlib, pandas~@pandas, and scipy~@scipy:

  ```sh
  uv pip install --system-certs numpy matplotlib pandas scipy
  ```

+ Verify packages are installed (all below as one line):

  ```sh
  python3 -c "import pandas,numpy,scipy,matplotlib; print('OK')"
  ```

+ Check which python the environment uses:

  ```sh
  python3 -c "import sys; print(sys.executable)"
  ```

= Setup in apps

Extending the baseline setup, python can be configured to work in, say, the following apps.

== Thonny

In Thonny~@thonny, all one needs to do is set the location of python executable, like so:

#figure(
  image("inc/thonny.png", width: 93%),
  caption: [Set python executable path in Thonny]
) <path>

On Windows, the path should be as below, where `%USERNAME%` is the Windows username as shown in the example shown in @path:
```
C:/Users/%USERNAME%/.venvs/global/Scripts/python.exe
```

On macOS and Linux, the equivalent path is:
```
/home/<username>/.venvs/global/bin/python3
```
#v(-0.5em)
_On macOS this is typically under `/Users/<username>/...` rather than `/home/<username>/...`._

== Sublime Text

A custom build file may be setup (only once) in Sublime Text~@subl. The contents differ slightly by platform, since `shell_cmd` and path separators are platform-specific.

On Windows:

```sublime-build
{   
  "shell_cmd" : "uv run --python C:\\Users\\%USERNAME%\\.venvs\\global\\Scripts\\python.exe \"$file_name\"",
  "selector" : "source.py",
  "path" : "C:\\Users\\%USERNAME%\\.local\\bin;$path",
  "working_dir" : "$file_path"
}
```

On macOS and Linux:

```sublime-build
{   
  "shell_cmd" : "uv run --python $HOME/.venvs/global/bin/python3 \"$file_name\"",
  "selector" : "source.py",
  "path" : "$HOME/.local/bin:$path",
  "working_dir" : "$file_path"
}
```

Ensure value of each key is a single line, e.g., a key is `shell_cmd`, and its corresponding value is provided after `:` until `,` at the end, except the last key item of course:

With this setup under _Tools #sym.arrow.r Build system #sym.arrow.r New Build System..._, copy-paste the relevant block for the platform in use, assuming the paths are as installed, and save this file as, say, `Python-uv.sublime-build`. This creates a menu item under _Tools #sym.arrow.r Build system_. Select _Python-uv_ and hit _Build_.

== Notepad++

In Notepad++~@npp, it is suggested to use NppExec Plug-in to create a build file.#footnote[Note Notepad++ is Windows-only]

+ Install NppExec via _Plugins #sym.arrow.r Plugins Admin #sym.arrow.r NppExec_.

+ Create a script (with the following contents in it) using _Plugins #sym.arrow.r NppExec #sym.arrow.r Execute..._ (ensure each line a single line in the below).

  ```cmd
  cd "$(CURRENT_DIRECTORY)"

  uv run --python "C:\Users\%USERNAME%\.venvs\global\Scripts\python.exe" "$(FULL_CURRENT_PATH)"
  ```

#bibliography("inc/ref.yaml")
